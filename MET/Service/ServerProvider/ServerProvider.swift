//
//  ServerProvider.swift
//  MET
//
//  Created by Django on 3/2/22.
//

import Moya
import RxSwift
import PromiseKit
import Alamofire

/// Server Provider
public final class ServerProvider {
    /// change this variable to enable Stub or not, notice that it won't work if it's not DEBUG
    public static var shouldUseStubClosure: Bool = true

    /// Initializes a provider.
    public init(
        endpointClosure: @escaping MoyaProvider<ServerAPI>.EndpointClosure = MoyaProvider<ServerAPI>.defaultEndpointMapping,
        requestClosure: @escaping MoyaProvider<ServerAPI>.RequestClosure = MoyaProvider<ServerAPI>.defaultRequestMapping,
        stubClosure: MoyaProvider<ServerAPI>.StubClosure? = nil,
        callbackQueue: DispatchQueue? = nil,
        session: Alamofire.Session? = nil,
        plugins: [PluginType]? = nil,
        trackInflights: Bool = false
    ) {

        let stubClosureT: MoyaProvider<ServerAPI>.StubClosure
        #if DEBUG
        stubClosureT = stubClosure ?? (ServerProvider.shouldUseStubClosure ? MoyaProvider<ServerAPI>.delayedStub(3) : MoyaProvider<ServerAPI>.neverStub)
        #else
        stubClosureT = stubClosure ?? MoyaProvider<ServerAPI>.neverStub
        #endif

        let callbackQueueT = callbackQueue ?? .global()

        let sessionT = session ?? { () -> Session in
            // special setUp
            let requestInterceptor = ServerRequestInterceptor()
            let serverTrustManager = ServerTrusManager()
            let redirectHandler = ServerRedirectHandler()

            let configuration = URLSessionConfiguration.default
            configuration.headers = .default
            configuration.timeoutIntervalForRequest = 30

            return Session(configuration: configuration,
                           interceptor: requestInterceptor,
                           serverTrustManager: serverTrustManager,
                           redirectHandler: redirectHandler,
                           cachedResponseHandler: nil,
                           eventMonitors: [])
        }()

        let pluginsT = plugins ?? [NetWorksLoggerPlugin(),
                                   NetWorksActivityPlugin()]

        _provider = MoyaProvider<ServerAPI>(
            endpointClosure: endpointClosure,
            requestClosure: requestClosure,
            stubClosure: stubClosureT,
            callbackQueue: callbackQueueT,
            session: sessionT,
            plugins: pluginsT,
            trackInflights: trackInflights
        )
    }

    private let _disposeBag = DisposeBag()

    /// real provider to fire a request
    private let _provider: MoyaProvider<ServerAPI>

    /// request
    ///
    /// - Parameters:
    ///   - target: API type
    ///   - observeOn: observeOn
    ///   - subscribeOn: subscribeOn
    ///   - retryCount: retryCount
    /// - Returns: Promise returned
    public func request<T: ServerModelTypeRes>(
        target: ServerAPI,
        observeOn: ImmediateSchedulerType = ConcurrentDispatchQueueScheduler(queue: DispatchQueue.global()),
        subscribeOn: ImmediateSchedulerType = MainScheduler.instance,
        retryCount: Int = 0
    ) -> Promise<T> {
        return Promise { seal in
            _provider.rx
                .request(target, callbackQueue: DispatchQueue.global())
                .observeOn(observeOn)
                .map {
                    try $0
                        ._storeServerTimeIntervalDistance()
                        .filterSuccessfulStatusAndRedirectCodes()
                        .map(T.self)
                }
                .retryWhen { rxError -> Observable<Int> in
                    rxError.enumerated().flatMap { (index, error) -> Observable<Int> in
                        guard index <= retryCount else { // more than retry count
                            return Observable.error(error)
                        }
                        return Observable<Int>.create { observer -> Disposable in
                            // do some refresh token logic here
                            observer.onError(error)
                            return Disposables.create()
                        }
                    } }
                .subscribeOn(subscribeOn)
                .subscribe(
                    onSuccess: { seal.fulfill($0) },
                    onError: { seal.reject($0) }
                )
                .disposed(by: _disposeBag)
        }
    }
}

extension Response {
    fileprivate static let _formatter = DateFormatter().then {
        $0.locale = Locale(identifier: "en_US_POSIX")
        $0.dateFormat = "EEE, d MMM yyyy HH:mm:ss zzz"
    }

    /// _storeServerTimeIntervalDistance
    fileprivate func _storeServerTimeIntervalDistance() throws -> Response {
        #if DEBUG
        guard let serverTime = response?.allHeaderFields["Date"] as? String else {
            return self
        }
        if let serverDate = Response._formatter.date(from: serverTime) {
            let timeIntervalDistance = Date().timeIntervalSince1970 - serverDate.timeIntervalSince1970
            printDebug("timeIntervalDistance: \(timeIntervalDistance)")
        }
        return self
        #else
        return self
        #endif
    }
}

//
//  SecondPageVM.swift
//  MET
//
//  Created by Django on 3/7/22.
//

import RxSwift
import RxRelay
import RxCocoa
import PromiseKit

/// SecondPageVM
public final class SecondPageVM {
    deinit {
        printDebug("SecondPageVM deinit")
    }

    /// view state for ui layer
    public enum ViewState {
        case `init`
        case loading
        case success
        case failedWith(error: Error)
    }

    private let _disposeBag = DisposeBag()
    private let _serverProvider = ServerProvider()
    private let _viewStateRelay = BehaviorRelay<ViewState>(value: .`init`)
    private let _objectModelRelay = BehaviorRelay<ServerObjectModelRes?>(value: nil)
    private let _objectIdRelay = BehaviorRelay<Int?>(value: nil)

    /// the view state
    public let viewStateDriver: Driver<ViewState>
    /// the object model
    public let objectModelDriver: Driver<ServerObjectModelRes>

    public init() {
        viewStateDriver = _viewStateRelay.asDriver()
        objectModelDriver = _objectModelRelay.asDriver().compactMap { $0 }

        _objectIdRelay
            .compactMap { $0 }
            .bind { [weak self] in self?._getObjectWith(id: $0) }
            .disposed(by: _disposeBag)
    }
}

// MARK: - public funcs
extension SecondPageVM {
    /// accept the object id
    public func accept(
        objectId: Int
    ) {
        _objectIdRelay.accept(objectId)
    }
}

// MARK: - private funcs
// MARK: _getObjectWith
extension SecondPageVM {
    /// request the specific object
    private func _getObjectWith(id: Int) {
        _viewStateRelay.accept(.loading)

        // use promise for the request
        firstly { Guarantee { $0(id) } }
        .then(_getObject)
        .done(_handleObjectSucceed)
        .catch(_handleFailed)
    }
}

// MARK: _handleFailed
extension SecondPageVM {
    private func _handleFailed(
        with error: Error
    ) {
        printDebug(error)
        _viewStateRelay.accept(.failedWith(error: error))
    }
}

// MARK: _getObject
extension SecondPageVM {
    private func _getObject(
        with id: Int
    ) -> Promise<ServerObjectModelRes> {
        return _serverProvider
            .request(target: .getObject(id: id))
    }

    private func _handleObjectSucceed(
        with res: ServerObjectModelRes
    ) {
        _viewStateRelay.accept(.success)
        _objectModelRelay.accept(res)
    }
}

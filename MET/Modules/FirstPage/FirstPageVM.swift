//
//  FirstPageVM.swift
//  MET
//
//  Created by Django on 3/7/22.
//

import RxSwift
import RxRelay
import RxCocoa
import RxDataSources
import PromiseKit

/// FirstPageVM
public final class FirstPageVM {
    deinit {
        printDebug("FirstPageVM deinit")
    }

    /// the tableView section model for ui layer
    public typealias TableSection = SectionModel<String?, Int>

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
    private let _tableSectionsRelay = BehaviorRelay<[TableSection]>(value: [])
    private let _tableViewEmptyStateRelay = BehaviorRelay<Bool>(value: true)

    /// the view state
    public let viewStateDriver: Driver<ViewState>
    /// the tableview view empty state
    public let tableViewEmptyStateDriver: Driver<Bool>
    /// the tableView dataSource
    public let tableSectionsDriver: Driver<[TableSection]>
    /// to receive the search text
    public let searchTextRelay = BehaviorRelay<String>(value: .emptyString)

    public init() {
        viewStateDriver = _viewStateRelay.asDriver()
        tableSectionsDriver = _tableSectionsRelay.asDriver()
        tableViewEmptyStateDriver = _tableViewEmptyStateRelay.asDriver()

        /// triggle search using the search text
        /// if there would be more params, you can just zip them or combineLatest them
        searchTextRelay
            .skip(1)
            .map { $0._getSearchModelReq() }
            .bind { [weak self] in self?.getSearch(with: $0) }
            .disposed(by: _disposeBag)
    }
}

// MARK: - public funcs
extension FirstPageVM {
    /// request the search result
    public func getSearch(
        with modelReq: ServerSearchModelReq
    ) {
        _viewStateRelay.accept(.loading)

        // use promise for the request
        firstly { Guarantee { $0(modelReq) } }
        .then(_getSearch)
        .done(_handleSearchSucceed)
        .catch(_handleFailed)
    }
}

// MARK: - private funcs
// MARK: _handleFailed
extension FirstPageVM {
    private func _handleFailed(
        with error: Error
    ) {
        printDebug(error)
        _viewStateRelay.accept(.failedWith(error: error))
        _tableViewEmptyStateRelay.accept(_tableViewEmptyStateRelay.value)
    }
}

// MARK: _getSearch
extension FirstPageVM {
    private func _getSearch(
        with modelReq: ServerSearchModelReq
    ) -> Promise<ServerObjectsModelRes> {
        return _serverProvider
            .request(target: .getSearch(model: modelReq))
    }

    private func _handleSearchSucceed(
        with res: ServerObjectsModelRes
    ) {
        let resArr = res.objectIDs ?? []
        _viewStateRelay.accept(.success)
        _tableViewEmptyStateRelay.accept(resArr.isEmpty)
        _tableSectionsRelay.accept([TableSection(model: nil, items: resArr)])
    }
}

extension String {
    /// map a string to ServerSearchModelReq, you can add some param to customize the transformation
    /// - Returns: ServerSearchModelReq
    fileprivate func _getSearchModelReq(
        isHighlight: Bool? = nil,
        title: Bool? = nil,
        tags: Bool? = nil,
        departmentId: Int? = nil,
        isOnView: Bool? = nil,
        artistOrCulture: Bool? = nil,
        medium: String? = nil,
        hasImages: Bool? = nil,
        geoLocation: String? = nil,
        dateBegin: String? = nil,
        dateEnd: String? = nil
    ) -> ServerSearchModelReq {
        return ServerSearchModelReq(
            q: self,
            isHighlight: isHighlight,
            title: title,
            tags: tags,
            departmentId: departmentId,
            isOnView: isOnView,
            artistOrCulture: artistOrCulture,
            medium: medium,
            hasImages: hasImages,
            geoLocation: geoLocation,
            dateBegin: dateBegin,
            dateEnd: dateEnd
        )
    }
}

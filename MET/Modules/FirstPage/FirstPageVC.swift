//
//  FirstPageVC.swift
//  MET
//
//  Created by Django on 3/7/22.
//

import UIKit
import RxSwift
import RxRelay
import RxCocoa
import RxDataSources
import PromiseKit
import MJRefresh
import SDWebImage

/// the list vc to show weather
public final class FirstPageVC: UIViewController {
    deinit {
        printDebug("FirstPageVC deinit")
    }

    @IBOutlet private weak var _searchBar: UISearchBar!
    @IBOutlet private weak var _tableView: UITableView!
    private weak var _leftBarButtonItem: UIBarButtonItem?

    private let _viewModel = FirstPageVM()
    private let _disposeBag = DisposeBag()
}

// MARK: - Life cycle
extension FirstPageVC {
    public override func viewDidLoad() {
        super.viewDidLoad()

        title = "First Page"
        _setUpSubviews()
        _bindViewModel()
    }
}

// MARK: - private funcs
extension FirstPageVC {
    /// setup the subviews
    private func _setUpSubviews() {
        // set tht back button title
        navigationItem.backButtonTitle = "Search"

        // set tht leftBarButtonItem
        let leftBarButtonItem = UIBarButtonItem(
            title: "search",
            style: .plain,
            target: self,
            action: #selector(_onSearchTapped)
        )
        navigationItem.leftBarButtonItem = leftBarButtonItem
        _leftBarButtonItem = leftBarButtonItem

        // set the rightBarButtonItem
        let rightBarButtonItem = UIBarButtonItem(
            title: "clear all",
            style: .plain,
            target: self,
            action: #selector(_onClearTapped)
        )
        navigationItem.rightBarButtonItem = rightBarButtonItem

        // register the cell for table view
        let nibId = UINib(
            nibName: ._firstPageTableViewCell,
            bundle: Bundle.main
        )
        _tableView.register(
            nibId,
            forCellReuseIdentifier: ._firstPageTableViewCell
        )

        _tableView.mj_header = MJRefreshNormalHeader.init(refreshingBlock: { [weak self] in
            guard let searchText = self?._viewModel.searchTextRelay.value else { return }
            self?._viewModel.searchTextRelay.accept(searchText)
        })
    }

    /// bind data with ui
    private func _bindViewModel() {
        _viewModel.viewStateDriver
            .drive { [weak self] in self?._handleViewState($0) }
            .disposed(by: _disposeBag)

        _viewModel.tableViewEmptyStateDriver
            .drive  { [weak self] isEmpty in
                if isEmpty {
                    self?._tableView.showEmptyViewWith(message: "No results found.")
                } else {
                    self?._tableView.hideEmptyView()
                }
            }
            .disposed(by: _disposeBag)

        /// the dataSouce for tableview
        let dataSource = RxTableViewSectionedReloadDataSource<FirstPageVM.TableSection> { dataS, tableV, indexP, model in
            guard let cell = tableV.dequeueReusableCell(
                withIdentifier: ._firstPageTableViewCell,
                for: indexP
            ) as? FirstPageTableViewCell else {
                let assertMsg = "you should register cell be4 use"
                printDebug(assertMsg, assertMessage: assertMsg)
                return UITableViewCell()
            }
            cell.objectId = model
            cell.isEven = indexP.row % 2 == 0
            return cell
        }

        _viewModel.tableSectionsDriver
            .drive(_tableView.rx.items(dataSource: dataSource))
            .disposed(by: _disposeBag)

        /// handle tableView select
        _tableView.rx
            .modelSelected(Int.self)
            .asDriver()
            .drive { [weak self] in self?._handleModelSelected(with: $0) }
            .disposed(by: _disposeBag)
    }

    /// handle viewState
    private func _handleViewState(
        _ viewState: FirstPageVM.ViewState
    ) {
        switch viewState {
        case .`init`:
            break
        case .loading:
            _leftBarButtonItem?.isEnabled = false
            _leftBarButtonItem?.title = "wip..."
            view.makeActivity()
            _tableView.hideEmptyView()
        case .success:
            _tableView.mj_header?.endRefreshing()
            _leftBarButtonItem?.isEnabled = true
            _leftBarButtonItem?.title = "search"
            view.hideToast()
        case .failedWith(let err):
            _tableView.mj_header?.endRefreshing()
            _leftBarButtonItem?.isEnabled = true
            _leftBarButtonItem?.title = "search"
            view.hideToast()
            view.makeToast(err.errorDescription)
        }
    }

    /// handleModelSelected
    private func _handleModelSelected(
        with objectId: Int
    ) {
        let secondPageVC = SecondPageVC().then {
            $0.accept(objectId: objectId)
        }
        navigationController?.pushViewController(secondPageVC, animated: true)
    }
}

// MARK: - actions
extension FirstPageVC {
    @objc private func _onSearchTapped() {
        _viewModel.searchTextRelay.accept(_searchBar.text ?? .emptyString)
    }

    @objc private func _onClearTapped() {
        view.makeActivity()
        SDImageCache.shared.clearMemory()
        SDImageCache.shared.clearDisk(onCompletion: { [weak self] in
            self?.view.hideToast()
            let cancel = AlertActionType(
                title: "Sure",
                style: .cancel,
                handler: nil
            )
            self?.showAlertVcWith(
                title: "Result",
                message: "Cache cleared",
                preferredStyle: .alert,
                actions: [cancel]
            )
        })
    }
}

// MARK: - AlertAble
extension FirstPageVC: AlertAble { }
    
// MARK: - string extension
extension String {
    fileprivate static let _firstPageTableViewCell = "FirstPageTableViewCell"
}

//
//  SecondPageVC.swift
//  MET
//
//  Created by Django on 3/7/22.
//

import UIKit
import RxSwift
import RxRelay
import RxCocoa
import PromiseKit
import SDWebImage
import ImageViewer_swift
import MJRefresh

/// the detail vc to show weather
public final class SecondPageVC: UIViewController {
    deinit {
        printDebug("SecondPageVC deinit")
    }

    @IBOutlet private weak var _scrollView: UIScrollView!
    @IBOutlet private weak var _nameLabel: UILabel!
    @IBOutlet private weak var _departmentLabel: UILabel!
    @IBOutlet private weak var _textView: UITextView!
    @IBOutlet private weak var _textViewHeight: NSLayoutConstraint!
    @IBOutlet private weak var _primaryImageView: UIImageView!
    @IBOutlet private weak var _primaryImageViewHeight: NSLayoutConstraint!

    private var _objectId: Int? = nil
    private var _objectModel: ServerObjectModelRes? = nil

    private let _viewModel = SecondPageVM()
    private let _disposeBag = DisposeBag()
}

// MARK: - Life cycle
extension SecondPageVC {
    public override func viewDidLoad() {
        super.viewDidLoad()

        title = "Second Page"
        _setUpSubviews()
        _bindViewModel()
    }
}

// MARK: - public funcs
extension SecondPageVC {
    /// accept the object id
    public func accept(
        objectId: Int
    ) {
        _objectId = objectId
        _viewModel.accept(objectId: objectId)
    }
}

// MARK: - private funcs
extension SecondPageVC {
    /// setup the subviews
    private func _setUpSubviews() {
        // set the rightBarButtonItem
        let rightBarButtonItem = UIBarButtonItem(
            title: "clear one",
            style: .plain,
            target: self,
            action: #selector(_onClearTapped)
        )
        navigationItem.rightBarButtonItem = rightBarButtonItem

        _scrollView.mj_header = MJRefreshNormalHeader(refreshingBlock: { [weak self] in
            guard let objectId = self?._objectId else {
                self?._scrollView.mj_header?.endRefreshing()
                return
            }
            self?.accept(objectId: objectId)
        })
    }

    /// bind viewModel with ui
    private func _bindViewModel() {
        _viewModel.viewStateDriver
            .drive { [weak self] in self?._handleViewState($0) }
            .disposed(by: _disposeBag)

        _viewModel.objectModelDriver
            .drive { [weak self] in self?._handleObjectModel($0) }
            .disposed(by: _disposeBag)
    }

    /// handle viewState
    private func _handleViewState(
        _ viewState: SecondPageVM.ViewState
    ) {
        switch viewState {
        case .`init`:
            break
        case .loading:
            view.makeActivity()
        case .success:
            _scrollView.mj_header?.endRefreshing()
            view.hideToast()
        case .failedWith(let err):
            _scrollView.mj_header?.endRefreshing()
            view.hideToast()
            view.makeToast(err.errorDescription)
        }
    }

    /// handle object model
    private func _handleObjectModel(
        _ objectModel: ServerObjectModelRes
    ) {
        _objectModel = objectModel
        _nameLabel.text = objectModel.objectName
        _departmentLabel.text = objectModel.department
        _textView.text = "\(objectModel.jsonStringValue() ?? .emptyString)"
        // you can uncomment this to enable the actual height for the textView
        /*
         let textSize = _textView.sizeThatFits(.init(width: _textView.width, height: .greatestFiniteMagnitude))
         _textViewHeight.constant = textSize.height
         */

        _primaryImageView.sd_imageTransition = .fade
        _primaryImageView.sd_setImage(
            with: objectModel.primaryImageSmall.urlValue
        ) { [weak self] image, error, cacheType, url in
            guard let imageT = image else { return }
            self?._primaryImageViewHeight.constant = imageT.size.height / imageT.size.width * UIScreen.main.bounds.size.width
            let imgArr = [objectModel.primaryImageSmall] + objectModel.additionalImages
            self?._primaryImageView.setupImageViewer(urls: imgArr.compactMap { $0.urlValue })
        }

        // prefetch the image
        SDWebImagePrefetcher.shared.prefetchURLs(objectModel.additionalImages.compactMap { $0.urlValue })
    }
}

// MARK: - actions
extension SecondPageVC {
    @objc private func _onClearTapped() {
        view.makeActivity()
        SDImageCache.shared.removeImage(
            forKey: _objectModel?.primaryImageSmall,
            fromDisk: true
        ) { [weak self] in
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
        }
    }
}

// MARK: - AlertAble
extension SecondPageVC: AlertAble { }

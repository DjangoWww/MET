//
//  METTests.swift
//  METTests
//
//  Created by Django on 3/2/22.
//

import XCTest
@testable import MET
import RxSwift
import RxCocoa
import RxRelay
import RxTest
import RxBlocking
import PromiseKit

/// to test the FirstPageVM
public final class FirstPageVMTests: XCTestCase {
    private var _disposeBag: DisposeBag!
    private var _viewModel: FirstPageVM!
    private var _scheduler: ConcurrentDispatchQueueScheduler!
    private var _testScheduler: TestScheduler!

    public override func setUpWithError() throws {
        _disposeBag = DisposeBag()
        _viewModel = FirstPageVM()
        _scheduler = ConcurrentDispatchQueueScheduler(qos: .default)
        _testScheduler = TestScheduler(initialClock: 0)
    }

    public override func tearDownWithError() throws {
        _disposeBag = nil
        _viewModel = nil
        _scheduler = nil
        _testScheduler = nil
    }

    /// to test if the InitialState is correct
    func testInitialState() throws {
        let viewStateObs = _testScheduler.createObserver(FirstPageVM.ViewState.self)
        let tableSectionsObs = _testScheduler.createObserver([FirstPageVM.TableSection].self)

        _viewModel.viewStateDriver.drive(viewStateObs).disposed(by: _disposeBag)
        _viewModel.tableSectionsDriver.drive(tableSectionsObs).disposed(by: _disposeBag)

        // the initial state
        XCTAssertRecordedElements(viewStateObs.events, [.`init`])
        XCTAssertRecordedElements(tableSectionsObs.events, [[]])
    }

    /// to test if testReqSearch gets the correct response
    func testReqSearch() throws {
        // create obs and bind viewModel to it
        let viewStateObs = _testScheduler.createObserver(FirstPageVM.ViewState.self)
        let tableSectionsObs = _testScheduler.createObserver([FirstPageVM.TableSection].self)
        _viewModel.viewStateDriver.drive(viewStateObs).disposed(by: _disposeBag)
        _viewModel.tableSectionsDriver.drive(tableSectionsObs).disposed(by: _disposeBag)

        // triggers to fire a request
        _viewModel.searchTextRelay.accept("Cat")

        // blocking it and wait for the newest result
        let tableSectionsRes = try _viewModel.tableSectionsDriver.skip(1).toBlocking().first()

        // see if that's what we expected or not
        XCTAssertRecordedElements(
            viewStateObs.events,
            [.`init`, .loading, .success]
        )
        guard let sectionModel = tableSectionsRes?.first else {
            XCTFail("it's not possible to be here")
            return
        }
        XCTAssert(sectionModel.items.count != .zero)
    }
}

/// to test the SecondPageVM
public final class SecondPageVMTests: XCTestCase {
    private var _disposeBag: DisposeBag!
    private var _viewModel: SecondPageVM!
    private var _scheduler: ConcurrentDispatchQueueScheduler!
    private var _testScheduler: TestScheduler!

    public override func setUpWithError() throws {
        _disposeBag = DisposeBag()
        _viewModel = SecondPageVM()
        _scheduler = ConcurrentDispatchQueueScheduler(qos: .default)
        _testScheduler = TestScheduler(initialClock: 0)
    }

    public override func tearDownWithError() throws {
        _disposeBag = nil
        _viewModel = nil
        _scheduler = nil
        _testScheduler = nil
    }

    /// to test if the InitialState is correct
    func testInitialState() throws {
        let viewStateObs = _testScheduler.createObserver(SecondPageVM.ViewState.self)
        let objectModelObs = _testScheduler.createObserver(ServerObjectModelRes.self)

        _viewModel.viewStateDriver.drive(viewStateObs).disposed(by: _disposeBag)
        _viewModel.objectModelDriver.drive(objectModelObs).disposed(by: _disposeBag)

        // the initial state
        XCTAssertRecordedElements(viewStateObs.events, [.`init`])
        // shouldn't have any record since no objectId is accepted by _viewModel
        XCTAssertRecordedElements(objectModelObs.events, [])
    }

    /// to test if the result get correct answer for request getObject
    func testIfGetObjectIsCorrect() throws {
        let objectId = 1

        let viewStateObs = _testScheduler.createObserver(SecondPageVM.ViewState.self)
        let objectModelObs = _testScheduler.createObserver(ServerObjectModelRes.self)

        _viewModel.viewStateDriver.drive(viewStateObs).disposed(by: _disposeBag)
        _viewModel.objectModelDriver.drive(objectModelObs).disposed(by: _disposeBag)

        /// accept the detailModel which should result in ViewModel.TempState change
        _viewModel.accept(objectId: objectId)

        // blocking it and wait for the newest result
        let objectModelRes = try _viewModel.objectModelDriver.toBlocking().first()

        // see if that's what we expected or not
        XCTAssertRecordedElements(
            viewStateObs.events,
            [.`init`, .loading, .success]
        )
        XCTAssert(objectModelRes != nil)
    }
}

// MARK: - ServerProviderTests
public final class ServerProviderTests: XCTestCase {
    private var _serverProvider: ServerProvider!

    public override func setUpWithError() throws {
        _serverProvider = ServerProvider()
    }

    public override func tearDownWithError() throws {
        _serverProvider = nil
    }

    /// get a single object
    func testGetSingleObject() throws {
        let objectId = 1
        _getObject(with: objectId)
    }

    /// get many object
    func testGetManyObject() throws {
        for i in (1...5) {
            _getObject(with: i)
        }
    }

    /// get random object using the result of getObjects request
    func testGetRandomObject() throws {
        let expectation = expectation(description: "expectation for result")

        let getObjectsPromise: Promise<ServerObjectsModelRes> = _serverProvider
            .request(target: .getObjects(model: nil))
        let _ = getObjectsPromise
            .compactMap { $0.objectIDs?.randomElement() }
            .then(_getObjectPromise)
            .done { model in expectation.fulfill() }
            .catch { error in XCTFail(error.errorDescription) }

        let waiter = XCTWaiter()

        // wait for 30 secs
        waiter.wait(for: [expectation], timeout: 30)
    }

    private func _getObjectPromise(
        with id: Int
    ) -> Promise<ServerObjectModelRes> {
        return _serverProvider
            .request(target: .getObject(id: id))
    }

    /// to test if the provider is working correctly and the result from server is valid
    private func _getObject(
        with objectId: Int
    ) {
        let expectation = expectation(description: "expectation for result")

        let promise = _getObjectPromise(with: objectId)
        promise
            .done { model in expectation.fulfill() }
            .catch { XCTFail($0.errorDescription) }
        let waiter = XCTWaiter()

        // wait for 30 secs
        waiter.wait(for: [expectation], timeout: 30)
    }
}

// MARK: - extension for XCTest
// MARK: ServerObjectModelRes: Equatable
extension ServerObjectModelRes: Equatable {
    public static func == (
        lhs: ServerObjectModelRes,
        rhs: ServerObjectModelRes
    ) -> Bool {
        let lhsJsonString = lhs.jsonStringValue()
        let rhsJsonString = rhs.jsonStringValue()
        return lhsJsonString == rhsJsonString
        && rhsJsonString != nil
    }
}

// MARK: FirstPageVM.ViewState: Equatable
extension FirstPageVM.ViewState: Equatable {
    public static func == (
        lhs: FirstPageVM.ViewState,
        rhs: FirstPageVM.ViewState
    ) -> Bool {
        switch (lhs, rhs) {
        case (.`init`, .`init`):
            return true
        case (.loading, .loading):
            return true
        case (.success, .success):
            return true
        case (.failedWith, .failedWith):
            return true
        default:
            return false
        }
    }
}

// MARK: SecondPageVM.ViewState: Equatable
extension SecondPageVM.ViewState: Equatable {
    public static func == (
        lhs: SecondPageVM.ViewState,
        rhs: SecondPageVM.ViewState
    ) -> Bool {
        switch (lhs, rhs) {
        case (.`init`, .`init`):
            return true
        case (.loading, .loading):
            return true
        case (.success, .success):
            return true
        case (.failedWith, .failedWith):
            return true
        default:
            return false
        }
    }
}

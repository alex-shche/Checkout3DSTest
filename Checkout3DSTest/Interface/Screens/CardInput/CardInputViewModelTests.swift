//
//  CardInputViewModelTests.swift
//  Checkout3DSTestTests
//
//  Created by Alexander Shchegryaev on 27/09/2022.
//

import XCTest
@testable import Checkout3DSTest

final class CardInputViewModelTests: XCTestCase {
    let defaultCardNumber = "4243754271700719"
    let defaultExpiryDate = "062030"
    let defaultCVV = "100"
    
    var defaultCardInfo: CardInfo {
        .init(
            cardNumber: defaultCardNumber,
            expiryMonth: String(defaultExpiryDate.prefix(2)),
            expiryYear: String(defaultExpiryDate.suffix(4)),
            cvv: defaultCVV
        )
    }
    
    func testWhenViewDidLoadItReloadsUI() {
        let builder = Builder()
        let viewModel = builder.make()
        var isReloadCalled = false
        viewModel.onReloadContent = { isReloadCalled = true }
        
        viewModel.onView(.didLoad)
        
        XCTAssertTrue(isReloadCalled)
    }
    
    func testWhenInputIsValidPayButtonIsEnabled() {
        let builder = Builder()
        let viewModel = builder.make()
        viewModel.cardDetailsModel.cardNumber = "4243754271700719"
        viewModel.cardDetailsModel.expiryDate = "062030"
        viewModel.cardDetailsModel.cvv = "100"
        
        XCTAssertTrue(viewModel.payButtonModel.isEnabled)
    }
    
    func testWhenCardNumberIsInvalidPayButtonIsDisabled() {
        let builder = Builder()
        let viewModel = builder.make()
        viewModel.cardDetailsModel.cardNumber = ""
        viewModel.cardDetailsModel.expiryDate = "062030"
        viewModel.cardDetailsModel.cvv = "100"
        
        XCTAssertFalse(viewModel.payButtonModel.isEnabled)
    }
    
    func testWhenExpiryDateIsInvalidPayButtonIsDisabled() {
        let builder = Builder()
        let viewModel = builder.make()
        viewModel.cardDetailsModel.cardNumber = "4243754271700719"
        viewModel.cardDetailsModel.expiryDate = "62030"
        viewModel.cardDetailsModel.cvv = "100"
        
        XCTAssertFalse(viewModel.payButtonModel.isEnabled)
    }
    
    func testWhenCVVIsInvalidPayButtonIsDisabled() {
        let builder = Builder()
        let viewModel = builder.make()
        viewModel.cardDetailsModel.cardNumber = "4243754271700719"
        viewModel.cardDetailsModel.expiryDate = "062030"
        viewModel.cardDetailsModel.cvv = "10"
        
        XCTAssertFalse(viewModel.payButtonModel.isEnabled)
    }
    
    func testWhenPayButtonTappedItShowsLoadingAndSendsRequest() {
        let builder = Builder()
        var isRequestSent = false
        var cardInfo: CardInfo?
        builder.cardPaymentsRepository.stubbedMakeCardPayment = { card,_ in
            isRequestSent = true
            cardInfo = card
        }
        
        let viewModel = builder.make()
        var isLoadingShown: Bool?
        viewModel.onShowLoading = { isLoadingShown = $0 }

        viewModel.cardDetailsModel.cardNumber = defaultCardNumber
        viewModel.cardDetailsModel.expiryDate = defaultExpiryDate
        viewModel.cardDetailsModel.cvv = defaultCVV
        
        viewModel.payButtonModel.onTap()
        
        XCTAssertTrue(isRequestSent)
        XCTAssertNotNil(cardInfo)
        XCTAssertEqual(cardInfo, defaultCardInfo)
        XCTAssertNotNil(isLoadingShown)
        XCTAssertEqual(isLoadingShown, true)
    }
    
    func testWhenPayButtonTappedAndRequestSuccedsItStopsLoadingAndOpensURL() {
        let builder = Builder()
        var requestCompletion: ((Result<CardPaymentResult, Error>) -> Void)?
        builder.cardPaymentsRepository.stubbedMakeCardPayment = { _, completion in
            requestCompletion = completion
        }
        
        let viewModel = builder.make()
        var isLoadingShown: Bool?
        viewModel.onShowLoading = { isLoadingShown = $0 }

        viewModel.cardDetailsModel.cardNumber = defaultCardNumber
        viewModel.cardDetailsModel.expiryDate = defaultExpiryDate
        viewModel.cardDetailsModel.cvv = defaultCVV
        
        viewModel.payButtonModel.onTap()
        let sampleURL = URL(string: "https://test.com")!
        requestCompletion?(.success(.init(url: sampleURL)))
        
        XCTAssertNotNil(isLoadingShown)
        XCTAssertEqual(isLoadingShown, false)
        XCTAssertEqual(builder.actions.count, 1)
        
        guard case let .open3DSURL(url) = builder.actions.first else {
            XCTFail()
            return
        }
        XCTAssertEqual(url, sampleURL)
    }
    
    func testWhenPayButtonTappedAndRequestFailsItStopsLoadingAndHandlesError() {
        let builder = Builder()
        var requestCompletion: ((Result<CardPaymentResult, Error>) -> Void)?
        builder.cardPaymentsRepository.stubbedMakeCardPayment = { _, completion in
            requestCompletion = completion
        }
        
        let viewModel = builder.make()
        var isLoadingShown: Bool?
        viewModel.onShowLoading = { isLoadingShown = $0 }

        viewModel.cardDetailsModel.cardNumber = defaultCardNumber
        viewModel.cardDetailsModel.expiryDate = defaultExpiryDate
        viewModel.cardDetailsModel.cvv = defaultCVV
        
        viewModel.payButtonModel.onTap()
        requestCompletion?(.failure(TestError.general))
        
        XCTAssertNotNil(isLoadingShown)
        XCTAssertEqual(isLoadingShown, false)
        XCTAssertEqual(builder.actions.count, 1)
        
        guard case let .handleError(error) = builder.actions.first else {
            XCTFail()
            return
        }
        XCTAssertEqual(error as? TestError, TestError.general)
    }
}

private final class Builder {
    let cardPaymentsRepository = CardPaymentsRepositoryMock()
    var actions = [CardInputViewModel.Action]()
    
    func make() -> CardInputViewModel {
        .init(
            cardPaymentsRepository: cardPaymentsRepository
        ) { action in
            self.actions.append(action)
        }
    }
}

private enum TestError: Error, Equatable {
    case general
}

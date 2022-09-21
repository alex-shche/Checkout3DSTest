//
//  CardInputViewModel.swift
//  Checkout3DSTest
//
//  Created by Alexander Shchegryaev on 21/09/2022.
//

import Foundation

final class CardInputViewModel {
    enum Action {
        case open3DSURL(url: URL)
        case handleError(Error)
    }
    
    private(set) lazy var cardDetailsModel: CardDetails.Model = makeCardDetailsModel()
    private(set) lazy var payButtonModel: LargeButton.Model = makePayButtonModel()
    var onReloadContent: () -> Void = {}
    var onShowLoading: (Bool) -> Void = { _ in }
    
    private let cardPaymentsRepository: CardPaymentsRepositoryProtocol
    private let onAction: (Action) -> Void
    
    init(
        cardPaymentsRepository: CardPaymentsRepositoryProtocol,
        onAction: @escaping (Action) -> Void
    ) {
        self.cardPaymentsRepository = cardPaymentsRepository
        self.onAction = onAction
    }
    
    func onView(_ event: UIViewControllerLifecycleEvent) {
        switch event {
        case .didLoad:
            onReloadContent()
        default:
            break
        }
    }
}

private extension CardInputViewModel {
    func makeCardDetailsModel() -> CardDetails.Model {
        .init { [weak self] in self?.updatePayButton() }
    }
    
    func isInputValid() -> Bool {
        isCardNumberValid() && isExpiryDateValid() && isCVVValid()
    }
    
    func isExpiryDateValid() -> Bool {
        let expiryDate = cardDetailsModel.expiryDate
        guard expiryDate.count == 6,
              expiryDate.allSatisfy({ $0.isNumber }),
              let expiryMonth = Int(expiryDate.prefix(2)),
              expiryMonth <= 12 else {
            return false
        }
        return true
    }
    
    func isCVVValid() -> Bool {
        let cvv = cardDetailsModel.cvv
        guard cvv.count == 3,
              cvv.allSatisfy({ $0.isNumber }) else {
            return false
        }
        return true
    }
    
    func isCardNumberValid() -> Bool {
        let cardNumber = cardDetailsModel.cardNumber
        // todo: add regexp checks for card number
        guard !cardNumber.isEmpty, cardNumber.allSatisfy({ $0.isNumber }) else { return false }
        return true
    }
    
    func updatePayButton() {
        if isInputValid() {
            payButtonModel.isEnabled = true
        } else {
            payButtonModel.isEnabled = false
        }
    }
    
    func makePayButtonModel() -> LargeButton.Model {
        .init(
            title: "Pay",
            isEnabled: isInputValid()
        ) { [weak self] in
            self?.onPayButtonTapped()
        }
    }
    
    func onPayButtonTapped() {
        guard isInputValid() else { return }
        let expiryDate = cardDetailsModel.expiryDate
        guard expiryDate.count == 6 else { return }
        
        let cardInfo = CardInfo(
            cardNumber: cardDetailsModel.cardNumber,
            expiryMonth: String(expiryDate.prefix(2)),
            expiryYear: String(expiryDate.suffix(4)),
            cvv: cardDetailsModel.cvv
        )
        
        onShowLoading(true)
        cardPaymentsRepository.makeCardPayment(
            cardInfo: cardInfo
        ) { [weak self] result in
            guard let self = self else { return }
            self.onShowLoading(false)
            switch result {
            case let .failure(error):
                self.onAction(.handleError(error))
            case let .success(paymentResult):
                self.onAction(.open3DSURL(url: paymentResult.url))
            }
        }
    }
}

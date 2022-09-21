//
//  CardPaymentsRepositoryMock.swift
//  Checkout3DSTestTests
//
//  Created by Alexander Shchegryaev on 27/09/2022.
//

import Foundation
@testable import Checkout3DSTest

final class CardPaymentsRepositoryMock: CardPaymentsRepositoryProtocol {
    var stubbedMakeCardPayment: (CardInfo, @escaping (Result<CardPaymentResult, Error>) -> Void) -> Void = { _,_  in
        fatalError("stubbedMakeCardPayment is not set")
    }
    
    func makeCardPayment(
        cardInfo: CardInfo,
        completion: @escaping (Result<CardPaymentResult, Error>) -> Void
    ) {
        stubbedMakeCardPayment(cardInfo, completion)
    }
}

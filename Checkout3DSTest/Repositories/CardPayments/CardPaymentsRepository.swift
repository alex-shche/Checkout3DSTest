//
//  CardPaymentsRepository.swift
//  Checkout3DSTest
//
//  Created by Alexander Shchegryaev on 21/09/2022.
//

import Foundation

protocol CardPaymentsRepositoryProtocol {
    func makeCardPayment(
        cardInfo: CardInfo,
        completion: @escaping (Result<CardPaymentResult, Error>) -> Void
    )
}

final class CardPaymentsRepository: CardPaymentsRepositoryProtocol {
    enum Constants {
        static let card3DSSuccessURL = URL(string: "https://success.com")!
        static let card3DSFailureURL = URL(string: "https://failure.com")!
    }
    
    private let apiService: CardPaymentsApiServiceProtocol
    
    init(
        apiService: CardPaymentsApiServiceProtocol
    ) {
        self.apiService = apiService
    }
    
    convenience init() {
        self.init(apiService: CardPaymentsApiService())
    }
    
    func makeCardPayment(
        cardInfo: CardInfo,
        completion: @escaping (Result<CardPaymentResult, Error>) -> Void
    ) {
        let cardInfoApiDto = cardInfo.toApiDto()
        apiService.makeCardPayment(cardInfo: cardInfoApiDto) { result in
            switch result {
            case let .success(cardPaymentResult):
                completion(.success(cardPaymentResult.toDomain()))
            case let .failure(error):
                print("Failed to make payment: \(error)")
                completion(.failure(error))
            }
        }
    }
}

private extension CardInfo {
    func toApiDto() -> CardInfoApiDto {
        .init(
            expiryMonth: expiryMonth,
            expiryYear: expiryYear,
            cvv: cvv,
            number: cardNumber,
            successUrl: CardPaymentsRepository.Constants.card3DSSuccessURL,
            failureUrl: CardPaymentsRepository.Constants.card3DSFailureURL
        )
    }
}

private extension CardPaymentResultApiDto {
    func toDomain() -> CardPaymentResult {
        .init(url: url)
    }
}

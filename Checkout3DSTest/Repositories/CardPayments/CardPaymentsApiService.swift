//
//  CardPaymentsApiService.swift
//  Checkout3DSTest
//
//  Created by Alexander Shchegryaev on 21/09/2022.
//

import Foundation

protocol CardPaymentsApiServiceProtocol {
    func makeCardPayment(
        cardInfo: CardInfoApiDto,
        completion: @escaping (Result<CardPaymentResultApiDto, Error>) -> Void
    )
}

final class CardPaymentsApiService: CardPaymentsApiServiceProtocol {
    private let networkClient: NetworkClient
    
    init(networkClient: NetworkClient) {
        self.networkClient = networkClient
    }
    
    convenience init() {
        self.init(networkClient: MainNetworkClient())
    }
    
    func makeCardPayment(
        cardInfo: CardInfoApiDto,
        completion: @escaping (Result<CardPaymentResultApiDto, Error>) -> Void
    ) {
        let request = HTTPRequest(
            path: "pay",
            method: .post,
            parameters: networkClient.json(cardInfo)
        )
        networkClient.performRequest(
            request: request,
            completion: completion
        )
    }
}

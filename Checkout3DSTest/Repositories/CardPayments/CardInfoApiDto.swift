//
//  CardInfoApiDto.swift
//  Checkout3DSTest
//
//  Created by Alexander Shchegryaev on 21/09/2022.
//

import Foundation

struct CardInfoApiDto: Encodable {
    let expiryMonth: String
    let expiryYear: String
    let cvv: String
    let number: String
    let successUrl: URL
    let failureUrl: URL
}

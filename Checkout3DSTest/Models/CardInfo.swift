//
//  CardInfo.swift
//  Checkout3DSTest
//
//  Created by Alexander Shchegryaev on 21/09/2022.
//

import Foundation

struct CardInfo: Equatable {
    let cardNumber: String
    let expiryMonth: String
    let expiryYear: String
    let cvv: String
}

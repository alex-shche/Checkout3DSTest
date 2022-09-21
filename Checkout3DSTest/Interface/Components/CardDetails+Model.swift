//
//  CardDetails+Model.swift
//  Checkout3DSTest
//
//  Created by Alexander Shchegryaev on 17/09/2022.
//

import Foundation

extension CardDetails {
    class Model {
        var cardNumber: String = "" { didSet { onDetailsUpdated() } }
        var expiryDate: String = "" { didSet { onDetailsUpdated() } }
        var cvv: String = "" { didSet { onDetailsUpdated() } }
        
        private let onDetailsUpdated: () -> Void
        init(onDetailsUpdated: @escaping () -> Void) {
            self.onDetailsUpdated = onDetailsUpdated
        }
    }
}

extension CardDetails.Model {
    var cardNumberInputModel: InputText.Model {
        .init(
            title: "Card Number",
            text: cardNumber
        ) { [weak self] text in
            self?.cardNumber = text
        }
    }
    
    var expiryDateInputModel: InputText.Model {
        .init(
            title: "Expiry Date",
            text: expiryDate,
            placeholder: "MMYYYY"
        ) { [weak self] text in
            self?.expiryDate = text
        }
    }
    
    var cvvInputModel: InputText.Model {
        .init(
            title: "CVV",
            text: cvv
        ) { [weak self] text in
            self?.cvv = text
        }
    }
}

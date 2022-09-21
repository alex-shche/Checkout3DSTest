//
//  InputText+Model.swift
//  Checkout3DSTest
//
//  Created by Alexander Shchegryaev on 17/09/2022.
//

import Foundation

extension InputText {
    class Model {
        let title: String
        var text: String?
        let placeholder: String?
        let keyboardType: InputText.KeyboardType
        let onTextChanged: (String) -> Void
        
        init(
            title: String,
            text: String? = nil,
            placeholder: String? = nil,
            keyboardType: InputText.KeyboardType = .numbers,
            onTextChanged: @escaping (String) -> Void
        ) {
            self.title = title
            self.text = text
            self.placeholder = placeholder
            self.keyboardType = keyboardType
            self.onTextChanged = onTextChanged
        }
    }
}

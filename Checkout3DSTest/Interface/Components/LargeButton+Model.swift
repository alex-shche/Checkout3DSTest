//
//  LargeButton+Model.swift
//  Checkout3DSTest
//
//  Created by Alexander Shchegryaev on 21/09/2022.
//

import Foundation

extension LargeButton {
    class Model {
        let title: String
        let onTap: () -> Void
        var isEnabled: Bool { didSet { onEnabledChanged(isEnabled) } }
        
        var onEnabledChanged: (Bool) -> Void = { _ in }
        
        init(
            title: String,
            isEnabled: Bool,
            onTap: @escaping () -> Void
        ) {
            self.title = title
            self.isEnabled = isEnabled
            self.onTap = onTap
        }
    }
}

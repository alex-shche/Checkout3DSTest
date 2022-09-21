//
//  StatusViewModel.swift
//  Checkout3DSTest
//
//  Created by Alexander Shchegryaev on 23/09/2022.
//

import Foundation

extension StatusViewModel {
    static func success(title: String) -> StatusViewModel {
        .init(result: .success, title: title, image: Asset.Icon.icnSuccess)
    }
    
    static func error(title: String) -> StatusViewModel {
        .init(result: .error, title: title, image: Asset.Icon.icnError)
    }
}

final class StatusViewModel {
    enum Result {
        case success
        case error
    }
    private let result: Result
    
    let title: String
    let image: Image
    
    var onReloadContent: () -> Void = {}
    
    init(
        result: Result,
        title: String,
        image: Image
    ) {
        self.result = result
        self.title = title
        self.image = image
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

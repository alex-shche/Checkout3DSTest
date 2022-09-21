//
//  Card3DSViewModel.swift
//  Checkout3DSTest
//
//  Created by Alexander Shchegryaev on 22/09/2022.
//

import Foundation

final class Card3DSViewModel {
    struct Configuration {
        let url: URL
        let successURL: URL
        let failureURL: URL
    }
    
    var onLoadContent: (URL) -> Void = { _ in }
    private let configuration: Configuration
    private let completion: (Bool) -> Void
    
    init(
        configuration: Configuration,
        completion: @escaping (Bool) -> Void
    ) {
        self.configuration = configuration
        self.completion = completion
    }
    
    func onView(_ event: UIViewControllerLifecycleEvent) {
        switch event {
        case .didLoad:
            onLoadContent(configuration.url)
        default:
            break
        }
    }
    
    func shouldAllowNavigation(_ url: URL?, decisionHandler: (Bool) -> Void) {
        guard let url = url else {
            decisionHandler(true)
            return
        }
        
        if url.absoluteString.hasPrefix(configuration.successURL.absoluteString) {
            decisionHandler(false)
            completion(true)
        } else if url.absoluteString.hasPrefix(configuration.failureURL.absoluteString) {
            decisionHandler(false)
            completion(false)
        } else {
            decisionHandler(true)
        }
    }
}

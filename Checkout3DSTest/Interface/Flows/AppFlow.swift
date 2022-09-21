//
//  AppFlow.swift
//  Checkout3DSTest
//
//  Created by Alexander Shchegryaev on 21/09/2022.
//

import Foundation

final class AppFlow {
    private let flowRouter: FlowRouterProtocol
    private let screenFactory: ScreenFactoryProtocol
    
    init(
        flowRouter: FlowRouterProtocol,
        screenFactory: ScreenFactoryProtocol
    ) {
        self.flowRouter = flowRouter
        self.screenFactory = screenFactory
    }
    
    func start() {
        showCardInputScreen()
    }
    
    private func showCardInputScreen() {
        let cardInputViewController = screenFactory.makeCardInputScreen(
            onAction: {
                // app flow will be released when/if this root screen is removed
                self.handleCardInputAction($0)
            }
        )
        flowRouter.clearStackAndShowPushed([cardInputViewController], animated: false)
    }
    
    private func handleCardInputAction(_ action: CardInputViewModel.Action) {
        switch action {
        case let .open3DSURL(url):
            let viewController = screenFactory.makeCard3DSScreen(url: url) { result in
                self.showStatusScreen(result: result)
            }
            flowRouter.present(viewController)
        case let .handleError(error):
            let viewController = screenFactory.makeErrorScreen(for: error)
            flowRouter.present(viewController)
        }
    }
    
    private func showStatusScreen(result: Bool) {
        let viewController = result ? screenFactory.makePaymentSuccessScreen() : screenFactory.makePaymentErrorScreen()
        flowRouter.clearStackAndShowPushed([viewController], animated: true)
    }
}

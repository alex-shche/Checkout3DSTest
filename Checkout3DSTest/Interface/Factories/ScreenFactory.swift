//
//  ScreenFactory.swift
//  Checkout3DSTest
//
//  Created by Alexander Shchegryaev on 21/09/2022.
//

import UIKit

protocol ScreenFactoryProtocol {
    func makeCardInputScreen(onAction: @escaping (CardInputViewModel.Action) -> Void) -> UIViewController
    func makeCard3DSScreen(
        url: URL,
        completion: @escaping (Bool) -> Void
    ) -> UIViewController
    func makePaymentSuccessScreen() -> UIViewController
    func makePaymentErrorScreen() -> UIViewController
    func makeErrorScreen(for error: Error) -> UIViewController
}

final class ScreenFactory: ScreenFactoryProtocol {
    func makeCardInputScreen(onAction: @escaping (CardInputViewModel.Action) -> Void) -> UIViewController  {
        let viewModel = CardInputViewModel(
            cardPaymentsRepository: CardPaymentsRepository(),
            onAction: onAction
        )
        return CardInputViewController(viewModel: viewModel)
    }
    
    func makeCard3DSScreen(
        url: URL,
        completion: @escaping (Bool) -> Void
    ) -> UIViewController {
        let viewModel = Card3DSViewModel(
            configuration: .init(
                url: url,
                successURL: CardPaymentsRepository.Constants.card3DSSuccessURL,
                failureURL: CardPaymentsRepository.Constants.card3DSFailureURL
            ),
            completion: completion
        )
        return Card3DSViewController(viewModel: viewModel)
    }
    
    func makePaymentSuccessScreen() -> UIViewController {
        let viewModel = StatusViewModel.success(title: "Payment Completed :)")
        return StatusViewController(viewModel: viewModel)
    }
    
    func makePaymentErrorScreen() -> UIViewController {
        let viewModel = StatusViewModel.error(title: "Payment Failed :(")
        return StatusViewController(viewModel: viewModel)
    }
    
    func makeErrorScreen(for error: Error) -> UIViewController {
        let viewController = UIAlertController(
            title: "Something went wrong",
            message: nil,
            preferredStyle: .alert
        )
        viewController.addAction(.init(title: "Close", style: .default))
        return viewController
    }
}

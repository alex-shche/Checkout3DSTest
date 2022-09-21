//
//  FlowRouter.swift
//  Checkout3DSTest
//
//  Created by Alexander Shchegryaev on 21/09/2022.
//

import UIKit

protocol FlowRouterProtocol {
    func present(
        _ viewController: UIViewController
    )
    
    func dismiss(
        animated: Bool,
        completion: @escaping () -> Void
    )
    
    func clearStackAndShowPushed(_ viewControllers: [UIViewController], animated: Bool)
}

final class FlowRouter: FlowRouterProtocol {
    private let navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func present(
        _ viewController: UIViewController
    ) {
        if viewController is UINavigationController || viewController is UIAlertController {
            visibleViewController?.present(viewController, animated: true)
        } else {
            let navigationController = UINavigationController(rootViewController: viewController)
            navigationController.isNavigationBarHidden = true
            visibleViewController?.present(navigationController, animated: true)
        }
    }
    
    func dismiss(
        animated: Bool,
        completion: @escaping () -> Void
    ) {
        visibleViewController?.dismiss(animated: animated, completion: completion)
    }
    
    func clearStackAndShowPushed(_ viewControllers: [UIViewController], animated: Bool) {
        if let visibleViewController = navigationController.visibleViewController {
            visibleViewController.navigationController?.setViewControllers(viewControllers, animated: animated)
        } else {
            navigationController.setViewControllers(viewControllers, animated: animated)
        }
    }
    
    private var visibleViewController: UIViewController? {
        navigationController.visibleViewController
        ?? navigationController.viewControllers.last
        ?? navigationController
    }
}

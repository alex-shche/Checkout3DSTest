//
//  AppDelegate.swift
//  Checkout3DSTest
//
//  Created by Alexander Shchegryaev on 17/09/2022.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        let window = UIWindow(frame: UIScreen.main.bounds)
        let navigationController = UINavigationController()
        navigationController.isNavigationBarHidden = true
        
        window.rootViewController = navigationController
        self.window = window
        window.makeKeyAndVisible()
        
        AppFlow(
            flowRouter: FlowRouter(navigationController: navigationController),
            screenFactory: ScreenFactory()
        ).start()
        return true
    }
}


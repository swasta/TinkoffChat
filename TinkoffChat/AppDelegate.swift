//
//  AppDelegate.swift
//  TinkoffChat
//
//  Created by Nikita Borodulin on 20/09/2017.
//  Copyright © 2017 com.nikitaborodulin. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    private let rootAssembly = RootAssembly()
    private let rootStoryboardName = "ConversationsList"
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]? = nil) -> Bool {
        self.window = EmittingWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = getRootViewController()
        window?.makeKeyAndVisible()
        return true
    }
    
    private func getRootViewController() -> UIViewController {
        let rootStoryboard = UIStoryboard(name: rootStoryboardName, bundle: nil)
        let rootViewController = rootStoryboard.instantiateInitialViewController()
        
        guard let navigationController = rootViewController as? UINavigationController,
            let conversationsListViewController = navigationController.topViewController as? ConversationsListViewController else {
                preconditionFailure("Wrong root controller loaded from initial storyboard")
        }
        rootAssembly.conversationsListAssembly.assembly(conversationsListViewController)
        return navigationController
    }
}

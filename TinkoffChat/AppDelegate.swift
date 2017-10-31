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
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]? = nil) -> Bool {
        guard let rootViewController = window?.rootViewController as? UINavigationController,
            let conversationsListViewController = rootViewController.topViewController as? ConversationsListViewController else {
                assertionFailure("Wrong root controller loaded from initial storyboard")
                return false
        }
        RootAssembly.conversationsListAssembly.assembly(conversationsListViewController)
        return true
    }
}

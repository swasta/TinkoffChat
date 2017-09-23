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
    
    func application(_ application: UIApplication, willFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey : Any]? = nil) -> Bool {
        if application.applicationState == .inactive { // true
            print("Application moved from <Not running state> to <Inactive> state: \(#function)")
        }
        printSeparator()
        return true
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        if application.applicationState == .inactive { // true
            print("Application is still in <Inactive> state: \(#function)")
        }
        printSeparator()
        return true
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        if application.applicationState == .active { // true
            print("Application moved from <Inactive> to <Active> state: \(#function)")
        }
        printSeparator()
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        if application.applicationState == .active { // true
            print("Application moves from <Active> to <Inactive> state: \(#function)")
        }
        printSeparator()
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        if application.applicationState == .background { // true
            print("Application moved from <Inactive> to <Background> state: \(#function)")
        }
        printSeparator()
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        if application.applicationState == .background { // true
            print("Application moves from <Background> to <Inactive> state: \(#function)")
        }
        printSeparator()
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        if application.applicationState == .background { // true
            print("Application moves from <Background> to <Not running> state: \(#function)")
        }
    }
    
    private func printSeparator() {
        print("\\=======================================\\")
    }
}

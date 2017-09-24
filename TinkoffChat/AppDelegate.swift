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
        logStateChange(from: "Not running") // will move to inactive
        return true
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        if application.applicationState == .inactive { // true
            print("Application is still in Inactive state: \(#function)")
        }
        printSeparator()
        return true
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        logStateChange(from: "Inactive") // did move to active
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        logStateChange(to: "Inactive") // will move to inactive
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        logStateChange(from: "Inactive") // did move to background
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        logStateChange(to: "Inactive") // will move from background
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        logStateChange(to: "Not running") // will move from background
    }
    
    private func logStateChange(from previousState: String? = nil, to nextState: String? = nil, function: String = #function) {
        if previousState == nil, let next = nextState {
            print("Application moves from \(currentState()) to \(next) state: \(function)")
        } else if let previous = previousState {
            print("Application moved from \(previous) to \(currentState()) state: \(function)")
        }
        printSeparator()
    }
    
    private func currentState() -> String {
        let appState = UIApplication.shared.applicationState
        var state = ""
        switch appState {
        case .active:
            state = "Active"
        case .inactive:
            state = "Inactive"
        case .background:
            state = "Background"
        }
        return state
    }
    
    private func printSeparator() {
        print("\\=======================================\\")
    }
}

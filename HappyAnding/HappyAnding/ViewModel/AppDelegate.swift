//
//  AppDelegate.swift
//  HappyAnding
//
//  Created by 전지민 on 2022/11/29.
//

import UIKit

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        CheckUpdateVersion.share.observeApplicationDidBecomeActive()
        return true
    }
}

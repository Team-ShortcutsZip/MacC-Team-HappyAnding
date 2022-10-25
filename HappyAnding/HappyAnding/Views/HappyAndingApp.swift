//
//  HappyAndingApp.swift
//  HappyAnding
//
//  Created by 이지원 on 2022/10/14.
//

import SwiftUI

import FirebaseCore
import FirebaseFirestore

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()

    return true
  }
}

@main
struct HappyAndingApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    var firebaseService = FirebaseService()
    
    var body: some Scene {
        WindowGroup {
            ShortcutTabView()
        }
    }
}

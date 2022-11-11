//
//  HappyAndingApp.swift
//  HappyAnding
//
//  Created by 이지원 on 2022/10/14.
//

import SwiftUI

import FirebaseCore
import FirebaseFirestore


@main
struct HappyAndingApp: App {
    
    @StateObject var userAuth = UserAuth.shared
    @StateObject var shorcutsZipViewModel = ShortcutsZipViewModel()
    @StateObject var navigationModel = NavigationModel()
    
    init() {
        FirebaseApp.configure()
    }
    
    
    var body: some Scene {
        WindowGroup {
            ShortcutTabView()
                .environmentObject(userAuth)
                .environmentObject(shorcutsZipViewModel)
                .environmentObject(navigationModel)
        }
    }
}

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
    
    init() {
        FirebaseApp.configure()
    }
    
    
    var body: some Scene {
        WindowGroup {
            ShortcutTabView()
                .environmentObject(userAuth)
        }
    }
}

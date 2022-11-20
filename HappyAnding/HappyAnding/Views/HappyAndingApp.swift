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
    @AppStorage("signInStatus") var signInStatus = false
    
    init() {
        FirebaseApp.configure()
    }
    
    
    var body: some Scene {
        WindowGroup {
            if signInStatus {
                ShortcutTabView()
                    .environmentObject(userAuth)
                    .environmentObject(shorcutsZipViewModel)
            }  else {
                if userAuth.isLoggedIn {
                    WriteNicknameView()
                        .environmentObject(shorcutsZipViewModel)
                } else {
                    SignInWithAppleView()
                }
            }
        }
    }
}

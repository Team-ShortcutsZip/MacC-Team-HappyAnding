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
                        .onDisappear() {
                            if shorcutsZipViewModel.userInfo == nil {
                                shorcutsZipViewModel.fetchUser(userID: shorcutsZipViewModel.currentUser()) { user in
                                    shorcutsZipViewModel.userInfo = user
                                }
                            }
                        }
                } else {
                    SignInWithAppleView()
                        .onDisappear() {
                            if shorcutsZipViewModel.userInfo == nil {
                                shorcutsZipViewModel.fetchUser(userID: shorcutsZipViewModel.currentUser()) { user in
                                    shorcutsZipViewModel.userInfo = user
                                    shorcutsZipViewModel.initUserShortcut(user: user)
                                    shorcutsZipViewModel.curationsMadeByUser = shorcutsZipViewModel.fetchCurationByAuthor(author: user.id)
                                }
                            }
                        }
                }
            }
        }
    }
}

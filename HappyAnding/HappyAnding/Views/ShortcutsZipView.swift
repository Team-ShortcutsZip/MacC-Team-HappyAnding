//
//  LaunchScreenView.swift
//  HappyAnding
//
//  Created by 전지민 on 2022/11/29.
//

import SwiftUI

struct ShortcutsZipView: View {
    @EnvironmentObject var shortcutsZipViewModel: ShortcutsZipViewModel
    
    @StateObject var userAuth = UserAuth.shared
    
    @AppStorage("signInStatus") var signInStatus = false
    @AppStorage("isReauthenticated") var isReauthenticated = false
    @AppStorage("useWithoutSignIn") var useWithoutSignIn: Bool = false
    
    var body: some View {
        if signInStatus {
            ShortcutTabView()
                .environmentObject(userAuth)
        }  else {
            if useWithoutSignIn {
                ShortcutTabView()
//                    .environmentObject(userAuth)
            } else {
                if userAuth.isLoggedIn {
                    WriteNicknameView()
                        .onDisappear() {
                            if shortcutsZipViewModel.userInfo == nil {
                                shortcutsZipViewModel.fetchUser(userID: shortcutsZipViewModel.currentUser(), isCurrentUser: true) { user in
                                    shortcutsZipViewModel.userInfo = user
                                }
                            }
                        }
                } else {
                    SignInWithAppleView()
                        .onDisappear() {
                            if shortcutsZipViewModel.userInfo == nil {
                                shortcutsZipViewModel.fetchUser(userID: shortcutsZipViewModel.currentUser(), isCurrentUser: true) { user in
                                    shortcutsZipViewModel.userInfo = user
                                    shortcutsZipViewModel.initUserShortcut(user: user)
                                    shortcutsZipViewModel.curationsMadeByUser = shortcutsZipViewModel.fetchCurationByAuthor(author: user.id)
                                }
                            }
                        }
                }
            }
        }
    }
}

struct ShortcutsZipView_Previews: PreviewProvider {
    static var previews: some View {
        ShortcutsZipView()
    }
}

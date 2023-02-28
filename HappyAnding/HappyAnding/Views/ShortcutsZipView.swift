//
//  LaunchScreenView.swift
//  HappyAnding
//
//  Created by 전지민 on 2022/11/29.
//

import SwiftUI

struct ShortcutsZipView: View {
    @Environment(\.gradeAlertKey) var gradeAlerter
    @EnvironmentObject var shortcutsZipViewModel: ShortcutsZipViewModel
    
    @StateObject var userAuth = UserAuth.shared
    
    @AppStorage("signInStatus") var signInStatus = false
    @AppStorage("isReauthenticated") var isReauthenticated = false
    @AppStorage("useWithoutSignIn") var useWithoutSignIn: Bool = false
    
    @State var isGradeAlertShowing = false
    
    var body: some View {
        if signInStatus {
            ZStack {
                ShortcutTabView()
                    .environmentObject(userAuth)
                
                if gradeAlerter.isPresented {
                    GradeAlertView()
                }
            }
        }  else {
            if useWithoutSignIn {
                ShortcutTabView()
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

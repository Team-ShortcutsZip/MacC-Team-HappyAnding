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
    @Environment(\.scenePhase) var scenePhase
    @Environment(\.openURL) private var openURL
    
    @StateObject var userAuth = UserAuth.shared
    @StateObject var shorcutsZipViewModel = ShortcutsZipViewModel()
    @AppStorage("signInStatus") var signInStatus = false
    @AppStorage("isReauthenticated") var isReauthenticated = false
    
    @State var isNeededForceUpdate = false
    @State var versionData = Version(latestVersion: "", minimumVersion: "", description: "", title: "")
    
    let appID = "6444001181"
    
    init() {
        FirebaseApp.configure()
    }
    
    
    var body: some Scene {
        WindowGroup {
            if signInStatus {
                ShortcutTabView()
                    .environmentObject(userAuth)
                    .environmentObject(shorcutsZipViewModel)
                    .alert("\(versionData.title)", isPresented: $isNeededForceUpdate) {
                        Button() {
                            let url = "itms-apps://itunes.apple.com/app/" + appID
                            if let url = URL(string: url){
                                UIApplication.shared.open(url)
                            }
                        } label: {
                            Text("업데이트")
                        }
                    } message: {
                        Text("\(versionData.description)")
                    }
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
        .onChange(of: scenePhase) { phase in
            switch phase {
            case .active:
                print("**켜짐")
                CheckUpdateVersion.share.fetchVersion { version, isNeeded in
                    self.isNeededForceUpdate = isNeeded
                    self.versionData = version
                }
                print("**\(isNeededForceUpdate)")
                
            case .inactive:
                print("꺼짐")
            case .background:
                print("백그라운드에서 돌아가는 중")
            @unknown default:
                print("")
            }
        }
    }
}

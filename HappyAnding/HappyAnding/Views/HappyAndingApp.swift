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
    
    @StateObject var shortcutsZipViewModel = ShortcutsZipViewModel.share
    @StateObject var loginAlerter = Alerter()
    @StateObject var gradeAlerter = Alerter()
    
    @AppStorage("useWithoutSignIn") var useWithoutSignIn: Bool = false
    
    @State var isNeededUpdate = false
    @State var isShowingLaunchScreen = true
    @State var version = Version(latestVersion: "", minimumVersion: "", description: "", title: "")
    
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            if isShowingLaunchScreen {
                ZStack {
                    Color.shortcutsZipPrimary.ignoresSafeArea()
                    Text("ShortcutsZip")
                        .foregroundStyle(Color.white)
                        .font(.system(size: 26, weight: .bold))
                        .frame(maxHeight: .infinity)
                        .ignoresSafeArea()
                }
                .alert(version.title, isPresented: $isNeededUpdate) {
                    Button(role: .cancel) {
                        isShowingLaunchScreen = false
                    } label: {
                        Text(TextLiteral.later)
                    }
                    Button() {
                        let url = TextLiteral.appStoreUrl
                        if let url = URL(string: url){
                            UIApplication.shared.open(url)
                        }
                        isShowingLaunchScreen = false
                    } label: {
                        Text(TextLiteral.update)
                    }
                } message: {
                    Text(version.description)
                }
            } else {
                ShortcutsZipView()
                    .environmentObject(shortcutsZipViewModel)
                    .environment(\.loginAlertKey, loginAlerter)
                    .alert(TextLiteral.loginTitle, isPresented: $loginAlerter.isPresented) {
                        Button(role: .cancel) {
                        } label: {
                            Text(TextLiteral.cancel)
                        }
                        Button {
                            useWithoutSignIn = false
                        } label: {
                            Text(TextLiteral.loginAction)
                        }
                    } message: {
                        Text(TextLiteral.loginMessage)
                    }
            }
        }
        .onChange(of: scenePhase) { (newScenePhase) in
            switch newScenePhase {
            case .active:
                CheckUpdateVersion.share.fetchVersion { version, isNeeded in
                    self.version = version
                    self.isNeededUpdate = isNeeded
                    if !isNeeded {
                        isShowingLaunchScreen = false
                    }
                }
                break
            case .inactive:
                break
            case .background:
                break
            @unknown default:
                break
            }
        }
    }
}

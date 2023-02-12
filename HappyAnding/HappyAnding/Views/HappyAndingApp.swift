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
    
    @StateObject var shortcutsZipViewModel = ShortcutsZipViewModel()
    @StateObject var loginAlerter = Alerter()
    
    @AppStorage("useWithoutSignIn") var useWithoutSignIn: Bool = false
    
    @State var isNeededUpdate = false
    @State var isShowingLaunchScreen = true
    @State var version = Version(latestVersion: "", minimumVersion: "", description: "", title: "")
    
    let appID = "6444001181"
    
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            if isShowingLaunchScreen {
                ZStack {
                    Color.shortcutsZipPrimary.ignoresSafeArea()
                    Text("ShortcutsZip")
                        .foregroundColor(Color.white)
                        .font(.system(size: 26, weight: .bold))
                        .frame(maxHeight: .infinity)
                        .ignoresSafeArea()
                }
                .alert(version.title, isPresented: $isNeededUpdate) {
                    Button(role: .cancel) {
                        isShowingLaunchScreen = false
                    } label: {
                        Text("나중에")
                    }
                    Button() {
                        let url = "itms-apps://itunes.apple.com/app/" + self.appID
                        if let url = URL(string: url){
                            UIApplication.shared.open(url)
                        }
                        isShowingLaunchScreen = false
                    } label: {
                        Text("업데이트")
                    }
                } message: {
                    Text(version.description)
                }
            } else {
                ShortcutsZipView()
                    .environmentObject(shortcutsZipViewModel)
                    .environment(\.loginAlertKey, loginAlerter)
                    .alert("로그인을 진행해주세요", isPresented: $loginAlerter.isPresented) {
                        Button(role: .cancel) {
                        } label: {
                            Text("취소")
                        }
                        Button {
                            useWithoutSignIn = false
                        } label: {
                            Text("로그인하기")
                        }
                    } message: {
                        Text("이 기능은 로그인 후 사용할 수 있어요")
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

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
    
    @State var isNeededUpdate = false
    @State var isShowingLaunchScreen = true
    @State var version = Version(latestVersion: "", minimumVersion: "", description: "", title: "")
    @State var isForaWeek = false
    
    let appID = "6444001181"
    
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            if isShowingLaunchScreen {
                ZStack {
                    Color.Primary.ignoresSafeArea()
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
                        let url = "itms-apps://itunes.apple.com/app/" + appID
                        if let url = URL(string: url){
                            UIApplication.shared.open(url)
                        }
                    } label: {
                        Text("업데이트")
                    }
                } message: {
                    Text(version.description)
                }
            } else {
                ShortcutsZipView()
            }
        }
        .onChange(of: scenePhase) { (newScenePhase) in
            switch newScenePhase {
            case .active:
                CheckUpdateVersion.share.fetchVersion { version in
                    self.version = version
                    self.isNeededUpdate = version.isNeededForceUpdate
                    if !version.isNeededForceUpdate {
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

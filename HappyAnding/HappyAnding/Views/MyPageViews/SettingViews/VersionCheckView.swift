//
//  VersionCheckView.swift
//  HappyAnding
//
//  Created by 이지원 on 2023/05/27.
//

import SwiftUI

struct VersionCheckView: View {
    @State private var isAnimating = false
    @State private var currentVersion = ""
    @State private var latestVersion = "" {
        didSet {
            if currentVersion == latestVersion {
                versionInformation = TextLiteral.checkVersionViewLatestVersion
                buttonText = TextLiteral.checkVersionViewGoToReview
            } else {
                versionInformation = TextLiteral.checkVersionViewNewVersion
                buttonText = TextLiteral.checkVersionViewGoToDownload
            }
        }
    }
    @State private var versionInformation = ""
    @State private var buttonText = ""
    
    private let animationAxis: Double = 1.0
    private let degree: Double = 4.0
    
    var body: some View {
        VStack {
            
            Spacer()
            
            VStack(spacing: 52) {
                Image("versionAppIcon")
                    .cornerRadius(33)
                    .shadow(color: .black.opacity(0.2), radius: 10, x: 0, y: 0)
                    .rotation3DEffect(.degrees(isAnimating ? degree : -degree), axis: (x: animationAxis, y: 0, z:  0))
                    .animation(.easeInOut(duration: 4).repeatForever(), value: isAnimating)
                    .rotation3DEffect(.degrees(isAnimating ? degree : -degree), axis: (x: 0, y: animationAxis, z: 0))
                    .animation(.easeInOut(duration: 4).repeatForever().delay(1), value: isAnimating)
                
                Text("\(currentVersion) / \(latestVersion)")
                    .shortcutsZipFootnote()
                    .foregroundColor(.gray3)
                
                Text(versionInformation)
                    .shortcutsZipHeadline()
                    .foregroundColor(.gray5)
            }
            
            Spacer()
            
            Button {
                guard let url = URL(string: TextLiteral.appStoreUrl) else { return }
                UIApplication.shared.open(url)
            } label: {
                ZStack {
                    RoundedRectangle(cornerRadius: 12)
                        .foregroundColor(.shortcutsZipPrimary)
                        .frame(maxWidth: .infinity, maxHeight: 52)
                    
                    Text(buttonText)
                        .shortcutsZipBody1()
                        .foregroundColor(.textButton)
                }
                .padding(.bottom, 44)
            }
        }
        .onAppear {
            withAnimation {
                isAnimating.toggle()
            }
            getAppVersion()
            getLatestVersion()
        }
        .padding(.horizontal, 16)
        .background(Color.shortcutsZipBackground)
        .navigationTitle(TextLiteral.settingViewVersion)
    }
    
    private func getAppVersion() {
        guard let info = Bundle.main.infoDictionary,
              let appVersion = info["CFBundleShortVersionString"] as? String else { return }
        self.currentVersion = appVersion
    }
    
    private func getLatestVersion() {
        CheckUpdateVersion.share.fetchVersion { version, _ in
            self.latestVersion = version.latestVersion
        }
    }
}

struct VersionCheckView_Previews: PreviewProvider {
    static var previews: some View {
        VersionCheckView()
    }
}

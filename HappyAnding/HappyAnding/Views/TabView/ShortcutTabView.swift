//
//  ContentView.swift
//  HappyAnding
//
//  Created by 이지원 on 2022/10/14.
//

import SwiftUI

struct ShortcutTabView: View {
    
    // TODO: StateObject로 선언할 수 있는 다른 로직 구현해보기
    @EnvironmentObject var userAuth: UserAuth
    @AppStorage("signInStatus") var signInStatus = false
    
    init() {
        let transparentAppearence = UITabBarAppearance()
        transparentAppearence.configureWithTransparentBackground()
        UITabBar.appearance().standardAppearance = transparentAppearence
        UITabBar.appearance().barTintColor = UIColor(Color.White)
        UITabBar.appearance().backgroundColor = UIColor(Color.White)
        UITabBar.appearance().unselectedItemTintColor = UIColor(Color.Gray2)
        UITabBar.appearance().layer.borderColor = UIColor(Color.clear).cgColor
        UITabBar.appearance().clipsToBounds = true
        Theme.navigationBarColors()
    }
    
    var body: some View {
        
        if signInStatus {
            TabView {
                ForEach(Tab.allCases, id: \.self) { tab in
                    tab.view
                        .tabItem {
                            Label(tab.tabName, systemImage: tab.systemImage)
                        }
                }
            }
            .environmentObject(ShortcutsZipViewModel())
            
        } else {
            if userAuth.isLoggedIn {
                WriteNicknameView()
            } else {
                SignInWithAppleView()
            }
        }
    }
}

struct ShortcutTabView_Previews: PreviewProvider {
    static var previews: some View {
        ShortcutTabView()
    }
}

//
//  ContentView.swift
//  HappyAnding
//
//  Created by 이지원 on 2022/10/14.
//

import SwiftUI

struct ShortcutTabView: View {
    
    @EnvironmentObject var userAuth: UserAuth
    @AppStorage("signInStatus") var signInStatus = false
    
    init() {
        UITabBar.appearance().barTintColor = UIColor(Color.White)
        UITabBar.appearance().unselectedItemTintColor = UIColor(Color.Gray2)
        UITabBar.appearance().layer.borderColor = UIColor(Color.Gray1).cgColor
     //   UITabBar.appearance().clipsToBounds = true
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

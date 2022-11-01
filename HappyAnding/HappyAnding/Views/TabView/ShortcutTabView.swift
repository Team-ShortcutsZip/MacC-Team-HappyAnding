//
//  ContentView.swift
//  HappyAnding
//
//  Created by 이지원 on 2022/10/14.
//

import SwiftUI

struct ShortcutTabView: View {
    
    @EnvironmentObject var userAuth: UserAuth
    
    init() {
        UITabBar.appearance().barTintColor = UIColor(Color.White)
        UITabBar.appearance().unselectedItemTintColor = UIColor(Color.Gray2)
        UITabBar.appearance().layer.borderColor = UIColor(Color.Gray1).cgColor
     //   UITabBar.appearance().clipsToBounds = true
        Theme.navigationBarColors()
    }
    
    var body: some View {
        
        if userAuth.isLoggedIn {
            TabView {
                ForEach(Tab.allCases, id: \.self) { tab in
                    tab.view
                        .tabItem {
                            Label(tab.tabName, systemImage: tab.systemImage)
                        }
                }
            }
        } else {
            SignInWithAppleView()
        }
    }
}

struct ShortcutTabView_Previews: PreviewProvider {
    static var previews: some View {
        ShortcutTabView()
    }
}

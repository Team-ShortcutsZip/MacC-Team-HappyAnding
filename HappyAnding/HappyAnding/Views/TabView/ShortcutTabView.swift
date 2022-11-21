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
    @EnvironmentObject var shorcutsZipViewModel: ShortcutsZipViewModel
    @AppStorage("signInStatus") var signInStatus = false
    @StateObject var viewModel = ShortcutsZipViewModel()
    @State private var tabSelection = Tab.exploreShortcut.tag
    @State private var isOpenURL = false
    @State private var test = ""
    
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
//            let _ = shorcutsZipViewModel.initUserInfo()
            TabView(selection: $tabSelection) {
                ForEach(Tab.allCases, id: \.self) { tab in
                    tab.view
                        .tabItem {
                            Label(tab.tabName, systemImage: tab.systemImage)
                        }.tag(tab.tag)
                }
            }
            .environmentObject(ShortcutsZipViewModel())
            .sheet(isPresented: self.$isOpenURL) {
                //let data = NavigationReadShortcutType(shortcutID: shortcut.id,
                //                                      navigationParentView: .myPage)
                //ReadShortcutView
                let data = NavigationReadShortcutType(shortcutID: self.test, navigationParentView: .myPage)
                ReadShortcutView(data: data)
            }
            .onOpenURL { url in
                if let tab = url.tabIdentifier {
                    tabSelection = tab.tag
                }
                
                let urlString = url.absoluteString
                guard urlString.contains("shortcutID") else { return }
                
                let components = URLComponents(string: urlString)
                let urlQueryItems = components?.queryItems ?? []
                
                var dictionaryData = [String: String]()
                urlQueryItems.forEach {
                    dictionaryData[$0.name] = $0.value
                }
                
                guard let shortcutIDfromURL = dictionaryData["shortcutID"] else { return }
                
                print("shortcutIDfromURL = \(shortcutIDfromURL)")
                
                test = shortcutIDfromURL
                isOpenURL = true
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

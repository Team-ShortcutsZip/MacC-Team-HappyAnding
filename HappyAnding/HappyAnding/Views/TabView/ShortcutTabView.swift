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
    
    @StateObject var shortcutNavigation = ShortcutNavigation()
    @StateObject var curationNavigation = CurationNavigation()
    @StateObject var profileNavigation = ProfileNavigation()
    @State private var tabSelection = 1
    @State private var tappedTwice = false
    
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
    
    var handler: Binding<Int> { Binding(
        get: { self.tabSelection },
        set: {
            if $0 == self.tabSelection {
                tappedTwice = true
            }
            self.tabSelection = $0
        }
    )}
    
    var body: some View {
        
        if signInStatus {
            //            let _ = shorcutsZipViewModel.initUserInfo()
            TabView(selection: handler) {
                NavigationStack(path: $shortcutNavigation.shortcutPath) {
                    ExploreShortcutView()
                        .onChange(of: tappedTwice, perform: { tappedTwice in
                            guard tappedTwice else { return }
                            shortcutNavigation.shortcutPath.removeLast(shortcutNavigation.shortcutPath.count)
                            self.tappedTwice = false
                        })
                }
                .environmentObject(shortcutNavigation)
                .tabItem {
                    Label("단축어", systemImage: "square.stack.3d.up.fill")
                }
                .tag(1)
                
                NavigationStack(path: $curationNavigation.navigationPath) {
                    ExploreCurationView()
                        .onChange(of: tappedTwice, perform: { tappedTwice in
                            guard tappedTwice else { return }
                            curationNavigation.navigationPath.removeLast(curationNavigation.navigationPath.count)
                            self.tappedTwice = false
                        })
                }
                .environmentObject(curationNavigation)
                .tabItem {
                    Label("큐레이션", systemImage: "folder.fill")
                }
                .tag(2)
                
                NavigationStack(path: $profileNavigation.navigationPath) {
                    MyPageView()
                        .onChange(of: tappedTwice, perform: { tappedTwice in
                            guard tappedTwice else { return }
                            profileNavigation.navigationPath.removeLast(profileNavigation.navigationPath.count)
                            self.tappedTwice = false
                        })
                }
                .environmentObject(profileNavigation)
                .tabItem {
                    Label("프로필", systemImage: "person.crop.circle.fill")
                }
                .tag(3)
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

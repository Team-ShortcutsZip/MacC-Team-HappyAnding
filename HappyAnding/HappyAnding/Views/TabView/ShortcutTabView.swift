//
//  ContentView.swift
//  HappyAnding
//
//  Created by 이지원 on 2022/10/14.
//

import SwiftUI
import BackgroundTasks

struct ShortcutTabView: View {
    
    // TODO: StateObject로 선언할 수 있는 다른 로직 구현해보기
    @Environment(\.scenePhase) private var phase
    @EnvironmentObject var userAuth: UserAuth
    
    @AppStorage("signInStatus") var signInStatus = false
    @State private var isOpenURL = false
    @State private var tempShortcutId = ""
    
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
        ScrollViewReader { proxy in
            TabView(selection: handler) {
                NavigationStack(path: $shortcutNavigation.navigationPath) {
                    ExploreShortcutView()
                        .onChange(of: tappedTwice, perform: { tappedTwice in
                            guard tappedTwice else { return }
                            shortcutNavigation.navigationPath.removeLast(shortcutNavigation.navigationPath.count)
                            withAnimation {
                                proxy.scrollTo(111)
                            }
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
                            withAnimation {
                                proxy.scrollTo(222)
                            }
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
                            withAnimation {
                                proxy.scrollTo(333)
                            }
                            self.tappedTwice = false
                        })
                }
                .environmentObject(profileNavigation)
                .tabItem {
                    Label("프로필", systemImage: "person.crop.circle.fill")
                }
                .tag(3)
            }
            .sheet(isPresented: self.$isOpenURL) {
                let data = NavigationReadShortcutType(shortcutID: self.tempShortcutId,
                                                      navigationParentView: .myPage)
                ReadShortcutView(data: data)
            }
            .onChange(of: phase) { newPhase in
                switch newPhase {
                case .background: isOpenURL = false
                default: break
                }
            }
            .onOpenURL { url in
                fetchShortcutIdFromUrl(urlString: url.absoluteString)
                isOpenURL = true
            }
        }
    }
    
    private func fetchShortcutIdFromUrl(urlString: String) {
        
        guard urlString.contains("shortcutID") else { return }
        
        let components = URLComponents(string: urlString)
        let urlQueryItems = components?.queryItems ?? []
        
        var dictionaryData = [String: String]()
        urlQueryItems.forEach {
            dictionaryData[$0.name] = $0.value
        }
        
        guard let shortcutIDfromURL = dictionaryData["shortcutID"] else { return }
        
        print("shortcutIDfromURL = \(shortcutIDfromURL)")
        
        tempShortcutId  = shortcutIDfromURL
    }
}

struct ShortcutTabView_Previews: PreviewProvider {
    static var previews: some View {
        ShortcutTabView()
    }
}

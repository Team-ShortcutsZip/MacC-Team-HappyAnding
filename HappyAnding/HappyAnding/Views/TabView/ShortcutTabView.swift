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
    @EnvironmentObject var shortcutsZipViewModel: ShortcutsZipViewModel
    
    @AppStorage("signInStatus") var signInStatus = false
    @State private var isShortcutDeeplink = false
    @State private var isCurationDeeplink = false
    @State private var tempShortcutId = ""
    @State private var tempCurationId = ""
    
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
                            if shortcutNavigation.navigationPath.count > 0 {
                                shortcutNavigation.navigationPath.removeLast(shortcutNavigation.navigationPath.count)
                            } else {
                                withAnimation {
                                    proxy.scrollTo(111, anchor: .bottom)
                                }
                            }
                            self.tappedTwice = false
                        })
                        .navigationDestination(for: NavigationSearch.self) { _ in
                            SearchView()
                        }
                        .navigationDestination(for: NavigationListShortcutType.self) { data in
                            ListShortcutView(data: data)
                        }
                        .navigationDestination(for: NavigationReadShortcutType.self) { data in
                            ReadShortcutView(data: data)
                        }
                        .navigationDestination(for: Category.self) { category in
                            ShortcutsListView(shortcuts: $shortcutsZipViewModel.shortcutsInCategory[category.index],
                                              categoryName: category,
                                              navigationParentView: .shortcuts)
                        }
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
                            if curationNavigation.navigationPath.count > 0 {
                                curationNavigation.navigationPath.removeLast(curationNavigation.navigationPath.count)
                            } else {
                                withAnimation {
                                    proxy.scrollTo(222, anchor: .bottom)
                                }
                            }
                            self.tappedTwice = false
                        })
                        .navigationBarBackground ({ Color.Background })
                        .navigationDestination(for: Curation.self) { data in
                            ReadAdminCurationView(curation: data)
                        }
                        .navigationDestination(for: NavigationReadUserCurationType.self) { data in
                            ReadUserCurationView(data: data)
                        }
                        .navigationDestination(for: NavigationListCurationType.self) { data in
                            ListCurationView(data: data)
                        }
                        .navigationDestination(for: NavigationReadShortcutType.self) { data in
                            ReadShortcutView(data: data)
                        }
                    
                }
                .environmentObject(curationNavigation)
                .tabItem {
                    Label("추천모음집", systemImage: "folder.fill")
                }
                .tag(2)
                
                NavigationStack(path: $profileNavigation.navigationPath) {
                    MyPageView()
                        .onChange(of: tappedTwice, perform: { tappedTwice in
                            guard tappedTwice else { return }
                            if profileNavigation.navigationPath.count > 0 {
                                profileNavigation.navigationPath.removeLast(profileNavigation.navigationPath.count)
                            } else {
                                withAnimation {
                                    proxy.scrollTo(333, anchor: .bottom)
                                }
                            }
                            self.tappedTwice = false
                        })
                        .navigationBarBackground ({ Color.Background })
                    
                        .navigationDestination(for: NavigationListShortcutType.self) { data in
                            ListShortcutView(data: data)
                        }
                        .navigationDestination(for: NavigationReadShortcutType.self) { data in
                            ReadShortcutView(data: data)
                        }
                        .navigationDestination(for: NavigationReadUserCurationType.self) { data in
                            ReadUserCurationView(data: data)
                        }
                        .navigationDestination(for: NavigationListCurationType.self) { data in
                            ListCurationView(data: data)
                        }
                }
                .environmentObject(profileNavigation)
                .tabItem {
                    Label("프로필", systemImage: "person.crop.circle.fill")
                }
                .tag(3)
            }
            .sheet(isPresented: self.$isShortcutDeeplink) {
                let data = NavigationReadShortcutType(shortcutID: self.tempShortcutId,
                                                      navigationParentView: .myPage)
                ReadShortcutView(data: data)
            }
            .sheet(isPresented: self.$isCurationDeeplink) {
                if let curation = shortcutsZipViewModel.fetchCurationDetail(curationID: tempCurationId) {
                    let data = NavigationReadUserCurationType(userCuration: curation, navigationParentView: .myPage)
                    ReadUserCurationView(data: data)
                }
            }
            .onChange(of: phase) { newPhase in
                switch newPhase {
                case .background: isShortcutDeeplink = false; isCurationDeeplink = false
                default: break
                }
            }
            .onOpenURL { url in
                fetchShortcutIdFromUrl(urlString: url.absoluteString)
                fetchCurationIdFromUrl(urlString: url.absoluteString)
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
        
        tempShortcutId  = shortcutIDfromURL
        isShortcutDeeplink = true
    }
    
    private func fetchCurationIdFromUrl(urlString: String) {
        
        guard urlString.contains("curationID") else { return }
        
        let components = URLComponents(string: urlString)
        let urlQueryItems = components?.queryItems ?? []
        
        var dictionaryData = [String: String]()
        urlQueryItems.forEach {
            dictionaryData[$0.name] = $0.value
        }
        
        guard let curationIDfromURL = dictionaryData["curationID"] else { return }
        
        print("curationIDfromURL = \(curationIDfromURL)")
        
        tempCurationId  = curationIDfromURL
        isCurationDeeplink = true
    }
}

struct ShortcutTabView_Previews: PreviewProvider {
    static var previews: some View {
        ShortcutTabView()
    }
}

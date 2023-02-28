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
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var userAuth: UserAuth
    @EnvironmentObject var shortcutsZipViewModel: ShortcutsZipViewModel
    
    @StateObject var shortcutNavigation = ShortcutNavigation()
    @StateObject var curationNavigation = CurationNavigation()
    @StateObject var profileNavigation = ProfileNavigation()
    
    @AppStorage("signInStatus") var signInStatus = false
    @AppStorage("selectedTab") var selectedTab = 1
    
    @State private var isShortcutDeeplink = false
    @State private var isCurationDeeplink = false
    @State private var tempShortcutId = ""
    @State private var tempCurationId = ""
    
    @State private var randomCategories = Category.allCases.shuffled().prefix(2)
    @State var isFolded = true
    @State private var tappedTwice = false
    
    init() {
        let transparentAppearence = UITabBarAppearance()
        transparentAppearence.configureWithTransparentBackground()
        UITabBar.appearance().standardAppearance = transparentAppearence
        UITabBar.appearance().barTintColor = UIColor(Color.shortcutsZipWhite)
        UITabBar.appearance().backgroundColor = UIColor(Color.shortcutsZipWhite)
        UITabBar.appearance().unselectedItemTintColor = UIColor(Color.gray2)
        UITabBar.appearance().layer.borderColor = UIColor(Color.clear).cgColor
        UITabBar.appearance().clipsToBounds = true
    }
    
    var handler: Binding<Int> { Binding(
        get: { self.selectedTab },
        set: {
            if $0 == self.selectedTab {
                tappedTwice = true
            }
            self.selectedTab = $0
        }
    )}
    
    var body: some View {
        ScrollViewReader { proxy in
            TabView(selection: handler) {
                NavigationRouter(content: firstTab, path: $shortcutNavigation.navigationPath)
                    .onChange(of: tappedTwice) { tappedTwice in
                        guard tappedTwice else { return }
                        scrollToBottomWithAnimation(proxy, scrollID: 111, navigationPath: &shortcutNavigation.navigationPath)
                        self.tappedTwice = false
                    }
                    .onChange(of: isFolded) { _ in
                        withAnimation {
                            proxy.scrollTo(999, anchor: .bottom)
                        }
                    }
                    .environmentObject(shortcutNavigation)
                    .tabItem {
                        Label("단축어", systemImage: "square.stack.3d.up.fill")
                    }
                    .tag(1)
                
                NavigationRouter(content: secondTab,
                                 path: $curationNavigation.navigationPath)
                .onChange(of: tappedTwice) { tappedTwice in
                    guard tappedTwice else { return }
                    scrollToBottomWithAnimation(proxy, scrollID: 222, navigationPath: &curationNavigation.navigationPath)
                    self.tappedTwice = false
                }
                .environmentObject(curationNavigation)
                .tabItem {
                    Label("추천모음집", systemImage: "folder.fill")
                }
                .tag(2)
                
                NavigationRouter(content: thirdTab, path: $profileNavigation.navigationPath)
                    .onChange(of: tappedTwice, perform: { tappedTwice in
                        guard tappedTwice else { return }
                        scrollToBottomWithAnimation(proxy, scrollID: 333, navigationPath: &profileNavigation.navigationPath)
                        self.tappedTwice = false
                    })
                    .environmentObject(profileNavigation)
                    .tabItem {
                        Label("프로필", systemImage: "person.crop.circle.fill")
                    }
                    .tag(3)
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
        .background(Color.red)
    }
    
    
    @ViewBuilder
    private func firstTab() -> some View {
        ExploreShortcutView(isFolded: $isFolded, randomCategories: Array(randomCategories))
            .modifierNavigation()
            .navigationBarBackground ({ Color.shortcutsZipBackground })
    }
    
    @ViewBuilder
    private func secondTab() -> some View {
        ExploreCurationView()
            .modifierNavigation()
            .navigationBarBackground ({ Color.shortcutsZipBackground })
    }
    
    @ViewBuilder
    private func thirdTab() -> some View {
        MyPageView()
            .modifierNavigation()
            .navigationBarBackground ({ Color.shortcutsZipBackground })
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
        
        let data = NavigationReadShortcutType(shortcutID: self.tempShortcutId,
                                              navigationParentView: .myPage)
        navigateLink(data: data)
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
        
        tempCurationId  = curationIDfromURL
        isCurationDeeplink = true
        
        if let curation = shortcutsZipViewModel.fetchCurationDetail(curationID: tempCurationId) {
            let data = NavigationReadUserCurationType(userCuration: curation,
                                                      navigationParentView: .myPage)
            navigateLink(data: data)
        }
    }
    
    private func navigateLink<T: Hashable> (data: T) {
        
        switch selectedTab {
        case 1:
            shortcutNavigation.navigationPath.append(data)
        case 2:
            curationNavigation.navigationPath.append(data)
        case 3:
            profileNavigation.navigationPath.append(data)
        default:
            break
        }
    }
}

struct ShortcutTabView_Previews: PreviewProvider {
    static var previews: some View {
        ShortcutTabView()
    }
}

// TODO: - extension 컨벤션 머지 후 위치 수정
extension View {
    func scrollToBottomWithAnimation(_ proxy: ScrollViewProxy?, scrollID: Int, navigationPath: inout NavigationPath) {
        guard let proxy = proxy else { return }
        if #available(iOS 16.1, *) {
            if navigationPath.count > 0 {
                navigationPath.removeLast(navigationPath.count)
            } else {
                withAnimation {
                    proxy.scrollTo(scrollID, anchor: .bottom)
                }
            }
        } else {
            withAnimation {
                proxy.scrollTo(scrollID, anchor: .bottom)
            }
            NavigationUtil.popToRootView()
        }
    }
}

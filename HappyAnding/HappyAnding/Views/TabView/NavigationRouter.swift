//
//  NavigationRouter.swift
//  HappyAnding
//
//  Created by 이지원 on 2023/02/16.
//

import SwiftUI


struct NavigationRouter<Content>: View where Content: View {
    
    @ViewBuilder var content: () -> Content
    @Binding var path: NavigationPath
    
    var body: some View {

        if #available(iOS 16.1, *) {
            NavigationStack(path: $path, root: content)
                .modifier(NavigationViewModifier())
            
        } else {
            NavigationView(content: content)
                .navigationViewStyle(StackNavigationViewStyle())
        }
    }
}


@available(iOS 16.1, *)
struct NavigationViewModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
        
            .navigationDestination(for: NavigationProfile.self) { data in
                ShowProfileView(data: data)
            }
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
            .navigationDestination(for: NavigationListShortcutType.self) { data in
                ListShortcutView(data: data)
            }
            .navigationDestination(for: NavigationListCategoryShortcutType.self) { data in
                ListCategoryShortcutView(data: data)
            }
            .navigationDestination(for: NavigationLisence.self) { value in
                LicenseView()
            }
            .navigationDestination(for: NavigationWithdrawal.self) { _ in
                WithdrawalView()
            }
            .navigationDestination(for: NavigationSearch.self) { _ in
                SearchView()
            }
            .navigationDestination(for: NavigationSettingView.self) { _ in
                SettingView()
            }
            .navigationDestination(for: NavigationNicknameView.self) { _ in
                EditNicknameView()
            }
    }
}


//
//  View+Navigation.swift
//  HappyAnding
//
//  Created by 이지원 on 2023/02/20.
//

import SwiftUI


// MARK: - Extension
/**
 네비게이션 뷰 및 네비게이션 스택을 관리하기 위한 확장입니다.
 */
extension View {
    
    /**
     Navigation Stack의 destination을 설정하는 View Builder입니다.
     새로운 Navigation View가 생성되면, Navigation View Modifier에 Destination을 추가해주세요
     */
    @ViewBuilder
    func modifierNavigation() -> some View {
        if #available(iOS 16.1, *) {
            self
                .modifier(NavigationViewModifier())
        } else {
            self
        }
    }
    
    
    /**
     Data 타입을 통해 Navigation의 목적지를 확인합니다.
     Navigation View의 경우 Data로 목적지를 설정할 수 없으므로, Stack에서 사용하는 데이터 타입과 목적지의 연결이 필요합니다.
     */
    @ViewBuilder
    func navigationLinkRouter<T: Hashable>(data: T) -> some View {
        if #available(iOS 16.1, *) {
            NavigationLink(value: data) {
                self
            }
        } else {
            NavigationLink(destination: getDestination(data: data)) {
                self
            }
        }
    }
    
    
    /**
     Naivagion View의 Destination 확인을 위해 필요한 View Builder입니다.
     새로운 뷰가 추가되면, Stack에서 사용하는 데이터 타입과 목적지를 넣어주세요
     */
    @ViewBuilder
    func getDestination<T: Hashable>(data: T) -> some View {
        switch data {
        case is NavigationListShortcutType:
            ListShortcutView(data: data as! NavigationListShortcutType)
        case is NavigationReadShortcutType:
            ReadShortcutView(data: data as! NavigationReadShortcutType)
        case is NavigationReadUserCurationType:
            ReadUserCurationView(data: data as! NavigationReadUserCurationType)
        case is NavigationListCurationType:
            ListCurationView(data: data as! NavigationListCurationType)
        case is NavigationProfile:
            ShowProfileView(data: data as! NavigationProfile)
        case is NavigationSearch:
            SearchView()
        case is NavigationListCategoryShortcutType:
            ListCategoryShortcutView(data: data as!  NavigationListCategoryShortcutType)
        case is Curation:
            ReadAdminCurationView(curation: data as! Curation)
        case is NavigationNicknameView:
            EditNicknameView()
        case is NavigationSettingView:
            SettingView()
        case is NavigationLisence:
            LicenseView()
        case is NavigationWithdrawal:
            WithdrawalView()
        default:
            EmptyView()
        }
    }
}


// MARK: - View Modifier

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

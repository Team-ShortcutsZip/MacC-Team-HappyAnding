//
//  View+Navigation.swift
//  HappyAnding
//
//  Created by 이지원 on 2023/02/20.
//

import SwiftUI

extension View {
    
    @ViewBuilder
    func modifierNavigation() -> some View {
        if #available(iOS 16.1, *) {
            self
                .modifier(NavigationViewModifier())
        } else {
            self
        }
    }
    
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

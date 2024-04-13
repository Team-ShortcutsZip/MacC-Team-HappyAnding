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
//        if #available(iOS 16.1, *) {
//            self
//                .modifier(NavigationViewModifier())
//        } else {
            self
//        }
    }
    
    
    /**
     Data 타입을 통해 Navigation의 목적지를 확인합니다.
     Navigation View의 경우 Data로 목적지를 설정할 수 없으므로, Stack에서 사용하는 데이터 타입과 목적지의 연결이 필요합니다.
     */
    @ViewBuilder
    func navigationLinkRouter<T: Hashable>(data: T) -> some View {
//        if #available(iOS 16.1, *) {
//            NavigationLink(value: data) {
//                self
//            }
//        } else {
            NavigationLink(destination: getDestination(data: data)) {
                self
            }
//        }
    }
    
    @ViewBuilder
    func navigationLinkRouter<T: Hashable>(data: T, isPresented: Binding<Bool>) -> some View {
//        if #available(iOS 16.1, *) {
//            NavigationLink(value: data) {
//                self
//            }
//        } else {
            NavigationLink(destination: getDestination(data: data, isPresented: isPresented)) {
                self
            }
//        }
    }
    
    
    /**
     Naivagion View의 Destination 확인을 위해 필요한 View Builder입니다.
     새로운 뷰가 추가되면, Stack에서 사용하는 데이터 타입과 목적지를 넣어주세요
     */
    @ViewBuilder
    func getDestination<T: Hashable>(data: T, isPresented: Binding<Bool>) -> some View {
        switch data {
        case is WriteCurationInfoType:
            WriteCurationInfoView(data: data as! WriteCurationInfoType, isWriting: isPresented)
        default:
            EmptyView()
        }
    }
    
    @ViewBuilder
    func getDestination<T: Hashable>(data: T) -> some View {
        switch data {
        case is SectionType:
            ListShortcutView(viewModel: ListShortcutViewModel(data: data as! SectionType))
        case is Shortcuts:
            ReadShortcutView(viewModel: ReadShortcutViewModel(data: data as! Shortcuts))
        case is Curation:
            ReadCurationView(viewModel: ReadCurationViewModel(data: data as! Curation))
        case is CurationType:
            ListCurationView(viewModel: ListCurationViewModel(data: data as! CurationType))
        case is User:
            ShowProfileView(viewModel: ShowProfileViewModel(data: data as! User))
        case is Category:
            ListCategoryShortcutView(viewModel: ListCategoryShortcutViewModel(data: data as! Category))
        case is NavigationNicknameView:
            EditNicknameView()
        case is NavigationSettingView:
            SettingView()
        case is NavigationLisence:
            LicenseView()
        case is NavigationWithdrawal:
            WithdrawalView()
        case is CheckVersionView:
            CheckVersionView()
        case is NavigationUpdateInfo:
            AboutUpdateView()
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
        
            .navigationDestination(for: User.self) { data in
                ShowProfileView(viewModel: ShowProfileViewModel(data: data))
            }
            .navigationDestination(for: Curation.self) { data in
                ReadCurationView(viewModel: ReadCurationViewModel(data: data))
            }
            .navigationDestination(for: CurationType.self) { data in
                ListCurationView(viewModel: ListCurationViewModel(data: data))
            }
            .navigationDestination(for: Shortcuts.self) { data in
                ReadShortcutView(viewModel: ReadShortcutViewModel(data: data))
            }
            .navigationDestination(for: SectionType.self) { data in
                ListShortcutView(viewModel: ListShortcutViewModel(data: data))
            }
            .navigationDestination(for: Category.self) { data in
                ListCategoryShortcutView(viewModel: ListCategoryShortcutViewModel(data: data))
            }
            .navigationDestination(for: NavigationLisence.self) { value in
                LicenseView()
            }
            .navigationDestination(for: NavigationWithdrawal.self) { _ in
                WithdrawalView()
            }
            .navigationDestination(for: NavigationSettingView.self) { _ in
                SettingView()
            }
            .navigationDestination(for: NavigationNicknameView.self) { _ in
                EditNicknameView()
            }
            .navigationDestination(for: NavigationCheckVersion.self) { _ in
                CheckVersionView()
            }
            .navigationDestination(for: NavigationUpdateInfo.self) { _ in
                AboutUpdateView()
            }
    }
}

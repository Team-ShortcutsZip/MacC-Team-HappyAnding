//
//  ExploreCurationView.swift
//  HappyAnding
//
//  Created by 이지원 on 2022/10/19.
//

import SwiftUI

struct ExploreCurationView: View {
    
    @EnvironmentObject var shortcutsZipViewModel: ShortcutsZipViewModel
    
    @AppStorage("useWithoutSignIn") var useWithoutSignIn = false
    
    var body: some View {
        ScrollView {
            VStack(spacing: 32) {
                
                adminCurationView
                
                if !useWithoutSignIn {
                    sectionView(with: .personalCuration)
                }
                
                sectionView(with: .userCuration)
            }
            .padding(.top, 20)
            .padding(.bottom, 44)
            .onChange(of: shortcutsZipViewModel.userCurations) { _ in
                shortcutsZipViewModel.refreshPersonalCurations()
            }
        }
        .navigationBarTitle(TextLiteral.exploreCurationViewTitle)
        .navigationBarTitleDisplayMode(.large)
        .scrollIndicators(.hidden)
        .background(Color.shortcutsZipBackground)
    }
    
    var adminCurationView: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(alignment: .bottom) {
                SubtitleTextView(text: TextLiteral.exploreCurationViewAdminCurations)
                    .id(222)
                
                Spacer()
            }
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 0) {
                    ForEach(shortcutsZipViewModel.adminCurations, id: \.id) { curation in
                        AdminCurationCell(adminCuration: curation)
                            .navigationLinkRouter(data: NavigationReadCurationType(isAdmin: true,
                                                                                   curation: curation,
                                                                                   navigationParentView: .curations))
                    }
                }
                .padding(.trailing, 8)
            }
        }
        .padding(.leading, 16)
    }
    
    @ViewBuilder
    private func sectionView(with sectionType: CurationType) -> some View {
        
        let curations = sectionType.filterCuration(from: shortcutsZipViewModel)
        var sectionTitle: String {
            if sectionType == .personalCuration {
                return (shortcutsZipViewModel.userInfo?.nickname ?? "") + sectionType.title
            } else {
                return sectionType.title
            }
        }
        
        VStack(spacing: 0) {

            HStack(alignment: .bottom) {
                SubtitleTextView(text: sectionTitle)
                    .onTapGesture { }
                
                Spacer()
                
                MoreCaptionTextView(text: TextLiteral.more)
                    .navigationLinkRouter(data: sectionType)
            }
            .padding(.bottom, 12)
            .padding(.horizontal, 16)

            ForEach(curations.prefix(2), id: \.self) { curation in
                let data = NavigationReadCurationType(curation: curation,
                                                      navigationParentView: .curations)
                
                UserCurationCell(curation: curation,
                                 lineLimit: 2,
                                 navigationParentView: .curations)
                .navigationLinkRouter(data: data)
            }
        }
    }
}

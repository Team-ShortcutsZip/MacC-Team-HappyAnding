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
                
                //사용자를 위한 모음집
                if !useWithoutSignIn {
                    sectionView(with: .personalCuration)
                }
                
                //추천 유저 큐레이션
                sectionView(with: .userCuration)
            }
            .padding(.top, 20)
            .padding(.bottom, 44)
            .onChange(of: shortcutsZipViewModel.userCurations) { _ in
                shortcutsZipViewModel.refreshPersonalCurations()
            }
        }
        .navigationBarTitle(Text(TextLiteral.exploreCurationViewTitle))
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
            .padding(.horizontal, 16)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 0) {
                    ForEach(shortcutsZipViewModel.adminCurations, id: \.id) { curation in
                        AdminCurationCell(adminCuration: curation)
                            .navigationLinkRouter(data: NavigationReadCurationType(isAdmin: true,
                                                                                   curation: curation,
                                                                                   navigationParentView: .curations))

                    }
                }
                .padding(.leading, 16)
                .padding(.trailing, 8)
            }
        }
    }
    
    @ViewBuilder
    private func sectionView(with sectionType: CurationType) -> some View {
        
        let curation = sectionType.filterCuration(from: shortcutsZipViewModel)
        var sectionTitle: String {
            if sectionType == .personalCuration {
                return (shortcutsZipViewModel.userInfo?.nickname ?? "") + sectionType.title
            } else {
                return sectionType.title
            }
        }
        
        VStack(spacing: 0) {

            // MARK: List header
            HStack(alignment: .bottom) {
                SubtitleTextView(text: sectionTitle)
                    .onTapGesture { }
                
                Spacer()
                
                // TODO: Navigation Router 수정 필요
                MoreCaptionTextView(text: TextLiteral.more)
                    .navigationLinkRouter(data: sectionType)
            }
            .padding(.bottom, 12)
            .padding(.horizontal, 16)

            // MARK: - 셀 2개 + 더보기 버튼
            ForEach(curation.prefix(2), id: \.self) { curation in
                let data = NavigationReadCurationType(curation: curation,
                                                      navigationParentView: .curations)
                
                UserCurationCell(curation: curation,
                                 lineLimit: 2,
                                 navigationParentView: .curations)
                .navigationLinkRouter(data: data)
                
            }
        }
        .background(Color.shortcutsZipBackground.ignoresSafeArea(.all, edges: .all))
    }
}

//
//  ExploreCurationView.swift
//  HappyAnding
//
//  Created by 이지원 on 2022/10/19.
//

import SwiftUI

struct ExploreCurationView: View {
    
    @StateObject var viewModel: ExploreCurationViewModel
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
                    ForEach(viewModel.adminCurationList, id: \.id) { curation in
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
        
        VStack(spacing: 0) {

            HStack(alignment: .bottom) {
                SubtitleTextView(text: viewModel.getSectionTitle(with: sectionType))
                
                Spacer()
                
                MoreCaptionTextView(text: TextLiteral.more)
                    .navigationLinkRouter(data: sectionType)
            }
            .padding(.bottom, 12)
            .padding(.horizontal, 16)

            ForEach(viewModel.getCurationList(with:sectionType).prefix(2), id: \.self) { curation in
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

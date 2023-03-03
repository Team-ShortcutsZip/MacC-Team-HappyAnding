//
//  CurationListView.swift
//  HappyAnding
//
//  Created by HanGyeongjun on 2022/10/27.
//

import SwiftUI

struct CurationListView: View {
    
    @EnvironmentObject var shortcutsZipViewModel: ShortcutsZipViewModel
    
    @State var data: NavigationListCurationType
    
    var body: some View {
        VStack(spacing: 0) {
            listHeader
            
            ForEach(data.curation.prefix(2), id: \.self) { curation in
                let data = NavigationReadUserCurationType(userCuration: curation,
                                                          navigationParentView: self.data.navigationParentView)
                
                UserCurationCell(curation: curation,
                                 lineLimit: 2,
                                 navigationParentView: self.data.navigationParentView)
                .navigationLinkRouter(data: data)
                
            }
        }
        .background(Color.shortcutsZipBackground.ignoresSafeArea(.all, edges: .all))
        .onAppear {
            if self.data.type == .personalCuration {
                self.data.curation = shortcutsZipViewModel.personalCurations
            }
            if self.data.isAllUser {
                self.data.curation = shortcutsZipViewModel.userCurations
            }
        }
    }
    
    var listHeader: some View {
        HStack(alignment: .bottom) {
            if data.type == .personalCuration {
                SubtitleTextView(text: "\(shortcutsZipViewModel.userInfo?.nickname ?? "")\(data.type.rawValue)")
                    .onTapGesture { }
            } else {
                SubtitleTextView(text: data.title ?? "")
                    .onTapGesture { }
            }
            Spacer()
            
            MoreCaptionTextView(text: TextLiteral.more)
                .navigationLinkRouter(data: data)
        }
        .padding(.bottom, 12)
        .padding(.horizontal, 16)
    }
}


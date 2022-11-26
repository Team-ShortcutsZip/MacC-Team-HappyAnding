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
            
            ForEach(Array(data.curation.enumerated()), id: \.offset) { index, curation in
                if index < 2 {
                    
                    let data = NavigationReadUserCurationType(userCuration: curation,
                                                              navigationParentView: self.data.navigationParentView)
                    NavigationLink(value: data) {
                        UserCurationCell(curation: curation,
                                         navigationParentView: self.data.navigationParentView)
                    }
                }
            }
        }
        .background(Color.Background.ignoresSafeArea(.all, edges: .all))
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
                Text("\(shortcutsZipViewModel.userInfo?.nickname ?? "")\(data.type.rawValue)")
                    .Title2()
                    .foregroundColor(.Gray5)
                    .onTapGesture { }
            } else {
                Text(data.title ?? "")
                    .Title2()
                    .foregroundColor(.Gray5)
                    .onTapGesture { }
            }
            Spacer()
            
            NavigationLink(value: data) {
                Text("더보기")
                    .Footnote()
                    .foregroundColor(.Gray4)
            }
        }
        .padding(.bottom, 12)
        .padding(.horizontal, 16)
    }
}


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
            CurationListHeader(userCurations: data.curation,
                               data: data,
                               navigationParentView: self.data.navigationParentView)
            .padding(.bottom, 12)
            .padding(.horizontal, 16)
            
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
        
        .onChange(of: shortcutsZipViewModel.personalCurations) { data in
            if self.data.type == .personalCuration {
                self.data.curation = data
            }
        }
        .onChange(of: shortcutsZipViewModel.userCurations) { data in
            if self.data.type == .userCuration {
                self.data.curation = data
            }
        }
        .onChange(of: shortcutsZipViewModel.curationsMadeByUser) { data in
            if self.data.type == .myCuration {
                self.data.curation = data
            }
        }
    }
}

struct CurationListHeader: View {
    
    @EnvironmentObject var shortcutsZipViewModel: ShortcutsZipViewModel
    let userCurations: [Curation]
    
    @State var data: NavigationListCurationType
    let navigationParentView: NavigationParentView
    
    var body: some View {
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
        .onChange(of: shortcutsZipViewModel.personalCurations) { data in
            if self.data.type == .personalCuration {
                self.data.curation = data
            }
        }
        .onChange(of: shortcutsZipViewModel.userCurations) { data in
            if self.data.type == .userCuration {
                self.data.curation = data
            }
        }
        .onChange(of: shortcutsZipViewModel.curationsMadeByUser) { data in
            if self.data.type == .myCuration {
                self.data.curation = data
            }
        }
    }
}


//struct CurationListView_Previews: PreviewProvider {
//    static var previews: some View {
//        CurationListView(curationListTitle:유저 큐레이션", userCurations: UserCuration.fetchData(number: 5))
//    }
//}

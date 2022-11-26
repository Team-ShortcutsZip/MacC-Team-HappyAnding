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
    @State var curations = [Curation]()
    
    var body: some View {
        VStack(spacing: 0) {
            listHeader
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

//        .onAppear {
//            switch data.type {
//            case .myCuration:
//                self.curations = shortcutsZipViewModel.curationsMadeByUser
//            case .userCuration:
//                self.curations = shortcutsZipViewModel.userCurations
//            case .personalCuration:
//
//                self.curations = shortcutsZipViewModel.personalCurations
//            }
//        }
//        .onChange(of: shortcutsZipViewModel.personalCurations) { data in
//            if self.data.type == .personalCuration {
////                shortcutsZipViewModel.refreshPersonalCurations()
//                self.curations = data
//            }
//        }
//        .onChange(of: shortcutsZipViewModel.userCurations) { data in
//            if self.data.type == .userCuration {
////                shortcutsZipViewModel.refreshPersonalCurations()
//                self.curations = data
//            }
//        }
//        .onChange(of: shortcutsZipViewModel.curationsMadeByUser) { data in
//            if self.data.type == .myCuration {
//                self.curations = data
//            }
//        }
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
    }
}

//struct CurationListHeader: View {
//
//    @EnvironmentObject var shortcutsZipViewModel: ShortcutsZipViewModel
//    let userCurations: [Curation]
//
//    @State var data: NavigationListCurationType
//    let navigationParentView: NavigationParentView
//
//    var body: some View {
//
//        .onChange(of: shortcutsZipViewModel.personalCurations) { data in
//            if self.data.type == .personalCuration {
//                self.data.curation = data
//            }
//        }
//        .onChange(of: shortcutsZipViewModel.userCurations) { data in
//            if self.data.type == .userCuration {
//                self.data.curation = data
//            }
//        }
//        .onChange(of: shortcutsZipViewModel.curationsMadeByUser) { data in
//            if self.data.type == .myCuration {
//                self.data.curation = data
//            }
//        }
//    }
//}


//struct CurationListView_Previews: PreviewProvider {
//    static var previews: some View {
//        CurationListView(curationListTitle:유저 큐레이션", userCurations: UserCuration.fetchData(number: 5))
//    }
//}

//
//  CurationListView.swift
//  HappyAnding
//
//  Created by HanGyeongjun on 2022/10/27.
//

import SwiftUI

struct CurationListView: View {
    
    @State var data: NavigationListCurationType
    @Binding var userCurations: [Curation]
    
    var body: some View {
        VStack(spacing: 0) {
            CurationListHeader(userCurations: $userCurations,
                               data: data,
                               navigationParentView: self.data.navigationParentView)
                .padding(.bottom, 12)
                .padding(.horizontal, 16)
            
            ForEach(Array(userCurations.enumerated()), id: \.offset) { index, curation in
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
        .navigationDestination(for: NavigationReadUserCurationType.self) { data in
            ReadUserCurationView(data: data)
        }
        .background(Color.Background.ignoresSafeArea(.all, edges: .all))
        
    }
}

struct CurationListHeader: View {
    @Binding var userCurations: [Curation]
    
    @State var data: NavigationListCurationType
    let navigationParentView: NavigationParentView
    
    var body: some View {
        HStack(alignment: .bottom) {
            Text(data.title ?? "")
                .Title2()
                .foregroundColor(.Gray5)
                .onTapGesture { }
            Spacer()
            
            NavigationLink(value: data) {
                Text("더보기")
                    .Footnote()
                    .foregroundColor(.Gray4)
            }
        }
        .navigationDestination(for: NavigationListCurationType.self) { data in
            ListCurationView(userCurations: $userCurations,
                             data: data)
        }
    }
}


//struct CurationListView_Previews: PreviewProvider {
//    static var previews: some View {
//        CurationListView(curationListTitle:유저 큐레이션", userCurations: UserCuration.fetchData(number: 5))
//    }
//}

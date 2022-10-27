//
//  CurationListView.swift
//  HappyAnding
//
//  Created by HanGyeongjun on 2022/10/27.
//

import SwiftUI

struct CurationListView: View {
    
    var curationListTitle: String
    var userCurations: [Curation]
    
    var body: some View {
        VStack(spacing: 0) {
            CurationListHeader(title: curationListTitle)
                .padding(.bottom, 12)
                .padding(.horizontal, 16)
            ForEach(Array(userCurations.enumerated()), id: \.offset) { index, curation in
                NavigationLink(destination: ReadAdminCurationView()) {
                    if index < 2 {
                        UserCurationCell(
                            title: curation.title,
                            subtitle: curation.subtitle ?? "",
                            shortcuts: curation.shortcuts,
                            curation: curation
                        )
                    }
                }
            }
        }
        .background(Color.Background.ignoresSafeArea(.all, edges: .all))
        
    }
}

struct CurationListHeader: View {
    var title: String
    var body: some View {
        HStack(alignment: .bottom) {
            Text(title)
                .Title2()
                .foregroundColor(.Gray5)
                .onTapGesture { }
            Spacer()
            NavigationLink(destination: ExploreCurationView()) {
                Text("더보기")
                    .Footnote()
                    .foregroundColor(.Gray4)
            }
        }
    }
}


//struct CurationListView_Previews: PreviewProvider {
//    static var previews: some View {
//        CurationListView(curationListTitle: "스마트한 생활의 시작", userCurations: UserCuration.fetchData(number: 5))
//    }
//}

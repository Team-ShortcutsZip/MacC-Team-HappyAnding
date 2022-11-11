//
//  CurationListView.swift
//  HappyAnding
//
//  Created by HanGyeongjun on 2022/10/27.
//

import SwiftUI

struct CurationListView: View {
    
    var curationListTitle: String
    @Binding var userCurations: [Curation]
    
    var body: some View {
        VStack(spacing: 0) {
            CurationListHeader(userCurations: $userCurations, type: .userCuration, title: curationListTitle)
                .padding(.bottom, 12)
                .padding(.horizontal, 16)
            ForEach(Array(userCurations.enumerated()), id: \.offset) { index, curation in
                NavigationLink(destination: ReadUserCurationView(userCuration: curation)) {
                    if index < 2 {
                        UserCurationCell(
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
    @Binding var userCurations: [Curation]
    var type: CurationType
    var title: String
    var body: some View {
        HStack(alignment: .bottom) {
            Text(title)
                .Title2()
                .foregroundColor(.Gray5)
                .onTapGesture { }
            Spacer()
            NavigationLink(destination: ListCurationView(userCurations: $userCurations, type: type, title: title, isAllUser: true)) {
                Text("더보기")
                    .Footnote()
                    .foregroundColor(.Gray4)
            }
        }
    }
}

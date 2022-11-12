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
    
    let isAccessCuration: Bool
    
    var body: some View {
        VStack(spacing: 0) {
            CurationListHeader(userCurations: $userCurations,
                               type: .userCuration,
                               title: curationListTitle,
                               isAccessCuration: self.isAccessCuration)
                .padding(.bottom, 12)
                .padding(.horizontal, 16)
            ForEach(Array(userCurations.enumerated()), id: \.offset) { index, curation in
                if index < 2 {
                    NavigationLink(value: userCurations) {
                        UserCurationCell(curation: curation, isAccessCuration: true)
                    }
                    
                    .navigationDestination(for: Curation.self) { _ in
                        ReadUserCurationView(userCuration: curation,
                                             isAccessCuration: self.isAccessCuration)
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
    
    let isAccessCuration: Bool
    
    var body: some View {
        HStack(alignment: .bottom) {
            Text(title)
                .Title2()
                .foregroundColor(.Gray5)
                .onTapGesture { }
            Spacer()
            NavigationLink(destination: ListCurationView(userCurations: $userCurations,
                                                         type: type,
                                                         title: title,
                                                         isAllUser: true,
                                                         isAccessCuration: self.isAccessCuration)) {
                Text("더보기")
                    .Footnote()
                    .foregroundColor(.Gray4)
            }
        }
    }
}


//struct CurationListView_Previews: PreviewProvider {
//    static var previews: some View {
//        CurationListView(curationListTitle:유저 큐레이션", userCurations: UserCuration.fetchData(number: 5))
//    }
//}

//
//  CurationListView.swift
//  HappyAnding
//
//  Created by HanGyeongjun on 2022/10/27.
//

import SwiftUI

struct CurationListView: View {
    
    @State var data: NavigationCurationType
    @Binding var userCurations: [Curation]
    
    var body: some View {
        VStack(spacing: 0) {
            CurationListHeader(userCurations: $userCurations,
                               data: data)
                .padding(.bottom, 12)
                .padding(.horizontal, 16)
            
            ForEach(Array(userCurations.enumerated()), id: \.offset) { index, curation in
                if index < 2 {
                    NavigationLink(value: curation) {
                        UserCurationCell(curation: curation)
                    }
                }
            }
        }
        .navigationDestination(for: Curation.self) { curation in
            ReadUserCurationView(userCuration: curation)
        }
        .background(Color.Background.ignoresSafeArea(.all, edges: .all))
        
    }
}

struct CurationListHeader: View {
    @Binding var userCurations: [Curation]
    
    @State var data: NavigationCurationType
    
    var body: some View {
        HStack(alignment: .bottom) {
            Text(data.title)
                .Title2()
                .foregroundColor(.Gray5)
                .onTapGesture { }
            Spacer()
            
            NavigationLink(value: data) {
                Text("더보기")
                    .Footnote()
                    .foregroundColor(.Gray4)
            }
            .navigationDestination(for: NavigationCurationType.self) { type in
                ListCurationView(userCurations: $userCurations,
                                 type: data.type,
                                 isAllUser: true)
            }
        }
    }
}


//struct CurationListView_Previews: PreviewProvider {
//    static var previews: some View {
//        CurationListView(curationListTitle:유저 큐레이션", userCurations: UserCuration.fetchData(number: 5))
//    }
//}

//
//  UserCurationListView.swift
//  HappyAnding
//
//  Created by 전지민 on 2022/10/25.
//

import SwiftUI

struct UserCurationListView: View {
    
    @State var isWriting = false
    @State var data: NavigationCurationType
    
    @Binding var userCurations: [Curation]
    
    let navigationParentView: NavigationParentView
    
    var body: some View {
        VStack(spacing: 0) {
            UserCurationListHeader(userCurations: $userCurations,
                                   data: data,
                                   navigationParentView: self.navigationParentView)
                .padding(.bottom, 12)
                .padding(.horizontal, 16)
            
            NavigationLink(value: UInt(0)) {
                HStack(spacing: 7) {
                    Image(systemName: "plus")
                    Text("큐레이션 만들기")
                }
                .Headline()
                .foregroundColor(.Gray4)
                .frame(maxWidth: .infinity)
                .frame(height: 64)
                .background(Color.Background_plus)
                .cornerRadius(12)
                .padding(.bottom, 12)
                .padding(.horizontal, 16)
            }

            if let userCurations {
                ForEach(Array(userCurations.enumerated()), id: \.offset) { index, curation in
                    //TODO: 데이터 변경 필요
                    if index < 2 {
                        NavigationLink(value: curation) {
                            UserCurationCell(curation: curation,
                                             navigationParentView: self.navigationParentView)
                        }
                    }
                }
            }
        }
        .navigationDestination(for: Curation.self) { curation in
            ReadUserCurationView(userCuration: curation,
                                 navigationParentView: self.navigationParentView)
        }
        .navigationDestination(for: UInt.self) { isEdit in
            WriteCurationSetView(isWriting: self.$isWriting,
                                 isEdit: false)
        }
        .background(Color.Background.ignoresSafeArea(.all, edges: .all))
    }
}

struct UserCurationListHeader: View {
    @Binding var userCurations: [Curation]
    
    @State var data: NavigationCurationType
    
    let navigationParentView: NavigationParentView
    
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
        }
        .navigationDestination(for: NavigationCurationType.self) { type in
            ListCurationView(userCurations: $userCurations,
                             type: data.type,
                             isAllUser: true,
                             navigationParentView: self.navigationParentView)
            
        }
    }
}

//struct UserCurationListView_Previews: PreviewProvider {
//    static var previews: some View {
//        UserCurationListView(userCurations: UserCuration.fetchData(number: 5))
//    }
//}

//
//  UserCurationListView.swift
//  HappyAnding
//
//  Created by 전지민 on 2022/10/25.
//

import SwiftUI

struct UserCurationListView: View {
    
    @State var isWriting = false
    
    @Binding var userCurations: [Curation]
    
    var body: some View {
        VStack(spacing: 0) {
            UserCurationListHeader(title: "내가 등록한 큐레이션", userCurations: $userCurations)
                .padding(.bottom, 12)
                .padding(.horizontal, 16)
            Button {
                isWriting.toggle()
            } label: {
                HStack(spacing: 7) {
                    Image(systemName: "plus")
                    Text("나의 큐레이션 만들기")
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
            .fullScreenCover(isPresented: $isWriting, content: {
                WriteCurationSetView(isWriting: self.$isWriting, isEdit: false)
            })
            if let userCurations {
                ForEach(Array(userCurations.enumerated()), id: \.offset) { index, curation in
                    //TODO: 데이터 변경 필요
                    if let curation {
                        NavigationLink(destination: ReadUserCurationView(userCuration: curation)) {
                            if index < 2 {
                                UserCurationCell(curation: curation)
                            }
                        }
                    }
                }
            }
        }
        .background(Color.Background.ignoresSafeArea(.all, edges: .all))
    }
}

struct UserCurationListHeader: View {
    var title: String
    @Binding var userCurations: [Curation]
    var body: some View {
        HStack(alignment: .bottom) {
            Text(title)
                .Title2()
                .foregroundColor(.Gray5)
                .onTapGesture { }
            Spacer()
            if let userCurations {
                NavigationLink(destination: ListCurationView(userCurations: $userCurations, type: CurationType.myCuration)) {
                    Text("더보기")
                        .Footnote()
                        .foregroundColor(.Gray4)
                }
            }
        }
    }
}

//struct UserCurationListView_Previews: PreviewProvider {
//    static var previews: some View {
//        UserCurationListView(userCurations: UserCuration.fetchData(number: 5))
//    }
//}

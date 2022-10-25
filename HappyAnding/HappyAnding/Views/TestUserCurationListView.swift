//
//  UserCurationListView.swift
//  HappyAnding
//
//  Created by 전지민 on 2022/10/26.
//

import SwiftUI

struct TestUserCurationListView: View {
    let firebase = FirebaseService()
    @State var userCurations: [Curation] = []
    
    var body: some View {
        VStack(spacing: 0) {
            UserCurtaionListHeader(title: "나의 큐레이션")
                .padding(.bottom, 12)
                .padding(.horizontal, 16)
            NavigationLink(destination: WriteCurationInfoView()){
                HStack(spacing: 7) {
                    Image(systemName: "plus")
                    Text("나의 큐레이션 만들기")
                }
                .Headline()
                .foregroundColor(.Gray4)
                .frame(maxWidth: .infinity, maxHeight: 64)
                .background(Color.Gray1)
                .cornerRadius(12)
                .padding(.bottom, 6)
                .padding(.horizontal, 16)
            }
            ForEach(userCurations.indices, id: \.self) { index in
                NavigationLink(destination: ReadCurationView()) {
                    if index < 2 {
                        UserCurationCell(
                            title: userCurations[index].title,
                            subtitle: userCurations[index].subtitle,
                            shortcuts: userCurations[index].shortcuts
                        )
                    }
                }
            }
        }
        .background(Color.Background.ignoresSafeArea(.all, edges: .all))
        .onAppear() {
            firebase.fetchCuration { curations in
                userCurations = curations
            }
        }
    }
}

struct UserCurtaionListHeader: View {
    var title: String
    var body: some View {
        HStack(alignment: .bottom) {
            Text(title)
                .Title2()
                .foregroundColor(.Gray5)
                .onTapGesture { }
            Spacer()
            NavigationLink(destination: ListShortcutView()) {
                Text("더보기")
                    .Footnote()
                    .foregroundColor(.Gray4)
            }
        }
    }
}

//    struct UserCurationListView_Previews: PreviewProvider {
//        static var previews: some View {
//            UserCurationListView(userCurations: UserCuration.fetchData(number: 5))
//        }
//    }

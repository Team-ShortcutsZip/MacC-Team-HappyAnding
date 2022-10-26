//
//  UserCurationListView.swift
//  HappyAnding
//
//  Created by 전지민 on 2022/10/25.
//

import SwiftUI

struct UserCurationListView: View {
    
    var userCurations: [UserCuration]
    
    var body: some View {
        VStack(spacing: 0) {
            UserCurationListHeader(title: "나의 큐레이션")
                .padding(.bottom, 12)
                .padding(.horizontal, 16)
            NavigationLink(destination: WriteCurationInfoView()){
                HStack(spacing: 7) {
                    Image(systemName: "plus")
                    Text("나의 큐레이션 만들기")
                }
                .Headline()
                .foregroundColor(.Gray4)
                .frame(maxWidth: .infinity)
                .frame(height: 64)
                .background(Color.Gray1)
                .cornerRadius(12)
                .padding(.bottom, 12)
                .padding(.horizontal, 16)
            }
            ForEach(Array(userCurations.enumerated()), id: \.offset) { index, curation in
                NavigationLink(destination: ReadAdminCurationView()) {
                    if index < 2 {
                        UserCurationCell(
                            title: curation.title,
                            subtitle: curation.subtitle,
                            shortcuts: curation.shortcuts
                        )
                    }
                }
            }
        }
        .background(Color.Background.ignoresSafeArea(.all, edges: .all))
    }
}

struct UserCurationListHeader: View {
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

struct UserCurationListView_Previews: PreviewProvider {
    static var previews: some View {
        UserCurationListView(userCurations: UserCuration.fetchData(number: 5))
    }
}

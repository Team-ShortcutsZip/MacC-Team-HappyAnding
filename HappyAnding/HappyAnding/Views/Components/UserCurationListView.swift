//
//  UserCurationListView.swift
//  HappyAnding
//
//  Created by 전지민 on 2022/10/22.
//

import SwiftUI

struct UserCurationListView: View {
    var numberOfList: Int
    var userCurations = UserCuration.fetchData(number: 10)
    var body: some View {
        NavigationView {
            List {
                ListHeader(title: "나의 큐레이션")
                    .listRowInsets(
                        EdgeInsets(
                            top: 6,
                            leading: 16,
                            bottom: 6,
                            trailing: 16)
                    )
                    .listRowBackground(Color.Background)
                    .listRowSeparator(.hidden)
                ZStack {
                    NavigationLink(destination: WriteCurationInfoView()){}
                        .opacity(0)
                    HStack(spacing: 7) {
                        Image(systemName: "plus")
                        Text("나의 큐레이션 만들기")
                    }
                    .Headline()
                    .foregroundColor(.Gray4)
                }
                .frame(height: 64)
                .background(Color.Gray1)
                .cornerRadius(12)
                .listRowInsets(
                    EdgeInsets(
                        top: 6,
                        leading: 16,
                        bottom: 6,
                        trailing: 16)
                )
                .listRowBackground(Color.Background)
                
                ForEach(userCurations.indices, id: \.self) { index in
                    if index < numberOfList {
                        UserCurationCell(
                            title: userCurations[index].title,
                            subtitle: userCurations[index].subtitle,
                            shortcuts: userCurations[index].shortcuts
                        )
                        .listRowSeparator(.hidden)
                        .listRowInsets(EdgeInsets())
                        .listRowBackground(Color.Background)
                    }
                }
            }
            .listStyle(.plain)
            .background(Color.Background.ignoresSafeArea(.all, edges: .all))
            .scrollContentBackground(.hidden)
        }
    }
}

struct ListHeader: View {
    var title: String
    var body: some View {
        HStack(alignment: .bottom) {
            Text(title)
                .Title2()
                .foregroundColor(.Gray5)
                .onTapGesture { }
            ZStack(alignment: .trailing) {
                Text("더보기")
                    .Footnote()
                    .foregroundColor(.Gray4)
                NavigationLink(destination: ListShortcutView()){}.opacity(0)
            }
        }
    }
}

struct UserCurationListView_Previews: PreviewProvider {
    static var previews: some View {
        UserCurationListView(numberOfList: 5)
    }
}

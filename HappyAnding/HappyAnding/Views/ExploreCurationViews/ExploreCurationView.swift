//
//  ExploreCurationView.swift
//  HappyAnding
//
//  Created by 이지원 on 2022/10/19.
//

import SwiftUI

struct ExploreCurationView: View {
    
    @EnvironmentObject var shortcutsZipViewModel: ShortcutsZipViewModel
    @State var curationByMe: [Curation] = []
    
    let firebase = FirebaseService()
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 0) {
                    //앱 큐레이션
                    adminCurationsFrameiew(adminCurations: shortcutsZipViewModel.classifyAdminCuration())
                        .padding(.top, 20)
                        .padding(.bottom, 32)
                    //나의 큐레이션
                    UserCurationListView(userCurations: curationByMe)
                        .padding(.bottom, 20)
                    //추천 유저 큐레이션
                    CurationListView(curationListTitle: "스마트한 생활의 시작", userCurations: shortcutsZipViewModel.classifyUserCuration())
                }
                .padding(.bottom, 32)
            }
            .navigationTitle(Text("단축어 큐레이션"))
            .background(Color.Background)
        }
        .onAppear {
            firebase.fetchCurationByAuthor(author: firebase.currentUser()) { curations in
                curationByMe = curations
            }
        }
    }
}

struct adminCurationsFrameiew: View {
    
    let adminCurations: [Curation]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(alignment: .bottom) {
                Text("숏컷집의 추천 큐레이션")
                    .Title2()
                    .foregroundColor(.Gray5)
                    .onTapGesture { }
                Spacer()
                //추후에 어드민큐레이션에도 더보기 버튼 들어갈 수 있을 것 같아서 추가해놓은 코드입니다.
//                NavigationLink(destination: 더보기 눌렀을 때 뷰이름 입력) {
//                    Text("더보기")
//                        .Footnote()
//                        .foregroundColor(.Gray4)
//                }
            }
            .padding(.horizontal, 16)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 0) {
                    ForEach(adminCurations, id: \.id) { curation in
                        NavigationLink(destination: ReadAdminCurationView(curation: curation)) {
                            AdminCurationCell(adminCuration: curation)
                        }
                    }
//                    AdminCurationCell(curationThumbnail: "adminCurationTestImage", title: "갓생, 시작해보고 싶다면", subtitle: "갓생을 살고 싶은 당신을 위해 알람, 타이머, 투두리스트 등의 단축어를 모아봤어요!")
//                    AdminCurationCell(curationThumbnail: "adminCurationTestImage", title: "갓생, 시작해보고 싶다면", subtitle: "갓생을 살고 싶은 ")
                }
                .padding(.leading, 16)
                .padding(.trailing, 8)
            }
        }
    }
}


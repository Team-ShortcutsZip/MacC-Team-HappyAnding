//
//  UserCurationListView.swift
//  HappyAnding
//
//  Created by 전지민 on 2022/10/25.
//

import SwiftUI

struct UserCurationListView: View {
    @EnvironmentObject var shortcutsZipViewModel: ShortcutsZipViewModel
    @StateObject var writeCurationNavigation = WriteCurationNavigation()
    @State var isWriting = false
    @State var data: NavigationListCurationType
    @State var curations = [Curation]()
    
    var body: some View {
        VStack(spacing: 0) {
            listHeader
                .padding(.bottom, 12)
                .padding(.horizontal, 16)
            
            Button {
                self.isWriting = true
            } label: {
                
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
            
            ForEach(Array(curations.enumerated()), id: \.offset) { index, curation in
                
                let data = NavigationReadUserCurationType(userCuration: curation,
                                                          navigationParentView: self.data.navigationParentView)
                //TODO: 데이터 변경 필요
                if index < 2 {
                    NavigationLink(value: data) {
                        UserCurationCell(curation: curation,
                                         navigationParentView: self.data.navigationParentView)
                    }
                }
            }
        }
        .navigationDestination(for: NavigationReadUserCurationType.self) { data in
            ReadUserCurationView(data: data)
        }
        .background(Color.Background.ignoresSafeArea(.all, edges: .all))
        .fullScreenCover(isPresented: $isWriting) {
            NavigationStack(path: $writeCurationNavigation.navigationPath) {
                WriteCurationSetView(isWriting: $isWriting, isEdit: false)
            }
            .environmentObject(writeCurationNavigation)
        }
        .onAppear {
            self.data.curation = shortcutsZipViewModel.curationsMadeByUser
            self.curations = shortcutsZipViewModel.curationsMadeByUser
        }
        .onChange(of: shortcutsZipViewModel.curationsMadeByUser) { data in
            self.data.curation = data
            self.curations = data
        }
    }
    
    var listHeader: some View {
        HStack(alignment: .bottom) {
            Text(data.title ?? "")
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
        .navigationDestination(for: NavigationListCurationType.self) { data in
            ListCurationView(data: data)
        }
    }
}


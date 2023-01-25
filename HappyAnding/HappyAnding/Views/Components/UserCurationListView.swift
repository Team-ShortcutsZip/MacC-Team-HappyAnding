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
    @Environment(\.loginAlertKey) var loginAlert
    
    @AppStorage("useWithoutSignIn") var useWithoutSignIn: Bool = false
    
    @State var isWriting = false
    @State var data: NavigationListCurationType
    @State var curations = [Curation]()
    
    var body: some View {
        VStack(spacing: 0) {
            HStack(alignment: .bottom) {
                SubtitleTextView(text: data.title ?? "")
                    .onTapGesture { }
                Spacer()
                
                NavigationLink(value: data) {
                    MoreCaptionTextView(text: "더보기")
                }
            }
            .padding(.bottom, 12)
            .padding(.horizontal, 16)
            
            Button {
                if !useWithoutSignIn {
                    self.isWriting = true
                } else {
                    loginAlert.showAlert = true
                }
            } label: {
                
                HStack(spacing: 7) {
                    Image(systemName: "plus")
                    Text("추천 모음집 작성")
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
            
            ForEach(curations.prefix(2), id: \.self) { curation in
                
                let data = NavigationReadUserCurationType(userCuration: curation,
                                                          navigationParentView: self.data.navigationParentView)
                NavigationLink(value: data) {
                    UserCurationCell(curation: curation,
                                     navigationParentView: self.data.navigationParentView,
                                     lineLimit: 2)
                }
            }
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
}


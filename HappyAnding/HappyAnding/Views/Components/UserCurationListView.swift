//
//  UserCurationListView.swift
//  HappyAnding
//
//  Created by 전지민 on 2022/10/25.
//

import SwiftUI

// 설정 탭 - 내가 작성한 단축어
struct UserCurationListView: View {
    @Environment(\.loginAlertKey) var loginAlert
    @EnvironmentObject var shortcutsZipViewModel: ShortcutsZipViewModel
    
    @StateObject var writeCurationNavigation = WriteCurationNavigation()
    
    @AppStorage("useWithoutSignIn") var useWithoutSignIn: Bool = false
    
    @State var isWriting = false
    @State var data: CurationType
    @State var curation = Curation()
    
    var body: some View {
        VStack(spacing: 0) {
            HStack(alignment: .bottom) {
                SubtitleTextView(text: data.title )
                    .onTapGesture { }
                Spacer()
                
                MoreCaptionTextView(text: TextLiteral.more)
                    .navigationLinkRouter(data: data)
            }
            .padding(.bottom, 12)
            .padding(.horizontal, 16)
            
            Button {
                if !useWithoutSignIn {
                    self.isWriting = true
                } else {
                    loginAlert.isPresented = true
                }
            } label: {
                
                HStack(spacing: 6) {
                    Image(systemName: "plus")
                        .mediumIcon()
                    Text(TextLiteral.userCurationListViewAdd)
                        .shortcutsZipHeadline()
                }
                .foregroundColor(.gray4)
                .frame(maxWidth: .infinity)
                .frame(height: 64)
                .background(Color.backgroundPlus)
                .cornerRadius(12)
                .padding(.bottom, 12)
                .padding(.horizontal, 16)
            }
            
            ForEach(Array(shortcutsZipViewModel.curationsMadeByUser.enumerated()), id: \.offset) { index, curation in

                if index < 2 {
                    UserCurationCell(curation: .constant(curation),
                                     lineLimit: 2,
                                     navigationParentView: .curations)
                    .navigationLinkRouter(data: curation)
                    
                }
            }
        }
        .background(Color.shortcutsZipBackground.ignoresSafeArea(.all, edges: .all))
        .fullScreenCover(isPresented: $isWriting) {
            NavigationRouter(content: writeCurationView,
                             path: $writeCurationNavigation.navigationPath)
            .environmentObject(writeCurationNavigation)
        }
    }
    
    @ViewBuilder
    private func writeCurationView() -> some View {
        WriteCurationSetView(isWriting: $isWriting, viewModel: WriteCurationViewModel())
            .navigationDestination(for: WriteCurationViewModel.self) { data in
                WriteCurationInfoView(viewModel: data, isWriting: $isWriting)
                    .onDisappear() {
                        writeCurationNavigation.navigationPath = NavigationPath()
                    }
            }
    }
}


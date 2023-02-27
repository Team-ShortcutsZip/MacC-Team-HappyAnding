//
//  UserCurationListView.swift
//  HappyAnding
//
//  Created by 전지민 on 2022/10/25.
//

import SwiftUI

struct UserCurationListView: View {
    @Environment(\.loginAlertKey) var loginAlert
    @EnvironmentObject var shortcutsZipViewModel: ShortcutsZipViewModel
    
    @StateObject var writeCurationNavigation = WriteCurationNavigation()
    
    @AppStorage("useWithoutSignIn") var useWithoutSignIn: Bool = false
    
    @State var isWriting = false
    @State var data: NavigationListCurationType
    
    var body: some View {
        VStack(spacing: 0) {
            HStack(alignment: .bottom) {
                SubtitleTextView(text: data.title ?? "")
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
                        .MediumIcon()
                    Text(TextLiteral.userCurationListViewAdd)
                        .Headline()
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
                    let data = NavigationReadUserCurationType(userCuration: curation,
                                                              navigationParentView: self.data.navigationParentView)
                    UserCurationCell(curation: curation,
                                     lineLimit: 2,
                                     navigationParentView: self.data.navigationParentView)
                    .navigationLinkRouter(data: data)
                    
                }
            }
        }
        .background(Color.shortcutsZipBackground.ignoresSafeArea(.all, edges: .all))
        .fullScreenCover(isPresented: $isWriting) {
            NavigationRouter(content: writeCurationView,
                             path: $writeCurationNavigation.navigationPath)
        }
    }
    
    @ViewBuilder
    private func writeCurationView() -> some View {
        WriteCurationSetView(isWriting: $isWriting, isEdit: false)
            .environmentObject(writeCurationNavigation)
    }
}


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
    @AppStorage("useWithoutSignIn") var useWithoutSignIn: Bool = false
    
    @State var isWriting = false
    @State var data: NavigationListCurationType
    @State var curations = [Curation]()
    @State private var tryWriteWithoutSignIn: Bool = false

    
    var body: some View {
        VStack(spacing: 0) {
            listHeader
                .padding(.bottom, 12)
                .padding(.horizontal, 16)
            
            Button {
                if !useWithoutSignIn {
                    self.isWriting = true
                } else {
                    self.tryWriteWithoutSignIn = true
                }
            } label: {
                
                HStack(spacing: 7) {
                    Image(systemName: "plus")
                    Text(TextLiteral.userCurationListViewAdd)
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
        .alert(TextLiteral.loginTitle, isPresented: $tryWriteWithoutSignIn) {
            Button(role: .cancel) {
                tryWriteWithoutSignIn = false
            } label: {
                Text(TextLiteral.cancel)
            }
            Button {
                useWithoutSignIn = false
                tryWriteWithoutSignIn = false
            } label: {
                Text(TextLiteral.loginAction)
            }
        } message: {
            Text(TextLiteral.loginMessage)
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
                Text(TextLiteral.more)
                    .Footnote()
                    .foregroundColor(.Gray4)
            }
        }
    }
}


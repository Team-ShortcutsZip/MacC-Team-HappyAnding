//
//  ReadCurationView.swift
//  HappyAnding
//
//  Created by HanGyeongjun on 2022/10/22.
//

import SwiftUI

struct ReadCurationView: View {
    @Environment(\.presentationMode) var presentation: Binding<PresentationMode>
    
    @EnvironmentObject var shortcutsZipViewModel: ShortcutsZipViewModel
    @StateObject var writeCurationNavigation = WriteCurationNavigation()
    
    @State var authorInformation: User? = nil
    @State var isWriting = false
    @State var isTappedEditButton = false
    @State var isTappedShareButton = false
    @State var isTappedDeleteButton = false
    @State var data: NavigationReadCurationType
    @State var index = 0
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            
            if data.isAdmin {
                adminCuration
            } else {
                userCuration
            }
            
            VStack(spacing: 0) {
                ForEach(shortcutsZipViewModel.userCurations[index].shortcuts, id: \.self) { shortcut in
                    let data = NavigationReadShortcutType(shortcutID: shortcut.id,
                                                          navigationParentView: self.data.navigationParentView)
                    ShortcutCell(shortcutCell: shortcut,
                                 navigationParentView: self.data.navigationParentView)
                    .navigationLinkRouter(data: data)
                    
                }
            }
            .padding(.bottom, 44)
            
        }
        .background(Color.shortcutsZipBackground.ignoresSafeArea(.all, edges: .all))
        .scrollContentBackground(.hidden)
        .edgesIgnoringSafeArea(.top)
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarItems(trailing: readCurationViewButtonByUser())
        .fullScreenCover(isPresented: $isWriting) {
            NavigationRouter(content: editView, path: $writeCurationNavigation.navigationPath)
                .environmentObject(writeCurationNavigation)
        }
        .alert(TextLiteral.readUserCurationViewDeletionTitle, isPresented: $isTappedDeleteButton) {
            Button(role: .cancel) {
                self.isTappedDeleteButton.toggle()
            } label: {
                Text(TextLiteral.cancel)
            }
            
            Button(role: .destructive) {
                shortcutsZipViewModel.deleteData(model: self.data.curation)
                shortcutsZipViewModel.curationsMadeByUser = shortcutsZipViewModel.curationsMadeByUser.filter { $0.id != self.data.curation.id }
                presentation.wrappedValue.dismiss()
            } label: {
                Text(TextLiteral.delete)
            }
        } message: {
            Text(TextLiteral.readUserCurationViewDeletionMessage)
        }
    }
    
    var userCuration: some View {
        ZStack(alignment: .bottom) {
            
            StickyHeader(height: 100)
            
            VStack(spacing: 16) {
                userInformation
                    .padding(EdgeInsets(top: 103, leading: 16, bottom: 0, trailing: 16))
                
                UserCurationCell(curation: data.curation, navigationParentView: data.navigationParentView)
            }
        }
        .padding(.bottom, 8)
        .background(Color.shortcutsZipWhite)
        .padding(.bottom, 12)
    }
    
    var adminCuration: some View {
        VStack {
            StickyHeader(height: 304, image: data.curation.background)
                .padding(.bottom, 20)
            
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    SubtitleTextView(text: data.curation.title)
                    Text(data.curation.subtitle.replacingOccurrences(of: "\\n", with: "\n"))
                        .shortcutsZipBody2()
                        .foregroundColor(.gray4)
                }
                Spacer()
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 8)
        }
    }
    var userInformation: some View {
        ZStack {
            UserNameCell(userInformation: self.authorInformation, gradeImage: shortcutsZipViewModel.fetchShortcutGradeImage(isBig: false, shortcutGrade: shortcutsZipViewModel.checkShortcutGrade(userID: authorInformation?.id ?? "!")))
        }
        .onAppear {
            shortcutsZipViewModel.fetchUser(userID: self.data.curation.author,
                                            isCurrentUser: false) { user in
                authorInformation = user
            }
            if let index = shortcutsZipViewModel.userCurations.firstIndex(where: { $0.id == data.curation.id}) {
                self.index = index
            }
        }
    }
}


extension ReadCurationView {
    
    @ViewBuilder
    private func editView() -> some View {
        WriteCurationSetView(isWriting: $isWriting,
                             curation: shortcutsZipViewModel.userCurations[index]
                             ,isEdit: true
        )
        .navigationDestination(for: WriteCurationInfoType.self) { data in
            WriteCurationInfoView(data: data, isWriting: $isWriting)
        }
    }
    
    @ViewBuilder
    private func readCurationViewButtonByUser() -> some View {
        if self.data.curation.author == shortcutsZipViewModel.currentUser() {
            myCurationMenu
        } else {
            shareButton
        }
    }
    
    private var myCurationMenu: some View {
        Menu(content: {
            Section {
                editButton
                shareButton
                deleteButton
            }
        }, label: {
            Image(systemName: "ellipsis")
                .foregroundColor(.gray4)
        })
    }
    
    private var editButton: some View {
        Button {
            self.isWriting.toggle()
        } label: {
            Label(TextLiteral.edit, systemImage: "square.and.pencil")
        }
    }
    
    private var shareButton: some View {
        Button(action: {
            shareCuration()
        }) {
            Label(TextLiteral.share, systemImage: "square.and.arrow.up")
                .foregroundColor(.gray4)
                .fontWeight(.medium)
        }
    }
    
    private var deleteButton: some View {
        Button(role: .destructive, action: {
            isTappedDeleteButton.toggle()
        }) {
            Label(TextLiteral.delete, systemImage: "trash.fill")
        }
    }
    
    private func shareCuration() {
        guard let deepLink = URL(string: "ShortcutsZip://myPage/CurationDetailView?curationID=\(data.curation.id)") else { return }
        
        let activityVC = UIActivityViewController(activityItems: [deepLink], applicationActivities: nil)
        let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
        guard let window = windowScene?.windows.first else { return }
        window.rootViewController?.present(activityVC, animated: true, completion: nil)
    }
}


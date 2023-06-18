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
    @StateObject var readCurationViewModel: ReadCurationViewModel
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            
            if readCurationViewModel.data.isAdmin {
                adminCuration
            } else {
                userCuration
            }
            
            VStack(spacing: 0) {
                ForEach(readCurationViewModel.data.curation.shortcuts, id: \.self) { shortcut in
                    let data = NavigationReadShortcutType(shortcutID: shortcut.id,
                                                          navigationParentView: readCurationViewModel.data.navigationParentView)
                    ShortcutCell(shortcutCell: shortcut,
                                 navigationParentView: readCurationViewModel.data.navigationParentView)
                    .navigationLinkRouter(data: data)
                    
                }
            }
            .padding(.bottom, 44)
            
        }
        .background(Color.shortcutsZipBackground.ignoresSafeArea(.all, edges: .all))
        .scrollContentBackground(.hidden)
        .edgesIgnoringSafeArea(.top)
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarItems(trailing: navigationBarItems())
        .fullScreenCover(isPresented: $readCurationViewModel.isWriting) {
            NavigationRouter(content: editCuration, path: $writeCurationNavigation.navigationPath)
                .environmentObject(writeCurationNavigation)
        }
        .alert(TextLiteral.readCurationViewDeletionTitle, isPresented: $readCurationViewModel.isTappedDeleteButton) {
            Button(role: .cancel) {
                readCurationViewModel.isTappedDeleteButton.toggle()
            } label: {
                Text(TextLiteral.cancel)
            }
            
            Button(role: .destructive) {
                shortcutsZipViewModel.deleteData(model: readCurationViewModel.data.curation)
                shortcutsZipViewModel.curationsMadeByUser = shortcutsZipViewModel.curationsMadeByUser.filter { $0.id != readCurationViewModel.data.curation.id }
                presentation.wrappedValue.dismiss()
            } label: {
                Text(TextLiteral.delete)
            }
        } message: {
            Text(TextLiteral.readCurationViewDeletionMessage)
        }
    }
    
    var userCuration: some View {
        ZStack(alignment: .bottom) {
            
            StickyHeader(height: 100)
            
            VStack(spacing: 16) {
                UserNameCell(userInformation: readCurationViewModel.authorInformation,
                             gradeImage: shortcutsZipViewModel.fetchShortcutGradeImage(isBig: false, shortcutGrade: shortcutsZipViewModel.checkShortcutGrade(userID: readCurationViewModel.authorInformation?.id ?? "!")))
                .padding(EdgeInsets(top: 103, leading: 16, bottom: 0, trailing: 16))
                
                UserCurationCell(curation: readCurationViewModel.data.curation, navigationParentView: readCurationViewModel.data.navigationParentView)
            }
        }
        .padding(.bottom, 8)
        .background(Color.shortcutsZipWhite)
        .padding(.bottom, 12)
    }
    
    var adminCuration: some View {
        VStack {
            StickyHeader(height: 304, image: readCurationViewModel.data.curation.background)
                .padding(.bottom, 20)
            
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    SubtitleTextView(text: readCurationViewModel.data.curation.title)
                    Text(readCurationViewModel.data.curation.subtitle.replacingOccurrences(of: "\\n", with: "\n"))
                        .shortcutsZipBody2()
                        .foregroundColor(.gray4)
                }
                
                Spacer()
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 8)
        }
    }
}


extension ReadCurationView {
    
    @ViewBuilder
    private func editCuration() -> some View {
        WriteCurationSetView(isWriting: $readCurationViewModel.isWriting,
                             curation: readCurationViewModel.data.curation,
                             isEdit: true
        )
        .navigationDestination(for: WriteCurationInfoType.self) { data in
            WriteCurationInfoView(data: data, isWriting: $readCurationViewModel.isWriting)
        }
    }
    
    @ViewBuilder
    private func navigationBarItems() -> some View {
        if readCurationViewModel.data.curation.author == shortcutsZipViewModel.currentUser() {
            Menu {
                Section {
                    editButton
                    shareButton
                    deleteButton
                }
            } label: {
                Image(systemName: "ellipsis")
                    .foregroundColor(.gray4)
            }
        } else {
            shareButton
        }
    }
    
    private var editButton: some View {
        Button {
            readCurationViewModel.isWriting.toggle()
        } label: {
            Label(TextLiteral.edit, systemImage: "square.and.pencil")
        }
    }
    
    private var shareButton: some View {
        Button {
            readCurationViewModel.shareCuration()
        } label: {
            Label(TextLiteral.share, systemImage: "square.and.arrow.up")
                .foregroundColor(.gray4)
                .fontWeight(.medium)
        }
    }
    
    private var deleteButton: some View {
        Button(role: .destructive) {
            readCurationViewModel.isTappedDeleteButton.toggle()
        } label: {
            Label(TextLiteral.delete, systemImage: "trash.fill")
        }
    }
}


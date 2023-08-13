//
//  ReadCurationView.swift
//  HappyAnding
//
//  Created by HanGyeongjun on 2022/10/22.
//

import SwiftUI

struct ReadCurationView: View {
    @Environment(\.presentationMode) var presentation: Binding<PresentationMode>
    @StateObject var writeCurationNavigation = WriteCurationNavigation()
    @StateObject var viewModel: ReadCurationViewModel
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            
            if viewModel.isAdmin {
                adminCuration
            } else {
                userCuration
            }
            
            VStack(spacing: 0) {
                ForEach(viewModel.curation.shortcuts, id: \.self) { shortcutCellModel in
                    
                    ShortcutCell(shortcutCell: shortcutCellModel,
                                 navigationParentView: .curations)
                    .navigationLinkRouter(data: viewModel.fetchShortcut(from: shortcutCellModel))
                    
                }
            }
            .padding(.bottom, 44)
            
        }
        .background(Color.shortcutsZipBackground.ignoresSafeArea(.all, edges: .all))
        .scrollContentBackground(.hidden)
        .edgesIgnoringSafeArea(.top)
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarItems(trailing: readCurationViewButtonByUser())
        .fullScreenCover(isPresented: $viewModel.isWriting) {
            NavigationRouter(content: editView, path: $writeCurationNavigation.navigationPath)
                .environmentObject(writeCurationNavigation)
        }
        .alert(TextLiteral.readCurationViewDeletionTitle, isPresented: $viewModel.isTappedDeleteButton) {
            Button(role: .cancel) {
                viewModel.isTappedDeleteButton.toggle()
            } label: {
                Text(TextLiteral.cancel)
            }
            
            Button(role: .destructive) {
                viewModel.deleteCuration()
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
                UserNameCell(userInformation: viewModel.authInformation, gradeImage: viewModel.gradeImage)
                    .padding(EdgeInsets(top: 103, leading: 16, bottom: 0, trailing: 16))
                
                UserCurationCell(curation: viewModel.curation, navigationParentView: .curations)
            }
        }
        .padding(.bottom, 8)
        .background(Color.shortcutsZipWhite)
        .padding(.bottom, 12)
    }
    
    var adminCuration: some View {
        VStack {
            StickyHeader(height: 304, image: viewModel.curation.background)
                .padding(.bottom, 20)
            
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    SubtitleTextView(text: viewModel.curation.title)
                    Text(viewModel.curation.subtitle.replacingOccurrences(of: "\\n", with: "\n"))
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
    private func editView() -> some View {
        WriteCurationSetView(isWriting: $viewModel.isWriting, viewModel: WriteCurationViewModel(data: viewModel.curation))
            .navigationDestination(for: WriteCurationViewModel.self) { data in
                WriteCurationInfoView(viewModel: data, isWriting: $viewModel.isWriting)
        }
    }
    
    @ViewBuilder
    private func readCurationViewButtonByUser() -> some View {
        if viewModel.checkAuthor() {
            myCurationMenu
        } else {
            shareButton
        }
    }
    
    private var myCurationMenu: some View {
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
    }
    
    private var editButton: some View {
        Button {
            self.viewModel.isWriting.toggle()
        } label: {
            Label(TextLiteral.edit, systemImage: "square.and.pencil")
        }
    }
    
    private var shareButton: some View {
        Button {
            viewModel.shareCuration()
        } label: {
            Label(TextLiteral.share, systemImage: "square.and.arrow.up")
                .foregroundColor(.gray4)
                .fontWeight(.medium)
        }
    }
    
    private var deleteButton: some View {
        Button(role: .destructive) {
            viewModel.isTappedDeleteButton.toggle()
        } label: {
            Label(TextLiteral.delete, systemImage: "trash.fill")
        }
    }
}

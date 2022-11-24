//
//  ReadUserCurationView.swift
//  HappyAnding
//
//  Created by HanGyeongjun on 2022/10/22.
//

import SwiftUI

struct ReadUserCurationView: View {
    
    @Environment(\.presentationMode) var presentation: Binding<PresentationMode>
    
    @EnvironmentObject var shortcutsZipViewModel: ShortcutsZipViewModel
    @StateObject var writeCurationNavigation = WriteCurationNavigation()
    @State var authorInformation: User? = nil
    
    @State var isWriting = false
    @State var isTappedEditButton = false
    @State var isTappedShareButton = false
    @State var isTappedDeleteButton = false
    @State var data: NavigationReadUserCurationType
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            ZStack(alignment: .bottom) {
                
                GeometryReader { geo in
                    let yOffset = geo.frame(in: .global).minY
                    
                    Color.White
                        .frame(width: geo.size.width, height: 371 + (yOffset > 0 ? yOffset : 0))
                        .offset(y: yOffset > 0 ? -yOffset : 0)
                }
                .frame(minHeight: 371)
                
                VStack {
                    userInformation
                        .padding(.top, 103)
                        .padding(.bottom, 22)
                    
                    UserCurationCell(curation: data.userCuration,
                                     navigationParentView: data.navigationParentView)
                    .padding(.bottom, 12)
                }
            }
            VStack(spacing: 0){
                ForEach(Array(self.data.userCuration.shortcuts.enumerated()), id: \.offset) { index, shortcut in
                    let data = NavigationReadShortcutType(shortcutID: shortcut.id,
                                                          navigationParentView: self.data.navigationParentView)
                    
                    NavigationLink(value: data) {
                        ShortcutCell(shortcutCell: shortcut,
                                     navigationParentView: self.data.navigationParentView)
                        .padding(.bottom, index == self.data.userCuration.shortcuts.count - 1 ? 44 : 0)
                    }
                }
            }
            
        }
        .onChange(of: isWriting) { _ in
            if !isWriting {
                if let updatedCuration = shortcutsZipViewModel.fetchCurationDetail(curationID: data.userCuration.id) {
                    data.userCuration = updatedCuration
                }
            }
        }
        .navigationDestination(for: NavigationReadShortcutType.self) { data in
            ReadShortcutView(data: data)
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: BackButton)
        .toolbarBackground(Color.clear, for: .navigationBar)
        .background(Color.Background.ignoresSafeArea(.all, edges: .all))
        .scrollContentBackground(.hidden)
        .edgesIgnoringSafeArea([.top])
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarItems(trailing: Menu(content: {
            curationMenuSection
        }, label: {
            Image(systemName: "ellipsis")
                .foregroundColor(.Gray4)
        }))
        .fullScreenCover(isPresented: $isWriting) {
            NavigationStack(path: $writeCurationNavigation.navigationPath) {
                WriteCurationSetView(isWriting: $isWriting,
                                     curation: self.data.userCuration,
                                     isEdit: true)
            }
            .environmentObject(writeCurationNavigation)
        }
    }
    
    var userInformation: some View {
        ZStack {
            HStack {
                Image(systemName: "person.fill")
                    .frame(width: 28, height: 28)
                    .foregroundColor(.White)
                    .background(Color.Gray3)
                    .clipShape(Circle())
                
                Text(authorInformation?.nickname ?? "닉네임")
                    .Headline()
                    .foregroundColor(.Gray4)
                Spacer()
            }
            .padding(.horizontal, 30)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .frame(height: 48)
                    .foregroundColor(.Gray1)
                    .padding(.horizontal, 16)
            )
        }
        .onAppear {
            shortcutsZipViewModel.fetchUser(userID: self.data.userCuration.author) { user in
                authorInformation = user
            }
        }
    }
    var BackButton: some View {
        Button(action: {
        self.presentation.wrappedValue.dismiss()
        }) {
            //TODO: 위치와 두께, 색상 조정 필요
            Image(systemName: "chevron.backward")
                .foregroundColor(Color.Gray5)
                .bold()
        }
    }
}


extension ReadUserCurationView {
    
    var curationMenuSection: some View {
        Button(action: {
            //Place something action here
        }) {
            Label("공유", systemImage: "square.and.arrow.up")
        }
    }
}


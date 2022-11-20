//
//  ReadShortcutView.swift
//  HappyAnding
//
//  Created by 이지원 on 2022/10/19.
//

import SwiftUI

struct ReadShortcutView: View {
    
    @EnvironmentObject var shortcutsZipViewModel: ShortcutsZipViewModel
    @Environment(\.presentationMode) var presentation: Binding<PresentationMode>
    @Environment(\.openURL) private var openURL
    
    @StateObject var writeNavigation = WriteShortcutNavigation()
    @State var isTappedDeleteButton = false
    @State var isEdit = false
    
    @State var isMyLike: Bool = false
    @State var isFirstMyLike = false
    @State var isClickDownload = false
    
    @State var data: NavigationReadShortcutType
    
    var body: some View {
        
        VStack {
            
            if let shortcut = data.shortcut {
                ReadShortcutHeaderView(shortcut: $data.shortcut.unwrap()!, isMyLike: $isMyLike)
                ReadShortcutContentView(shortcut: $data.shortcut.unwrap()!)
                
                Button(action: {
                    if let url = URL(string: shortcut.downloadLink[0]) {
                        openURL(url)
                        if (shortcutsZipViewModel.userInfo?.downloadedShortcuts.firstIndex(where: { $0.id == data.shortcutID })) == nil {
                            data.shortcut?.numberOfDownload += 1
                        }
                        isClickDownload = true
                    }
                }) {
                    RoundedRectangle(cornerRadius: 12)
                        .foregroundColor(Color.Primary)
                        .frame(height: 52)
                        .padding(.horizontal, 16)
                        .overlay {
                            Text("다운로드 | \(Image(systemName: "arrow.down.app.fill")) \(shortcut.numberOfDownload)")
                                .Body1()
                                .foregroundColor(Color.Text_icon)
                        }
                }
            }
        }
        .padding(.vertical, 20)
        .background(Color.Background)
        .onAppear() {
            data.shortcut = shortcutsZipViewModel.fetchShortcutDetail(id: data.shortcutID)
            isMyLike = shortcutsZipViewModel.checkLikedShortrcut(shortcutID: data.shortcutID)
            isFirstMyLike = isMyLike
        }
        .onChange(of: isEdit) { _ in
            if !isEdit {
                data.shortcut = shortcutsZipViewModel.fetchShortcutDetail(id: data.shortcutID)
            }
        }
        .onDisappear() {
            if let shortcut = data.shortcut {
                let isAlreadyContained = shortcutsZipViewModel.userInfo?.downloadedShortcuts.firstIndex(where: { $0.id == self.data.shortcutID}) == nil
                if isClickDownload && isAlreadyContained {
                    shortcutsZipViewModel.updateNumberOfDownload(shortcut: shortcut)
                    shortcutsZipViewModel.shortcutsUserDownloaded.insert(shortcut, at: 0)

                    let downloadedShortcut = DownloadedShortcut(id: shortcut.id, downloadLink: shortcut.downloadLink[0])
                    shortcutsZipViewModel.userInfo?.downloadedShortcuts.insert(downloadedShortcut, at: 0)
                }
                if isMyLike != isFirstMyLike {
                    shortcutsZipViewModel.updateNumberOfLike(isMyLike: isMyLike, shortcut: shortcut)
                    if isMyLike {
                        shortcutsZipViewModel.userInfo?.likedShortcuts.insert(self.data.shortcutID, at: 0)
                        shortcutsZipViewModel.shortcutsUserLiked.insert(shortcut, at: 0)
                    } else {
                        shortcutsZipViewModel.userInfo?.likedShortcuts.removeAll(where: { $0 == self.data.shortcutID })
                        shortcutsZipViewModel.shortcutsUserLiked.removeAll(where: { $0.id == self.data.shortcutID })
                    }
                }
            }
        }
        .navigationBarTitleDisplayMode(NavigationBarItem.TitleDisplayMode.inline)
        .navigationBarItems(trailing: Menu(content: {
            if self.data.shortcut?.author == shortcutsZipViewModel.currentUser() {
                myShortcutMenuSection
            } else {
                otherShortcutMenuSection
            }
        }, label: {
            Image(systemName: "ellipsis")
                .foregroundColor(.Gray4)
        }))
        .alert(isPresented: $isTappedDeleteButton) {
            Alert(title: Text("글 삭제").foregroundColor(.Gray5),
                  message: Text("글을 삭제하시겠습니까?").foregroundColor(.Gray5),
                  primaryButton: .default(
                    Text("닫기"),
                    action: {
                        self.isTappedDeleteButton.toggle()
                    }),
                  secondaryButton: .destructive(
                    Text("삭제"),
                    action: {
                        if let shortcut = data.shortcut {
                            shortcutsZipViewModel.deleteData(model: shortcut)
                            self.presentation.wrappedValue.dismiss()
                        }
                    }
                  )
            )
        }
        .fullScreenCover(isPresented: $isEdit) {
            NavigationStack(path: $writeNavigation.navigationPath) {
                if let shortcut = data.shortcut {
                    WriteShortcutTitleView(isWriting: $isEdit,
                                           shortcut: shortcut,
                                           isEdit: true)
                }
            }
            .environmentObject(writeNavigation)
        }
    }
}

extension ReadShortcutView {
    
    var myShortcutMenuSection: some View {
        
        Section {
            
            Button {
                isEdit.toggle()
            } label: {
                Label("편집", systemImage: "square.and.pencil")
            }
            
            Button(action: {
                share()
            }) {
                Label("공유", systemImage: "square.and.arrow.up")
            }
            
            Button(role: .destructive, action: {
                isTappedDeleteButton.toggle()
             }) {
                 Label("삭제", systemImage: "trash.fill")
             }
        }
        
    }
    
    var otherShortcutMenuSection: some View {
        Section {
            Button(action: {
                share()
            }) {
                Label("공유", systemImage: "square.and.arrow.up")
            }
            
            //TODO: 2차 스프린트 이후 신고 기능 추가 시 사용할 코드
//            Button(action: {
//                //Place something action here
//            }) {
//                Label("신고", systemImage: "light.beacon.max.fill")
//            }
        }
    }
    
    func share() {
        if let shortcut = data.shortcut {
            guard let downloadLink = URL(string: shortcut.downloadLink.last!) else { return }
            let activityVC = UIActivityViewController(activityItems: [downloadLink], applicationActivities: nil)
            UIApplication.shared.windows.first?.rootViewController?.present(activityVC, animated: true, completion: nil)
        }
    }
}

//struct ReadShortcutView_Previews: PreviewProvider {
//    static var previews: some View {
//        ReadShortcutView()
//    }
//}

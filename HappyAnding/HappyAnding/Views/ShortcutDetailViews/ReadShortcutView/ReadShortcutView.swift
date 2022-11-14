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
    @State var isEdit = false
    @State var isTappedDeleteButton = false
    
    @State var shortcut = Shortcuts(sfSymbol: "", color: "", title: "", subtitle: "", description: "", category: [], requiredApp: [], numberOfLike: 0, numberOfDownload: 0, author: "", shortcutRequirements: "", downloadLink: [], curationIDs: [])
    @State var isMyLike: Bool = false
    @State var isFirstMyLike = false
    @State var isClickDownload = false
    let shortcutID: String
    
    var body: some View {
        
        VStack {
            
            if let shortcut {
                ReadShortcutHeaderView(shortcut: $shortcut, isMyLike: $isMyLike)
                ReadShortcutContentView(shortcut: shortcut)
                
                Button(action: {
                    if let url = URL(string: shortcut.downloadLink[0]) {
                        openURL(url)
                        //UI 업데이트
                        if (shortcutsZipViewModel.userInfo?.downloadedShortcuts.firstIndex(of: shortcut.id)) == nil {
                            self.shortcut.numberOfDownload += 1
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
            self.shortcut = shortcutsZipViewModel.fetchShortcutDetail(id: shortcutID) ?? shortcut.getNull()
            isMyLike = shortcutsZipViewModel.checkLikedShortrcut(shortcutID: shortcutID)
            isFirstMyLike = isMyLike
        }
        .onDisappear() {
            let isAlreadyContained = (shortcutsZipViewModel.userInfo?.downloadedShortcuts.firstIndex(of: shortcutID)) == nil
            
            if (isClickDownload && isAlreadyContained) || isMyLike != isFirstMyLike {
                if isClickDownload && isAlreadyContained {
                    shortcutsZipViewModel.updateNumberOfDownload(shortcut: shortcut)
                    shortcutsZipViewModel.shortcutsUserDownloaded.insert(shortcut, at: 0)
                    shortcutsZipViewModel.userInfo?.downloadedShortcuts.insert(shortcutID, at: 0)
                }
                if isMyLike != isFirstMyLike {
                    shortcutsZipViewModel.updateNumberOfLike(isMyLike: isMyLike, shortcut: shortcut)
                    if isMyLike {
                        shortcutsZipViewModel.userInfo?.likedShortcuts.insert(shortcutID, at: 0)
                        shortcutsZipViewModel.shortcutsUserLiked.insert(shortcut, at: 0)
                    } else {
                        shortcutsZipViewModel.userInfo?.likedShortcuts.removeAll(where: { $0 == shortcutID })
                        shortcutsZipViewModel.shortcutsUserLiked.removeAll(where: { $0.id == shortcutID })
                    }
                }
            }
        }
        .navigationBarTitleDisplayMode(NavigationBarItem.TitleDisplayMode.inline)
        .navigationBarItems(trailing: Menu(content: {
            if shortcut.author == shortcutsZipViewModel.currentUser() {
                myShortcutMenuSection
            } else {
                otherShortcutMenuSection
            }
        }, label: {
            Image(systemName: "ellipsis")
                .foregroundColor(.Gray4)
        }))
        .fullScreenCover(isPresented: $isEdit) {
            NavigationView {
                if let shortcut {
                    WriteShortcutTitleView(isWriting: $isEdit, shortcut: shortcut, isEdit: true)
                }
            }
        }
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
                        shortcutsZipViewModel.deleteShortcutIDInUser(shortcutID: shortcut.id)
                        shortcutsZipViewModel.deleteShortcutInCuration(curationsIDs: shortcut.curationIDs, shortcutID: shortcut.id)
                        shortcutsZipViewModel.deleteData(model: shortcut)
                        shortcutsZipViewModel.shortcutsMadeByUser = shortcutsZipViewModel.shortcutsMadeByUser.filter { $0.id != shortcut.id }
                    }
                  )
            )
        }
    }
}

extension ReadShortcutView {
    var myShortcutMenuSection: some View {
        Section {
            
            Button(action: {
                isEdit.toggle()
            }) {
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
        guard let downloadLink = URL(string: shortcut.downloadLink.last!) else { return }
        let activityVC = UIActivityViewController(activityItems: [downloadLink], applicationActivities: nil)
        UIApplication.shared.windows.first?.rootViewController?.present(activityVC, animated: true, completion: nil)
    }
}

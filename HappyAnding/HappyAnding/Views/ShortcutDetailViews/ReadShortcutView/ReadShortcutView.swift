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
    @State var shortcut: Shortcuts?
    @State var isEdit = false
    @State var isUpdating = false
    
    @State var data: NavigationReadShortcutType
    
    var body: some View {
        
        VStack {
            
            if let shortcut {
                ReadShortcutHeaderView(shortcut: self.$shortcut.unwrap()!)
                ReadShortcutContentView(shortcut: self.$shortcut.unwrap()!)
                
                Button(action: {
                    if let url = URL(string: shortcut.downloadLink[0]) {
                        shortcutsZipViewModel.updateNumberOfDownload(shortcut: shortcut)
                        shortcutsZipViewModel.shortcutsUserDownloaded.append(shortcut)
                        openURL(url)
                        //TODO: 화면 상의 다운로드 숫자 변경 기능 필요
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
            shortcutsZipViewModel.fetchShortcutDetail(id: self.data.shortcutID) { shortcut in
                self.shortcut = shortcut
                print("hellohello \(self.$shortcut.unwrap()!)")
            }
        }
        .onChange(of: isEdit) { _ in
            if !isEdit {
                shortcutsZipViewModel.fetchShortcutDetail(id: self.data.shortcutID) { shortcut in
                    self.shortcut = shortcut
                    print(shortcut)
                }
            }
        }
        .safeAreaInset(edge: .bottom, spacing: 0) {
           
            VStack {
                if let shortcut {
                    Button {
                        if let url = URL(string: shortcut.downloadLink[0]) {
                            shortcutsZipViewModel.updateNumberOfDownload(shortcut: shortcut)
                            shortcutsZipViewModel.shortcutsUserDownloaded.append(shortcut)
                            openURL(url)
                        }
                        
                    } label: {
                        Text("다운로드 | \(Image(systemName: "arrow.down.app.fill")) \(shortcut.numberOfDownload)")
                            .Body1()
                            .foregroundColor(Color.Text_icon)
                    }
                }
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color.Primary)
        }
        .navigationBarTitleDisplayMode(NavigationBarItem.TitleDisplayMode.inline)
        .navigationBarItems(trailing: Menu(content: {
            if shortcut?.author == shortcutsZipViewModel.currentUser() {
                myShortcutMenuSection
            } else {
                otherShortcutMenuSection
            }
        }, label: {
            Image(systemName: "ellipsis")
                .foregroundColor(.Gray4)
        }))
        .alert("글 삭제", isPresented: $isTappedDeleteButton) {
            Button(role: .cancel) {
                
            } label: {
                Text("닫기")
            }
            
            Button(role: .destructive) {
                if let shortcut {
                    shortcutsZipViewModel.deleteShortcutIDInUser(shortcutID: shortcut.id)
                    shortcutsZipViewModel.deleteShortcutInCuration(curationsIDs: shortcut.curationIDs, shortcutID: shortcut.id)
                    shortcutsZipViewModel.deleteData(model: shortcut)
                    shortcutsZipViewModel.shortcutsMadeByUser = shortcutsZipViewModel.shortcutsMadeByUser.filter { $0.id != shortcut.id }
                    self.presentation.wrappedValue.dismiss()
                }
            } label: {
                Text("삭제")
            }
        } message: {
            Text("글을 삭제하시겠습니까?")
        }
        .fullScreenCover(isPresented: $isEdit) {
            NavigationStack(path: $writeNavigation.navigationPath) {
                if let shortcut {
                    WriteShortcutTitleView(isWriting: $isEdit,
                                           shortcut: shortcut,
                                           isEdit: true)
                }
            }
            .environmentObject(writeNavigation)
        }
        .fullScreenCover(isPresented: $isUpdating) {
            UpdateShortcutView(isUpdating: $isUpdating, shortcut: $shortcut)
        }
        .toolbar(.hidden, for: .tabBar)
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
            
            Button {
                isUpdating.toggle()
            } label: {
                Label("업데이트", systemImage: "clock.arrow.circlepath")
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
        if let shortcut {
            guard let downloadLink = URL(string: shortcut.downloadLink.last!) else { return }
            let activityVC = UIActivityViewController(activityItems: [downloadLink], applicationActivities: nil)
            let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
            guard let window = windowScene?.windows.first else { return }
            window.rootViewController?.present(activityVC, animated: true, completion: nil)
        }
    }
}

//struct ReadShortcutView_Previews: PreviewProvider {
//    static var previews: some View {
//        ReadShortcutView()
//    }
//}

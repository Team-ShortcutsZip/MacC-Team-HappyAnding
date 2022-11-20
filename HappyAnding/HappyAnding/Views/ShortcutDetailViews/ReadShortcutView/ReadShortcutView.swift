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
    
    @State var data: NavigationReadShortcutType
    
    @State var height: CGFloat = 0
    
    var body: some View {
        
        ScrollView {
            VStack {
                if let shortcut {
                    
                    // MARK: - 단축어 타이틀
                    ReadShortcutHeaderView(shortcut: self.$shortcut.unwrap()!)
                        .frame(height: 160)
                    
                    // MARK: - 탭뷰 (기본 정보, 버전 정보, 댓글)
                    ReadShortcutTabView(shortcut: self.$shortcut.unwrap()!, heigth: self.$height)
                        .padding(.horizontal, 16)
                        .frame(minHeight: 300, maxHeight: .infinity)
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
                        if let shortcut {
                            shortcutsZipViewModel.deleteShortcutIDInUser(shortcutID: shortcut.id)
                            shortcutsZipViewModel.deleteShortcutInCuration(curationsIDs: shortcut.curationIDs, shortcutID: shortcut.id)
                            shortcutsZipViewModel.deleteData(model: shortcut)
                            //FIXME: 뷰모델에서 실제 데이터를 삭제하도록 변경 필요
                            shortcutsZipViewModel.shortcutsMadeByUser = shortcutsZipViewModel.shortcutsMadeByUser.filter { $0.id != shortcut.id }
                            self.presentation.wrappedValue.dismiss()
                        }
                    }
                  )
            )
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
            UIApplication.shared.windows.first?.rootViewController?.present(activityVC, animated: true, completion: nil)
        }
    }
}

//struct ReadShortcutView_Previews: PreviewProvider {
//    static var previews: some View {
//        ReadShortcutView()
//    }
//}

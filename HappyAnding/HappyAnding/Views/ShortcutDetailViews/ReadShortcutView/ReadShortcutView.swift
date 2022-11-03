//
//  ReadShortcutView.swift
//  HappyAnding
//
//  Created by 이지원 on 2022/10/19.
//

import SwiftUI

struct ReadShortcutView: View {
    
    @Environment(\.openURL) private var openURL
    @State var isMyShortcut: Bool = true
    @State var isEdit = false
    
    //TODO: id만 전달받기
    @State var shortcut: Shortcuts?
    var shortcutCell: ShortcutCellModel?
    let firebase = FirebaseService()
    
    var body: some View {
        
        VStack {
            
            if let shortcut {
                ReadShortcutHeaderView(shortcut: shortcut)
                ReadShortcutContentView(shortcut: shortcut)
                
                Button(action: {
                    if let url = URL(string: shortcut.downloadLink[0]) {
                        openURL(url)
                    }
                }) {
                    RoundedRectangle(cornerRadius: 12)
                        .foregroundColor(Color.Primary)
                        .frame(height: 52)
                        .padding(.horizontal, 16)
                        .overlay {
                            Text("다운로드 | \(Image(systemName: "arrow.down.app.fill")) \(shortcut.numberOfDownload)")
                                .Body1()
                                .foregroundColor(Color.Background)
                        }
                }
            }
        }
        .padding(.vertical, 20)
        .background(Color.Background)
        .onAppear() {
            if shortcut == nil {
                if let shortcutCell {
                    firebase.fetchShortcutDetail(id: shortcutCell.id) { data in
                        self.shortcut = data
                    }
                }
            }
        }
        .navigationBarTitleDisplayMode(NavigationBarItem.TitleDisplayMode.inline)
        .navigationBarItems(trailing: Menu(content: {
            if isMyShortcut {
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
            
            // TODO: 구현 필요
            /*
             Button(action: {
             //Place something action here
             }) {
             Label("삭제", systemImage: "trash.fill")
             .foregroundColor(Color.red)
             }
             */
        }
        
    }
    
    var otherShortcutMenuSection: some View {
        Section {
            Button(action: {
                share()
            }) {
                Label("공유", systemImage: "square.and.arrow.up")
            }
            Button(action: {
                //Place something action here
            }) {
                Label("신고", systemImage: "light.beacon.max.fill")
            }
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

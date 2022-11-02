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
    
    // TODO: 상위 뷰에서 유저데이터와 단축어데이터를 전달받은 변수 생성
    
    // shortcuts -> 추후 지워질 변수
//    var shortcuts = Shortcut.fetchData(number: 3)
    var shortcut: Shortcuts
    
    var body: some View {
        
//        let shortcut: Shortcut = shortcuts.first!
        
        VStack {

//            ReadShortcutHeaderView(icon: shortcut.sfSymbol, color: shortcut.color, numberOfLike: 99, name: shortcut.name, oneline: "한줄 설 명!")
            ReadShortcutHeaderView(shortcut: shortcut)
//            ReadShortcutContentView(writer: "romi", profileImage: "person.crop.circle", explain: shortcut.description, category: "여행", necessaryApps: "인스타그램", requirements: "불라불라")
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
        .padding(.vertical, 20)
        .background(Color.Background)
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
                WriteShortcutTitleView(isWriting: $isEdit, shortcut: shortcut, isEdit: true)
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
        guard let downloadLink = URL(string: shortcut.downloadLink.last!) else { return }
        let activityVC = UIActivityViewController(activityItems: [downloadLink], applicationActivities: nil)
        UIApplication.shared.windows.first?.rootViewController?.present(activityVC, animated: true, completion: nil)
    }
}

//struct ReadShortcutView_Previews: PreviewProvider {
//    static var previews: some View {
//        ReadShortcutView()
//    }
//}

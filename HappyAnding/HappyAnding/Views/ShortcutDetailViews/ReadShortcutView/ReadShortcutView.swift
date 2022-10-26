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
    
    // TODO: 상위 뷰에서 유저데이터와 단축어데이터를 전달받은 변수 생성
    // shortcuts -> 추후 지워질 변수
    var shortcuts = Shortcut.fetchData(number: 3)
    
    var body: some View {
        
        let shortcut: Shortcut = shortcuts.first!
        
        VStack {
            ReadShortcutHeaderView(icon: shortcut.sfSymbol, color: shortcut.color, name: shortcut.name, oneline: "한줄 설 명!", numberOfLike: 99)
            ReadShortcutContentView(writer: "romi", profileImage: "person.crop.circle", explain: shortcut.description, category: "여행", necessaryApps: "인스타그램", requirements: "불라불라")
            Button(action: {
                if let url = URL(string: shortcut.downloadLink) {
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
        
        // TODO: 테스트플라이트에서는 빠지는 내용이라 주석처리해둠
        /*
        .navigationBarItems(trailing: Menu(content: {
            if isMyShortcut {
                myShortcutMenuSection
            } else {
                otherShortcutMenuSection
            }
        }, label: {
            Image(systemName: "ellipsis")
        }))
         */
    }
}

extension ReadShortcutView {
    var myShortcutMenuSection: some View {
        Section {
            Button(action: {
                //Place something action here
            }) {
                Label("편집", systemImage: "square.and.pencil")
            }
            Button(action: {
                //Place something action here
            }) {
                Label("공유", systemImage: "square.and.arrow.up")
            }
            Button(action: {
                //Place something action here
            }) {
                Label("삭제", systemImage: "trash.fill")
                    .foregroundColor(Color.red)
            }
        }
    }
    
    var otherShortcutMenuSection: some View {
        Section {
            Button(action: {
                //Place something action here
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
}

struct ReadShortcutView_Previews: PreviewProvider {
    static var previews: some View {
        ReadShortcutView()
    }
}

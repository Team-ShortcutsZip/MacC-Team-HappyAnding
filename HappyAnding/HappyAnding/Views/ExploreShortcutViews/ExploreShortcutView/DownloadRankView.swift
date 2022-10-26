//
//  DownloadRankView.swift
//  HappyAnding
//
//  Created by KiWoong Hong on 2022/10/22.
//

import SwiftUI

struct DownloadRankView: View {
//    let shortcuts = Shortcut.fetchData(number: 5).sorted {
//        $0.numberOfDownload > $1.numberOfDownload
//    }
    
    let shortcuts: [Shortcuts]
    
    var body: some View {
        VStack {
            HStack {
                Text("다운로드 순위")
                    .Title2()
                    .foregroundColor(Color.Gray5)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Spacer()
                
                NavigationLink(destination: {
                    ListShortcutView(shortcuts: shortcuts, sectionType: SectionType.download)
                        .navigationBarTitleDisplayMode(NavigationBarItem.TitleDisplayMode.inline)
                }, label: {
                    Text("더보기")
                        .Footnote()
                        .foregroundColor(Color.Gray4)
                        .padding(.trailing, 16)
                })
            }
            .padding(.leading, 16)
            
            ForEach(Array(shortcuts.enumerated()), id:\.offset) { index, shortcut in
                if index < 3 {
                    NavigationLink(destination: ReadShortcutView(shortcut: shortcut), label: {
                        //TODO: 추후 downloadLink 배열로 전달하도록 변경 필요
//                        ShortcutCell(color: shortcut.color,
//                                     sfSymbol: shortcut.sfSymbol,
//                                     name: shortcut.title,
//                                     description: shortcut.description,
//                                     numberOfDownload: shortcut.numberOfDownload,
//                                     downloadLink: shortcut.downloadLink[0])
                        ShortcutCell(shortcut: shortcut)
                    })
                }
            }
        }
        .background(Color.Background)
    }
}

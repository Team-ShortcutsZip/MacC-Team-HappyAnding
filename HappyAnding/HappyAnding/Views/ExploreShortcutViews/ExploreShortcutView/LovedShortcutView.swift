//
//  LovedShortcutView.swift
//  HappyAnding
//
//  Created by KiWoong Hong on 2022/10/22.
//

import SwiftUI

struct LovedShortcutView: View {
    
    // TODO: 현재 더미 데이터 모델에 좋아요 수는 없어서 다운로드 수로 대체하였음
    //       추후 변경
    
//    let shortcuts = Shortcut.fetchData(number: 5).sorted {
//        $0.numberOfDownload > $1.numberOfDownload
//    }
    let shortcuts: [Shortcuts]?
    var body: some View {
        VStack {
            HStack {
                Text("사랑받는 단축어")
                    .Title2()
                    .foregroundColor(Color.Gray5)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Spacer()
                
                NavigationLink(destination: {
                    ListShortcutView(shortcuts: shortcuts, sectionType: SectionType.popular)
                        .navigationBarTitleDisplayMode(NavigationBarItem.TitleDisplayMode.inline)
                }, label: {
                    Text("더보기")
                        .Footnote()
                        .foregroundColor(Color.Gray4)
                        .padding(.trailing, 16)
                })
            }
            .padding(.leading, 16)
            
            if let shortcuts {
                ForEach(Array(shortcuts.enumerated()), id:\.offset) { index, shortcut in
                    if index < 3 {
                        NavigationLink(destination: ReadShortcutView(shortcut: shortcut), label: {
//                            ShortcutCell(color: shortcut.color,
//                                        sfSymbol: shortcut.sfSymbol,
//                                        name: shortcut.title,
//                                        description: shortcut.description,
//                                        numberOfDownload: shortcut.numberOfDownload,
//                                         downloadLink: shortcut.downloadLink[0])
                            ShortcutCell(shortcut: shortcut)
                        })
                    }
                }
            }
            
        }
        .background(Color.Background)
    }
}

//struct LovedShortcutView_Previews: PreviewProvider {
//    static var previews: some View {
//        LovedShortcutView()
//    }
//}

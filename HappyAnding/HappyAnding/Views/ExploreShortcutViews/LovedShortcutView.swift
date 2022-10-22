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
    
    let shortcuts = Shortcut.fetchData(number: 5).sorted {
        $0.numberOfDownload > $1.numberOfDownload
    }
    
    var body: some View {
        VStack {
            HStack {
                Text("사랑받는 단축어")
                    .Title2()
                    .foregroundColor(Color.Gray5)
                .frame(maxWidth: .infinity, alignment: .leading)
                
                Spacer()
                
                Text("더보기")
                    .Footnote()
                    .foregroundColor(Color.Gray4)
                    .padding(.trailing, 16)
            }
            .padding(.leading, 16)
            
            ForEach(Array(shortcuts.enumerated()), id:\.offset) { index, shortcut in
                if index < 3 {
                    ShortcutCell(color: shortcut.color, sfSymbol: shortcut.sfSymbol, name: shortcut.name, description: shortcut.description, numberOfDownload: shortcut.numberOfDownload, downloadLink: shortcut.downloadLink)
                }
            }
        }
        .background(Color.Background)
    }
}

struct LovedShortcutView_Previews: PreviewProvider {
    static var previews: some View {
        LovedShortcutView()
    }
}

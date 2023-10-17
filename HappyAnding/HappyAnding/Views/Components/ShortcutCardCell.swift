//
//  ShortcutCardCell.swift
//  HappyAnding
//
//  Created by HanGyeongjun on 2022/11/21.
//

import SwiftUI

struct ShortcutCardCell: View {
    
    let categoryShortcutIcon: String
    let categoryShortcutName: String
    let categoryShortcutColor: String
        
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Image(systemName: categoryShortcutIcon)
                .mediumShortcutIcon()
                .foregroundColor(Color.textIcon)
                .padding(.bottom, 4)
            Text(categoryShortcutName.lineBreaking)
                .multilineTextAlignment(.leading)
                .lineLimit(2)
                .shortcutsZipHeadline()
                .foregroundColor(Color.textIcon)
            Spacer()
        }
        .padding(.all, 12)
        .frame(width: 168, height: 112, alignment: .leading)
        .background(Color.fetchGradient(color: categoryShortcutColor))
        .cornerRadius(12)
    }
}

struct ShortcutCardCell_Previews: PreviewProvider {
    static var previews: some View {
        ShortcutCardCell(categoryShortcutIcon: "alarm.fill", categoryShortcutName: "클립보드의 마크다운 메모로 변환", categoryShortcutColor: "Coral")
    }
}

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
        VStack(alignment: .leading, spacing: 4) {
            Image(systemName: categoryShortcutIcon)
                .foregroundColor(Color.textIcon)
            Text(categoryShortcutName)
                .multilineTextAlignment(.leading)
                .lineLimit(2)
                .Headline()
                .foregroundColor(Color.textIcon)
            Spacer()
        }
        .padding(12)
        .frame(width: 168, height: 104, alignment: .leading)
        .background(Color.fetchGradient(color: categoryShortcutColor))
        .cornerRadius(12)
    }
}

struct ShortcutCardCell_Previews: PreviewProvider {
    static var previews: some View {
        ShortcutCardCell(categoryShortcutIcon: "alarm.fill", categoryShortcutName: "클립보드의 마크다운 메모로 변환", categoryShortcutColor: "Coral")
    }
}

//
//  ShortcutCardCell.swift
//  HappyAnding
//
//  Created by HanGyeongjun on 2022/11/21.
//

import SwiftUI

struct ShortcutCardCell: View {
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 12)
                .frame(width: 168, height: 104)
                .foregroundColor(Color.orange)  //단축어 색깔
            VStack(alignment: .leading) {
                Image(systemName: "alarm.fill")  //단축어 아이콘
                    .foregroundColor(.Text_icon)
                HStack {
                    Text("최근에 찍은 사진 업로드")  //단축어 제목
                        .multilineTextAlignment(.leading)
                        .lineLimit(2)
                        .Headline()
                        .foregroundColor(.Text_icon)
                    Spacer()
                }
            }
            .frame(width: 144)
        }
        .padding(.trailing, 12)
    }
}

struct ShortcutCardCell_Previews: PreviewProvider {
    static var previews: some View {
        ShortcutCardCell()
    }
}

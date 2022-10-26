//
//  ReadShortcutHeaderView.swift
//  HappyAnding
//
//  Created by KiWoong Hong on 2022/10/24.
//

import SwiftUI

struct ReadShortcutHeaderView: View {
    
    let shortcut: Shortcuts
//    let icon: String
//    let color: String
//    let numberOfLike: Int
//    let name: String
//    let oneline: String
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                VStack {
                    Image(systemName: shortcut.sfSymbol)
                        .Title2()
                        .foregroundColor(Color.White)
                }
                .frame(width: 52, height: 52)
                .background(Color.fetchGradient(color: shortcut.color))
                .cornerRadius(8)
                
                Spacer()
                
                Text("\(Image(systemName: "hand.thumbsup")) \(shortcut.numberOfLike)")
                .Body2()
                .padding(10)
                .foregroundColor(Color.Gray4)
                .background(Color.Gray1)
                .cornerRadius(12)
            }
            Text("\(shortcut.title)")
                .Title1()
                .foregroundColor(Color.Gray5)
            Text("\(shortcut.subtitle)")
                .Body1()
                .foregroundColor(Color.Gray3)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 16)
    }
}

//struct ReadShortcutHeaderView_Previews: PreviewProvider {
//    static var previews: some View {
//        ReadShortcutHeaderView(icon: "book", color: "Coral", numberOfLike: 99, name: "주변 커피집 걸어가기", oneline: "걸어가보자!!!")
//    }
//}

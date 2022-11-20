//
//  ReadShortcutHeaderView.swift
//  HappyAnding
//
//  Created by KiWoong Hong on 2022/10/24.
//

import SwiftUI

struct ReadShortcutHeaderView: View {
    
    @EnvironmentObject var shortcutsZipViewModel: ShortcutsZipViewModel
    
    @Binding var shortcut: Shortcuts
    @Binding var isMyLike: Bool
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                VStack {
                    Image(systemName: shortcut.sfSymbol)
                        .Title2()
                        .foregroundColor(Color.Text_icon)
                }
                .frame(width: 52, height: 52)
                .background(Color.fetchGradient(color: shortcut.color))
                .cornerRadius(8)
                
                Spacer()
                
                Text("\(isMyLike ? Image(systemName: "heart.fill") : Image(systemName: "heart")) \(shortcut.numberOfLike)")
                    .Body2()
                    .padding(10)
                    .foregroundColor(isMyLike ? Color.Text_icon : Color.Gray4)
                    .background(isMyLike ? Color.Primary : Color.Gray1)
                    .cornerRadius(12)
                    .onTapGesture(perform: {
                        isMyLike.toggle()
                        if isMyLike {
                            self.shortcut.numberOfLike += 1
                        } else {
                            self.shortcut.numberOfLike -= 1
                        }
                    })
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

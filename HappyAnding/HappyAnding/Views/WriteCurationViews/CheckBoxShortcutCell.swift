//
//  CheckBoxShortcutCell.swift
//  HappyAnding
//
//  Created by HanGyeongjun on 2022/10/26.
//

import SwiftUI

struct CheckBoxShortcutCell: View {
    
    @State var isShortcutTapped: Bool = false
    
    @Binding var selectedShortcut: [Shortcuts]
    
    let shortcut: Shortcuts
    
    var body: some View {
        
        ZStack {
            Color.Background
            
            HStack {
                toggle
                icon
                shortcutInfo
                Spacer()
            }
            .padding(.vertical, 20)
            .background( background )
            .padding(.horizontal, 16)
        }
        .onTapGesture {
            if isShortcutTapped {
                isShortcutTapped = false
                
                // TODO: 현재는 name을 기준으로 검색중, id로 검색해서 삭제해야함 / Shortcuts 자체를 배열에 저장해야함
                
                if let index = selectedShortcut.firstIndex(of: shortcut) {
                    selectedShortcut.remove(at: index)
                }
            }
            else {
                isShortcutTapped = true
                selectedShortcut.append(shortcut)
            }
        }
        .padding(.top, 0)
        .background(Color.Background)
    }
    
    var toggle: some View {
        Image(systemName: isShortcutTapped ? "checkmark.square.fill" : "square")
            .foregroundColor(isShortcutTapped ? .Primary : .Gray3)
            .padding(.leading, 20)
    }
    
    var icon: some View {
        
        ZStack(alignment: .center) {
            Rectangle()
                .fill(Color.fetchGradient(color: shortcut.color))
                .cornerRadius(8)
                .frame(width: 52, height: 52)
            
            Image(systemName: shortcut.sfSymbol)
                .foregroundColor(.white)
        }
        .padding(.leading, 12)
    }
    
    var shortcutInfo: some View {
        
        VStack(alignment: .leading, spacing: 4) {
            Text(shortcut.title)
                .Headline()
                .foregroundColor(.Gray5)
                .lineLimit(1)
            Text(shortcut.subtitle)
                .Footnote()
                .foregroundColor(.Gray3)
                .lineLimit(2)
        }
        .padding(.leading, 12)
        .padding(.trailing, 20)
    }
    
    var background: some View {
        
        RoundedRectangle(cornerRadius: 12)
            .fill(Color.White)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(isShortcutTapped ? Color.Primary : Color.Gray1)
            )
    }}

//struct CheckBoxShortcutCell_Previews: PreviewProvider {
//    static var previews: some View {
//        CheckBoxShortcutCell(color: "Blue", sfSymbol: "books.vertical.fill", name: "ShortcutsTitle", description: "DescriptionDescription")
//    }
//}

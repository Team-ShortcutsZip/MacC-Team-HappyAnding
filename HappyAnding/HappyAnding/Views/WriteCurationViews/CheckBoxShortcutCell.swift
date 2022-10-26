//
//  CheckBoxShortcutCell.swift
//  HappyAnding
//
//  Created by HanGyeongjun on 2022/10/26.
//

import SwiftUI

struct CheckBoxShortcutCell: View {
    
    @State var isShortcutTapped: Bool = false
    
    let color: String
    let sfSymbol: String
    let name: String
    let description: String
    
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
            }
            else {
                isShortcutTapped = true
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
                .fill(Color.fetchGradient(color: color))
                .cornerRadius(8)
                .frame(width: 52, height: 52)
            
            Image(systemName: sfSymbol)
                .foregroundColor(.white)
        }
        .padding(.leading, 12)
    }
    
    var shortcutInfo: some View {
        
        VStack(alignment: .leading, spacing: 4) {
            Text(name)
                .Headline()
                .foregroundColor(.Gray5)
                .lineLimit(1)
            Text(description)
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

struct CheckBoxShortcutCell_Previews: PreviewProvider {
    static var previews: some View {
        CheckBoxShortcutCell(color: "Blue", sfSymbol: "books.vertical.fill", name: "ShortcutsTitle", description: "DescriptionDescription")
    }
}

//
//  CheckBoxShortcutCell.swift
//  HappyAnding
//
//  Created by HanGyeongjun on 2022/10/26.
//

import SwiftUI

struct CheckBoxShortcutCell: View {
    
    @Binding var selectedShortcutCells: [ShortcutCellModel]
    
    @State var isShortcutTapped: Bool = false
    
    let shortcutCell: ShortcutCellModel
    
    var body: some View {
        
        ZStack {
            Color.shortcutsZipBackground
            
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
                
                if let index = selectedShortcutCells.firstIndex(of: shortcutCell) {
                    selectedShortcutCells.remove(at: index)
                }
            }
            else {
                if selectedShortcutCells.count < 10 {
                    isShortcutTapped = true
                    selectedShortcutCells.append(shortcutCell)
                }
            }
        }
        .padding(.top, 0)
        .background(Color.shortcutsZipBackground)
    }
    
    var toggle: some View {
        Image(systemName: isShortcutTapped ? "checkmark.square.fill" : "square")
            .smallIcon()
            .foregroundStyle(isShortcutTapped ? Color.shortcutsZipPrimary : Color.gray3)
            .padding(.leading, 20)
    }
    
    var icon: some View {
        
        ZStack(alignment: .center) {
            Rectangle()
                .fill(Color.fetchGradient(color: shortcutCell.color))
                .cornerRadius(8)
                .frame(width: 52, height: 52)
            
            Image(systemName: shortcutCell.sfSymbol)
                .mediumShortcutIcon()
                .foregroundStyle(Color.white)
        }
        .padding(.leading, 12)
    }
    
    var shortcutInfo: some View {
        
        VStack(alignment: .leading, spacing: 4) {
            Text(shortcutCell.title)
                .shortcutsZipHeadline()
                .foregroundStyle(Color.gray5)
                .lineLimit(1)
            Text(shortcutCell.subtitle)
                .shortcutsZipFootnote()
                .foregroundStyle(Color.gray3)
                .lineLimit(2)
        }
        .padding(.leading, 12)
        .padding(.trailing, 20)
    }
    
    var background: some View {
        
        RoundedRectangle(cornerRadius: 12)
            .fill(isShortcutTapped ? Color.shortcutsZipWhite : Color.backgroudList)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .strokeBorder(isShortcutTapped ? Color.shortcutsZipPrimary : Color.backgroudListBorder)
            )
    }}

//struct CheckBoxShortcutCell_Previews: PreviewProvider {
//    static var previews: some View {
//        CheckBoxShortcutCell(color: "Blue", sfSymbol: "books.vertical.fill", name: "ShortcutsTitle", description: "DescriptionDescription")
//    }
//}

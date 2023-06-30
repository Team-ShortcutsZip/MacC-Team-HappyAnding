//
//  CheckBoxShortcutCell.swift
//  HappyAnding
//
//  Created by HanGyeongjun on 2022/10/26.
//

import SwiftUI

struct CheckBoxShortcutCell: View {
    
    @StateObject var viewModel: WriteCurationViewModel

    let idx: Int
    
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
            viewModel.checkboxCellTapGesture(idx: idx)
        }
        .padding(.top, 0)
        .background(Color.shortcutsZipBackground)
    }
    
    var toggle: some View {
        Image(systemName: viewModel.isShortcutsTapped[idx] ? "checkmark.square.fill" : "square")
            .smallIcon()
            .foregroundColor(viewModel.isShortcutsTapped[idx] ? .shortcutsZipPrimary : .gray3)
            .padding(.leading, 20)
    }
    
    var icon: some View {
        
        ZStack(alignment: .center) {
            Rectangle()
                .fill(Color.fetchGradient(color: viewModel.shortcutCells[idx].color))
                .cornerRadius(8)
                .frame(width: 52, height: 52)
            
            Image(systemName: viewModel.shortcutCells[idx].sfSymbol)
                .mediumShortcutIcon()
                .foregroundColor(.white)
        }
        .padding(.leading, 12)
    }
    
    var shortcutInfo: some View {
        
        VStack(alignment: .leading, spacing: 4) {
            Text(viewModel.shortcutCells[idx].title)
                .shortcutsZipHeadline()
                .foregroundColor(.gray5)
                .lineLimit(1)
            Text(viewModel.shortcutCells[idx].subtitle)
                .shortcutsZipFootnote()
                .foregroundColor(.gray3)
                .lineLimit(2)
        }
        .padding(.leading, 12)
        .padding(.trailing, 20)
    }
    
    var background: some View {
        
        RoundedRectangle(cornerRadius: 12)
            .fill(viewModel.isShortcutsTapped[idx] ? Color.shortcutsZipWhite : Color.backgroudList)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .strokeBorder(viewModel.isShortcutsTapped[idx] ? Color.shortcutsZipPrimary : Color.backgroudListBorder)
            )
    }
}

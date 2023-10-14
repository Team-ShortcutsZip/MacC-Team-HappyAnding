//
//  AnnouncementCell.swift
//  HappyAnding
//
//  Created by HanGyeongjun on 2023/03/01.
//

import SwiftUI

struct AnnouncementCell: View {
    
    var icon: String
    var tagName: String
    var discription: String
    
    @Binding var isAnnouncementShow: Bool
    
    var body: some View {
        ZStack {
            HStack(spacing: 12) {
                
                Image(icon)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 52, height: 52)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(tagName)
                        .shortcutsZipFootnote()
                        .fontWeight(.bold)
                        .foregroundStyle(Color.tagText)
                        .frame(height: 20)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 2)
                        .background(
                            Capsule()
                                .fill( Color.tagBackground )
                                .overlay(
                                    Capsule()
                                        .strokeBorder(Color.shortcutsZipPrimary, lineWidth: 1))
                        )
                    Text(discription)
                        .shortcutsZipBody2()
                        .fontWeight(.semibold)
                        .foregroundStyle(Color.gray5)
                        .lineLimit(1)
                }
                
                Spacer()
                
                Button {
                    isAnnouncementShow = false
                } label: {
                    Image(systemName: "xmark")
                        .shortcutsZipBody1()
                        .foregroundStyle(Color.gray4)
                        .frame(width: 24, height: 24)
                }
            }
            .padding(.all, 20)
            .background( background )
        }
        .padding(.horizontal, 16)
    }
    
    var background: some View {
        RoundedRectangle(cornerRadius: 12)
            .fill(Color.backgroudList)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .strokeBorder(Color.backgroudListBorder)
            )
    }
}

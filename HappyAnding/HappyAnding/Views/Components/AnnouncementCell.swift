//
//  AnnouncementCell.swift
//  HappyAnding
//
//  Created by HanGyeongjun on 2023/03/01.
//

import SwiftUI

struct AnnouncementCell: View {
    
    @Binding var isAnnouncementShow: Bool
    
    var icon: String?
    var tagName: String?
    //    var tagColor: UIColor?
    var title: String
    var description: String?
    var isCanDismiss: Bool
    
    var body: some View {
        ZStack {
            HStack(spacing: 12) {
                
                if let icon {
                    Image(icon)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 60, height: 60)
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    if let tagName {
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
                    }
                    
                    Text(title)
                        .shortcutsZipBody2()
                        .fontWeight(.semibold)
                        .foregroundStyle(Color.gray5)
                        .lineLimit(1)
                    
                    if let description {
                        Text(description.lineBreaking)
                            .shortcutsZipFootnote()
                            .fontWeight(.semibold)
                            .foregroundStyle(Color.gray3)
                            .multilineTextAlignment(.leading)
                            .lineLimit(2)
                    }
                }
                
                Spacer()
                if isCanDismiss {
                    Button {
                        isAnnouncementShow = false
                    } label: {
                        Image(systemName: "xmark")
                            .shortcutsZipBody1()
                            .foregroundStyle(Color.gray4)
                            .frame(width: 24, height: 24)
                    }
                }
            }
            .padding(.all, 16)
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

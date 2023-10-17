//
//  SubtitleTextView.swift
//  HappyAnding
//
//  Created by 전지민 on 2023/01/25.
//

import SwiftUI

struct SubtitleTextView: View {
    
    var text: String
    
    var body: some View {
        Text(text)
            .shortcutsZipTitle2()
            .foregroundStyle(Color.gray5)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
}

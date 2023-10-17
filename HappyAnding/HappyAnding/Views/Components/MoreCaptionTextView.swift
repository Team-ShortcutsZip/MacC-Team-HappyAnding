//
//  MoreCaptionTextView.swift
//  HappyAnding
//
//  Created by 전지민 on 2023/02/12.
//

import SwiftUI

struct MoreCaptionTextView: View {
    
    var text: String
    
    var body: some View {
        Text(text)
            .shortcutsZipFootnote()
            .foregroundStyle(Color.gray4)
    }
}

//
//  ReadShortcutContentView.swift
//  HappyAnding
//
//  Created by KiWoong Hong on 2022/10/24.
//

import SwiftUI

struct ReadShortcutContentView: View {
    let writer: String
    let profileImage: String
    let explain: String
    let category: String
    let necessaryApps: String
    let requirements: String
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                Text("작성자")
                    .Body2()
                    .foregroundColor(Color.Gray4)
                HStack {
                    Image(systemName: profileImage)
                    Text(writer)
                }
                
                ReusableTextView(title: "단축어 설명", contents: explain)
                    .padding(.bottom, 20)
                ReusableTextView(title: "카테고리", contents: category)
                    .padding(.bottom, 20)
                ReusableTextView(title: "단축어 사용에 필요한 앱", contents: necessaryApps)
                    .padding(.bottom, 20)
                ReusableTextView(title: "단축어 사용을 위한 요구사항", contents: requirements)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(20)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .overlay {
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.Gray2,lineWidth: 1)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 20)
    }
}

private struct ReusableTextView: View {
    
    let title: String
    let contents: String
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .Body2()
                .foregroundColor(Color.Gray4)
            Text(contents)
                .Body2()
                .foregroundColor(Color.Gray5)
        }
    }
}

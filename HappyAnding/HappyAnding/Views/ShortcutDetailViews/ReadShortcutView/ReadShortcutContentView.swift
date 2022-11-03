//
//  ReadShortcutContentView.swift
//  HappyAnding
//
//  Created by KiWoong Hong on 2022/10/24.
//

import SwiftUI

struct ReadShortcutContentView: View {
    let firebase = FirebaseService()
    @State var userInformation: User? = nil
    
    let shortcut: Shortcuts
//    let writer: String
    let profileImage: String = "person.crop.circle"
//    let explain: String
//    let category: String
//    let necessaryApps: String
//    let requirements: String
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                Text("작성자")
                    .Body2()
                    .foregroundColor(Color.Gray4)
                HStack {
                    Image(systemName: profileImage)
                    Text(userInformation?.nickname ?? "닉네임")
                        .Body2()
                        .foregroundColor(Color.Gray5)
                }
                .padding(.bottom, 24)
                
                ReusableTextView(title: "단축어 설명", contents: shortcut.description, contentsArray: nil)
                    .padding(.bottom, 20)
                categoryView
                    .padding(.bottom, 20)
                
                if !shortcut.requiredApp.isEmpty {
                    ReusableTextView(title: "단축어 사용에 필요한 앱", contents: nil, contentsArray: shortcut.requiredApp)
                        .padding(.bottom, 20)
                }
                if !shortcut.shortcutRequirements.isEmpty {
                    ReusableTextView(title: "단축어 사용을 위한 요구사항", contents: shortcut.shortcutRequirements, contentsArray: nil)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(20)
        }
        .onAppear {
            firebase.fetchUser(userID: shortcut.author) { user in
                userInformation = user
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .overlay {
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.Gray2,lineWidth: 1)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 20)
        .scrollIndicators(.hidden)
    }
    
    var categoryView: some View {
        VStack(alignment: .leading) {
            Text("카테고리")
                .Body2()
                .foregroundColor(.Gray4)
            
            HStack(spacing: 8) {
                ForEach(shortcut.category, id: \.self) { categoryName in
                    Text(translateName(categoryName))
                        .Body2()
                        .foregroundColor(.Gray5)
                }
            }
        }
    }
    private func translateName(_ categoryName: String) -> String {
        switch categoryName {
        case "education":
            return "교육"
        case "finance":
            return "금융"
        case "business":
            return "비즈니스"
        case "health":
            return "건강 및 피트니스"
        case "lifestyle":
            return "라이프스타일"
        case "weather":
            return "날씨"
        case "photo":
            return "사진 및 비디오"
        case "decoration":
            return "데코레이션/꾸미기"
        case "utility":
            return "유틸리티"
        case "sns":
            return "소셜 네트워킹"
        case "entertainment":
            return "엔터테인먼트"
        case "trip":
            return "여행"
        default:
            return ""
        }
    }
}

private struct ReusableTextView: View {
    
    let title: String
    let contents: String?
    let contentsArray: [String]?
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .Body2()
                .foregroundColor(Color.Gray4)
            if let contents {
                Text(contents)
                    .Body2()
                    .foregroundColor(Color.Gray5)
            }
            if let contentsArray {
                ForEach(contentsArray, id: \.self) {
                    content in
                    Text(content)
                        .Body2()
                        .foregroundColor(Color.Gray5)
                }
            }
        }
    }
}


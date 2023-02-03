//
//  ReadShortcutContentView.swift
//  HappyAnding
//
//  Created by KiWoong Hong on 2022/10/24.
//

import SwiftUI

struct ReadShortcutContentView: View {
    @EnvironmentObject var shortcutsZipViewModel: ShortcutsZipViewModel
    
    @Binding var shortcut: Shortcuts
    
    let profileImage: String = "person.crop.circle"
    
    var body: some View {
            VStack(alignment: .leading, spacing: 24) {
                
                ReusableTextView(title: "단축어 설명", contents: shortcut.description, contentsArray: nil)
                
                categoryView
                
                if !shortcut.requiredApp.isEmpty {
                    ReusableTextView(title: "단축어 사용에 필요한 앱", contents: nil, contentsArray: shortcut.requiredApp)
                }
                
                if !shortcut.shortcutRequirements.isEmpty {
                    ReusableTextView(title: "단축어 사용을 위한 요구사항", contents: shortcut.shortcutRequirements, contentsArray: nil)
                }
                Spacer()
                    .frame(maxHeight: .infinity)
            }
            .padding(.top, 16)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    var categoryView: some View {
        VStack(alignment: .leading) {
            Text("카테고리")
                .Body2()
                .foregroundColor(.Gray4)
            
            HStack(spacing: 8) {
                ForEach(shortcut.category, id: \.self) { categoryName in
                    Text(Category(rawValue: categoryName)!.translateName())
                        .Body2()
                        .foregroundColor(.Gray5)
                }
            }
        }
    }
}

private struct ReusableTextView: View {
    
    let title: String
    let contents: String?
    let contentsArray: [String]?
    
    @State var heigth: CGFloat = 10000
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .Body2()
                .foregroundColor(Color.Gray4)
            if let contents {
                Text(contents)
                    .Body2()
                    .foregroundColor(Color.Gray5)
                    .lineLimit(nil)
            }
            if let contentsArray {
                ForEach(contentsArray, id: \.self) {
                    content in
                    Text(content)
                        .Body2()
                        .foregroundColor(Color.Gray5)
                        .lineLimit(nil)
                }
            }
        }
        .background(
            GeometryReader { geometryProxy in
                Color.clear
                    .preference(key: SizePreferenceKey.self,
                                value: geometryProxy.size)
            })
        .onPreferenceChange(SizePreferenceKey.self) { newSize in
            self.heigth = newSize.height
        }
        .frame(height: self.heigth)
    }
}


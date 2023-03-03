//
//  ReadShortcutContentView.swift
//  HappyAnding
//
//  Created by KiWoong Hong on 2022/10/24.
//

import SwiftUI
import WrappingHStack

struct ReadShortcutContentView: View {
    @EnvironmentObject var shortcutsZipViewModel: ShortcutsZipViewModel
    
    @Binding var shortcut: Shortcuts
    
    let profileImage: String = "person.crop.circle"
    
    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            ReusableTextView(title: TextLiteral.readShortcutContentViewDescription, contents: shortcut.description, contentsArray: nil)
            
            SplitList(title: TextLiteral.readShortcutContentViewCategory, content: shortcut.category)
            
            if !shortcut.requiredApp.isEmpty {
                SplitList(title: TextLiteral.readShortcutContentViewRequiredApps, content: shortcut.requiredApp)
            }
            
            if !shortcut.shortcutRequirements.isEmpty {
                ReusableTextView(title: TextLiteral.readShortcutContentViewRequirements, contents: shortcut.shortcutRequirements, contentsArray: nil)
            }
            
            Spacer()
                .frame(maxHeight: .infinity)
        }
        .padding(.top, 16)
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private struct SplitList: View {
        let title: String
        let content: [String]
        
        var body: some View {
            VStack(alignment: .leading) {
                Text(title)
                    .Body2()
                    .foregroundColor(Color.gray4)
                
                WrappingHStack(content, id: \.self, alignment: .leading, spacing: .constant(8), lineSpacing: 8) { item in
                    if Category.allCases.contains(where: { $0.rawValue == item }) {
                        Text(Category(rawValue: item)?.translateName() ?? "")
                            .Body2()
                            .padding(.trailing, 8)
                            .foregroundColor(Color.gray5)
                    } else {
                        Text(item)
                            .Body2()
                            .padding(.trailing, 8)
                            .foregroundColor(Color.gray5)
                    }
                    if item != content.last {
                        Divider()
                    }
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
                .foregroundColor(Color.gray4)
            if let contents {
                Text(contents)
                    .Body2()
                    .foregroundColor(Color.gray5)
                    .lineLimit(nil)
            }
            if let contentsArray {
                ForEach(contentsArray, id: \.self) {
                    content in
                    Text(content)
                        .Body2()
                        .foregroundColor(Color.gray5)
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

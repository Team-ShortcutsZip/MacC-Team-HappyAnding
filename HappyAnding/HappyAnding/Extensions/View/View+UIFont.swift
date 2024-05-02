//
//  View+Font.swift
//  HappyAnding
//
//  Created by 이지원 on 2023/02/24.
//
import SwiftUI


// MARK: - extension
/**
 Font 적용을 위한 확장입니다.
 
 - description:
    - Text 또는 Image에서 사용할 수 있습니다.
 
 # code:
 
    Text("Hello World")
        .LargeTitle()
 
 */
extension View {
    func shortcutsZipLargeTitle() -> some View {
        ModifiedContent(content: self, modifier: FontWithLineHeight(font: .shortcutsZipLargeTitle, lineHeight: 38))
    }
    func shortcutsZipTitle1() -> some View {
        ModifiedContent(content: self, modifier: FontWithLineHeight(font: .shortcutsZipTitle1, lineHeight: 32))
    }
    func shortcutsZipTitle2() -> some View {
        ModifiedContent(content: self, modifier: FontWithLineHeight(font: .shortcutsZipTitle2, lineHeight: 28))
    }
    func shortcutsZipHeadline() -> some View {
        ModifiedContent(content: self, modifier: FontWithLineHeight(font: .shortcutsZipHeadline, lineHeight: 22))
    }
    func shortcutsZipBody1() -> some View {
        ModifiedContent(content: self, modifier: FontWithLineHeight(font: .shortcutsZipBody1, lineHeight: 22))
    }
    func shortcutsZipBody2() -> some View {
        ModifiedContent(content: self, modifier: FontWithLineHeight(font: .shortcutsZipBody2, lineHeight: 20))
    }
    func shortcutsZipSubtitle() -> some View {
        ModifiedContent(content: self, modifier: FontWithLineHeight(font: .shortcutsZipSubtitle, lineHeight: 20))
    }
    func shortcutsZipFootnote() -> some View {
        ModifiedContent(content: self, modifier: FontWithLineHeight(font: .shortcutsZipFootnote, lineHeight: 18))
    }
    func shortcutsZipSb() -> some View {
        ModifiedContent(content: self, modifier: FontWithLineHeight(font: .shortcutsZipSb, lineHeight: 20))
    }
    
    func mediumIcon() -> some View {
        ModifiedContent(content: self, modifier: FontWithLineHeight(font: .mediumIcon, lineHeight: 24))
    }
    func smallIcon() -> some View {
        ModifiedContent(content: self, modifier: FontWithLineHeight(font: .smallIcon, lineHeight: 16))
    }
    func largeShortcutIcon() -> some View {
        ModifiedContent(content: self, modifier: FontWithLineHeight(font: .largeShortcutIcon, lineHeight: 36))
    }
    func mediumShortcutIcon() -> some View {
        ModifiedContent(content: self, modifier: FontWithLineHeight(font: .mediumShortcutIcon, lineHeight: 30))
    }
    func smallShortcutIcon() -> some View {
        ModifiedContent(content: self, modifier: FontWithLineHeight(font: .smallShortcutIcon, lineHeight: 20))
    }
    func regular16() -> some View {
        ModifiedContent(content: self, modifier: FontWithLineHeight(font: UIFont(name: Pretendard.regular.rawValue, size: 16) ?? UIFont.systemFont(ofSize: 16), lineHeight: 24))
    }
    func  medium16() -> some View {
        ModifiedContent(content: self, modifier: FontWithLineHeight(font: UIFont(name: Pretendard.medium.rawValue, size: 16) ?? UIFont.systemFont(ofSize: 16), lineHeight: 24))
    }
    func medium17() -> some View {
        ModifiedContent(content: self, modifier: FontWithLineHeight(font: UIFont(name: Pretendard.medium.rawValue, size: 17) ?? UIFont.systemFont(ofSize: 17), lineHeight: 24))
    }
    func semiBold17() -> some View {
        ModifiedContent(content: self, modifier: FontWithLineHeight(font: UIFont(name: Pretendard.semiBold.rawValue, size: 17) ?? UIFont.systemFont(ofSize: 17), lineHeight: 24))
    }
    func numRegular16() -> some View {
        ModifiedContent(content: self, modifier: FontWithLineHeight(font: UIFont(name: SFCompactRounded.regular.rawValue, size: 16) ?? UIFont.systemFont(ofSize: 16), lineHeight: 24))
    }
    
    func descriptionReadable() -> some View {
        ModifiedContent(content: self, modifier: FontWithLineHeight(font: UIFont(name: Pretendard.regular.rawValue, size: 16) ?? UIFont.systemFont(ofSize: 16), lineHeight: 24))
    }
}

// MARK: - View Modifier
/**
 자간을 위한 View Modifier입니다.
 - remark:
    [출처](https://stackoverflow.com/questions/61705184/how-to-set-line-height-for-a-single-line-text-in-swiftui)
 */
struct FontWithLineHeight: ViewModifier {
    let font: UIFont
    let lineHeight: CGFloat

    func body(content: Content) -> some View {
        content
            .font(Font(font))
            .lineSpacing(lineHeight - font.lineHeight)
            .padding(.vertical, (lineHeight - font.lineHeight) / 2)
    }
}


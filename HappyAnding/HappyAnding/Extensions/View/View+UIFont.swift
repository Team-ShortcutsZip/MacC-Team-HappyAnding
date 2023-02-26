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
    func LargeTitle() -> some View {
        ModifiedContent(content: self, modifier: FontWithLineHeight(font: .LargeTitle, lineHeight: 38))
    }
    func Title1() -> some View {
        ModifiedContent(content: self, modifier: FontWithLineHeight(font: .Title1, lineHeight: 32))
    }
    func Title2() -> some View {
        ModifiedContent(content: self, modifier: FontWithLineHeight(font: .Title2, lineHeight: 28))
    }
    func Headline() -> some View {
        ModifiedContent(content: self, modifier: FontWithLineHeight(font: .Headline, lineHeight: 22))
    }
    func Body1() -> some View {
        ModifiedContent(content: self, modifier: FontWithLineHeight(font: .Body1, lineHeight: 22))
    }
    func Body2() -> some View {
        ModifiedContent(content: self, modifier: FontWithLineHeight(font: .Body2, lineHeight: 20))
    }
    func Subtitle() -> some View {
        ModifiedContent(content: self, modifier: FontWithLineHeight(font: .Subtitle, lineHeight: 20))
    }
    func Footnote() -> some View {
        ModifiedContent(content: self, modifier: FontWithLineHeight(font: .Footnote, lineHeight: 18))
    }
    func Sb() -> some View {
        ModifiedContent(content: self, modifier: FontWithLineHeight(font: .Sb, lineHeight: 20))
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


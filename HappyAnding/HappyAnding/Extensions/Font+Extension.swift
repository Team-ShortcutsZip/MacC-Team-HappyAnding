//
//  Font+Extension.swift
//  HappyAnding
//
//  Created by 전지민 on 2022/10/21.
//

import SwiftUI

extension UIFont {
    static var LargeTitle = UIFont.systemFont(ofSize: 26, weight: .bold)
    static var Title1 = UIFont.systemFont(ofSize: 22, weight: .semibold)
    static var Title2 = UIFont.systemFont(ofSize: 20, weight: .medium)
    static var Headline = UIFont.systemFont(ofSize: 17, weight: .medium)
    static var Body1 = UIFont.systemFont(ofSize: 17, weight: .regular)
    static var Body2 = UIFont.systemFont(ofSize: 15, weight: .regular)
    static var Subtitle = UIFont.systemFont(ofSize: 15, weight: .bold)
    static var Footnote = UIFont.systemFont(ofSize: 13, weight: .regular)
}

//출처: https://stackoverflow.com/questions/61705184/how-to-set-line-height-for-a-single-line-text-in-swiftui
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

extension View {
    //크기를 적용할 Text에 Text().LargeTitle()과 같은 형식으로 사용해주세요
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
        ModifiedContent(content: self, modifier: FontWithLineHeight(font: .Body2, lineHeight: 22))
    }
    func Subtitle() -> some View {
        ModifiedContent(content: self, modifier: FontWithLineHeight(font: .Subtitle, lineHeight: 20))
    }
    func Footnote() -> some View {
        ModifiedContent(content: self, modifier: FontWithLineHeight(font: .Footnote, lineHeight: 18))
    }
}

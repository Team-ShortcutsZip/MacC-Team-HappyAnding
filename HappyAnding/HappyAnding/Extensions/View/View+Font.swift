//
//  View+Font.swift
//  HappyAnding
//
//  Created by HanGyeongjun on 4/13/24.
//

import SwiftUI

///Pretendard 폰트를 관리하는 열거형
///현재 regular, medium, semibold, bold 4가지 폰트가 .otf 확장자로 추가되어있음
///파일의 위치는 Resources.Pretendard
///파일 추가를 위해서는 Info.plist의 Fonts provided by application추가 필요
enum Pretendard: String {
    case regular = "Pretendard-Regular"
    case medium = "Pretendard-Medium"
    case semiBold = "Pretendard-SemiBold"
    case bold = "Pretendard-Bold"
}

///Pretendard 폰트를 기존 modifier와 같이 사용할 수 있게 해 주는 Extension
///사용 예시
///Text("단축어").largeTitle()
///Text("단축어").customPretendard(fontName: Pretendard.bold, size: 16)
extension View {
    
    func largeTitle() -> some View {
        self.modifier(CustomFontStyle(fontName: Pretendard.bold.rawValue, size: 24))
    }

    func title1() -> some View {
        self.modifier(CustomFontStyle(fontName: Pretendard.bold.rawValue, size: 20))
    }

    func subTitle1() -> some View {
        self.modifier(CustomFontStyle(fontName: Pretendard.semiBold.rawValue, size: 16))
    }

    func subTitle2() -> some View {
        self.modifier(CustomFontStyle(fontName: Pretendard.bold.rawValue, size: 15))
    }

    func body1() -> some View {
        self.modifier(CustomFontStyle(fontName: Pretendard.medium.rawValue, size: 14))
    }

    func body2() -> some View {
        self.modifier(CustomFontStyle(fontName: Pretendard.medium.rawValue, size: 12))
    }

    func subText1() -> some View {
        self.modifier(CustomFontStyle(fontName: Pretendard.regular.rawValue, size: 10))
    }
    
    func customPretendard(fontName: Pretendard, size: CGFloat) -> some View {
        self.modifier(CustomFontStyle(fontName: fontName.rawValue, size: size))
    }
}

struct CustomFontStyle: ViewModifier {
    var fontName: String
    var size: CGFloat

    func body(content: Content) -> some View {
        content.font(.custom(fontName, size: size))
    }
}

//
//  Color+Extension.swift
//  HappyAnding
//
//  Created by 이지원 on 2022/10/20.
//

import SwiftUI

extension String {
    
    func converToColor() -> Color {
        Color(self)
    }
}

extension UIColor {
  convenience init(light: UIColor, dark: UIColor) {
    self.init { traitCollection in
      switch traitCollection.userInterfaceStyle {
      case .light, .unspecified:
        return light
      case .dark:
        return dark
      @unknown default:
        return light
      }
    }
  }
}

extension Color {
  init(light: Color, dark: Color) {
    self.init(UIColor(light: UIColor(light), dark: UIColor(dark)))
  }
}

extension Color {
    // Semantic Color
  static let Background_plus = Color(light: .Gray1, dark: .Primary)
    static let Background_tabbar = Color(light: .White, dark: .Gray3)
    
    static let Text_curation = Color(light: .Gray5, dark: .Background)
    static let Text_icon = Color(light: .White, dark: .Gray6)
    
    static let Text_Button = Color(light: .Background, dark: .Gray6)
    static let Text_Button_Disable = Color(light: .Gray3, dark: .Gray2)
}

extension Color {
    ///System Colors
    static let Background = Color("Grey020")
    static let White = Color("Grey010")
    static let Primary = Color("Primary")
    static let Error = Color("Error")
    static let Danger = Color("Danger")
    static let Success = Color("Success")
    
    ///Text Colors
    static let Gray1 = Color("Grey030")
    static let Gray2 = Color("Grey040")
    static let Gray3 = Color("Grey050")
    static let Gray4 = Color("Grey060")
    static let Gray5 = Color("Grey070")
    static let Gray6 = Color("Grey080")
    
    //gradient사용하는 곳에서 Color.fetchGradient(color: "Red")와 같이 사용해주세요
    //컬러명은 숫자를 제외하고 UpperCamelCase로 입력해주세요
    static func fetchGradient(color: String) -> LinearGradient {
        let colors = [Color("\(color)01"), Color("\(color)02")]
        return LinearGradient(colors: colors, startPoint: .topLeading, endPoint: .bottomTrailing)
        
    }
}

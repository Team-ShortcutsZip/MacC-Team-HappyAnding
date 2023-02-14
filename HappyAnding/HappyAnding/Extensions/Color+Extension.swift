//
//  Color+Extension.swift
//  HappyAnding
//
//  Created by 이지원 on 2022/10/20.
//

import SwiftUI
import UIKit

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
    static let backgroundPlus = Color(light: .gray1, dark: .shortcutsZipWhite)
    static let backgroundTabbar = Color(light: .shortcutsZipWhite, dark: Color("Grey005"))
    static let backgroudList = Color(light: .shortcutsZipWhite, dark: .shortcutsZipBackground)
    static let backgroudListBorder = Color(light: .gray1, dark: .shortcutsZipWhite)
    
    static let textCuration = Color(light: .gray5, dark: .shortcutsZipBackground)
    static let textIcon = Color(light: .shortcutsZipWhite, dark: .gray6)
    
    static let textButton = Color(light: .shortcutsZipBackground, dark: .gray6)
    static let textButtonDisable = Color(light: .shortcutsZipWhite .opacity(0.8), dark: .gray2.opacity(0.8))
    
    static let categoryPickFill = Color(light: .shortcutsZipWhite, dark: .shortcutsZipPrimary)
    static let categoryPickText = Color(light: .shortcutsZipPrimary, dark: .gray6)
    
    static let tagPickBackground = Color(light: Color.clear, dark: .shortcutsZipPrimary)
    static let tagBackground = Color(light: .shortcutsZipBackground, dark: .shortcutsZipPrimary)
    static let tagText = Color(light: .shortcutsZipPrimary, dark: .white)
}

extension Color {
    ///System Colors
    static let shortcutsZipBackground = Color("Grey020")
    static let shortcutsZipWhite = Color("Grey010")
    static let shortcutsZipPrimary = Color("Primary")
    static let shortcutsZipError = Color("Error")
    static let shortcutsZipDanger = Color("Danger")
    static let shortcutsZipSuccess = Color("Success")
    
    ///Text Colors
    static let gray1 = Color("Grey030")
    static let gray2 = Color("Grey040")
    static let gray3 = Color("Grey050")
    static let gray4 = Color("Grey060")
    static let gray5 = Color("Grey070")
    static let gray6 = Color("Grey080")
    
    //gradient사용하는 곳에서 Color.fetchGradient(color: "Red")와 같이 사용해주세요
    //컬러명은 숫자를 제외하고 UpperCamelCase로 입력해주세요
    static func fetchGradient(color: String) -> LinearGradient {
        let colors = [Color("\(color)01"), Color("\(color)02")]
        return LinearGradient(colors: colors, startPoint: .topLeading, endPoint: .bottomTrailing)
        
    }
    static func fetchDefualtGradient() -> LinearGradient {
        LinearGradient(colors: [Color.gray1], startPoint: .topLeading, endPoint: .bottomTrailing)
    }
}

extension UIColor {
    static var gray4: UIColor {
        guard let color = UIColor(named: "Grey060") else { return .label }
        return color
    }
    static var gray5: UIColor {
        guard let color = UIColor(named: "Grey070") else { return .label }
        return color
    }
    static var shortcutsZipBackground: UIColor {
        guard let color = UIColor(named: "Grey020") else { return .label }
        return color
    }
    static var shortcutsZipPrimary: UIColor {
        guard let color = UIColor(named: "Primary") else { return .label }
        return color
    }
    static var shortcutsZipPrimaryOpacity: UIColor {
        guard let color = UIColor(named: "Primary") else { return .label }
        return color.withAlphaComponent(0.3)
    }
}

//
//  Color+Extension.swift
//  HappyAnding
//
//  Created by 이지원 on 2022/10/20.
//

import SwiftUI

extension Color {
    init(light: Color, dark: Color) {
        self.init(UIColor(light: UIColor(light), dark: UIColor(dark)))
    }
    
    init(hexString: String, opacity: Double = 1.0) {
        let hex: Int = Int(hexString, radix: 16)!
        
        let red = Double((hex >> 16) & 0xff) / 255
        let green = Double((hex >> 8) & 0xff) / 255
        let blue = Double((hex >> 0) & 0xff) / 255
        
        self.init(.sRGB, red: red, green: green, blue: blue, opacity: opacity)
    }
    
    func toGradient() -> LinearGradient {
        return LinearGradient(colors: [self], startPoint: .top, endPoint: .bottom)
    }
    
}

extension Color {
    
    // MARK: - Semantic Color
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
    // MARK: - System Colors
    static let shortcutsZipBackground = Color("Grey020")
    static let shortcutsZipWhite = Color("Grey010")
    static let shortcutsZipPrimary = Color("Primary")
    static let shortcutsZipError = Color("Error")
    static let shortcutsZipDanger = Color("Danger")
    static let shortcutsZipSuccess = Color("Success")
    
    // MARK: - Text Colors
    static let gray1 = Color("Grey030")
    static let gray2 = Color("Grey040")
    static let gray3 = Color("Grey050")
    static let gray4 = Color("Grey060")
    static let gray5 = Color("Grey070")
    static let gray6 = Color("Grey080")
    
    
    /**
     # code
     
        Color.fetchGradient(color: 컬러명)
     
     */
    static func fetchGradient(color: String) -> LinearGradient {
        let colors = [Color("\(color)01"), Color("\(color)02")]
        return LinearGradient(colors: colors, startPoint: .topLeading, endPoint: .bottomTrailing)
        
    }
    static func fetchDefaultGradient() -> LinearGradient {
        LinearGradient(colors: [Color.gray1], startPoint: .topLeading, endPoint: .bottomTrailing)
    }
}


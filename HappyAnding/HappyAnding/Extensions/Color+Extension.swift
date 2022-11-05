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
    
    //gradient사용하는 곳에서 Color.fetchGradient(color: "Red")와 같이 사용해주세요
    //컬러명은 숫자를 제외하고 UpperCamelCase로 입력해주세요
    static func fetchGradient(color: String) -> LinearGradient {
        let colors = [Color("\(color)01"), Color("\(color)02")]
        return LinearGradient(colors: colors, startPoint: .topLeading, endPoint: .bottomTrailing)
    }
}

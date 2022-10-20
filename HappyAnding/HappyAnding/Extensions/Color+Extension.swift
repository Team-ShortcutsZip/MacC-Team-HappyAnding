//
//  Color+Extension.swift
//  HappyAnding
//
//  Created by 이지원 on 2022/10/20.
//

import SwiftUI

extension Color {
    ///System Colors
    static let Background = Color("Background")
    static let White = Color("White")
    static let Primary = Color("Primary")
    static let Error = Color("Error")
    static let Danger = Color("Danger")
    static let Success = Color("Success")
    
    ///Text Colors
    static let Gray1 = Color("Gray1")
    static let Gray2 = Color("Gray2")
    static let Gray3 = Color("Gray3")
    static let Gray4 = Color("Gray4")
    static let Gray5 = Color("Gray5")
    
    ///Content Colors
    static let Red01 = Color("Red01")
    static let Coral01 = Color("Coral01")
    static let Orange01 = Color("Orange01")
    static let Yellow01 = Color("Yellow01")
    static let Green01 = Color("Green01")
    static let Mint01 = Color("Mint01")
    static let Teal01 = Color("Teal01")
    static let Cyan01 = Color("Cyan01")
    static let Blue01 = Color("Blue01")
    static let Purple01 = Color("Purple01")
    static let LightPurple01 = Color("LightPurple01")
    static let Pink01 = Color("Pink01")
    static let Gray01 = Color("Gray01")
    static let Khaki01 = Color("Khaki01")
    static let Brown01 = Color("Brown01")
    
    static let Red02 = Color("Red02")
    static let Coral02 = Color("Coral02")
    static let Orange02 = Color("Orange02")
    static let Yellow02 = Color("Yellow02")
    static let Green02 = Color("Green02")
    static let Mint02 = Color("Mint02")
    static let Teal02 = Color("Teal02")
    static let Cyan02 = Color("Cyan02")
    static let Blue02 = Color("Blue02")
    static let Purple02 = Color("Purple02")
    static let LightPurple02 = Color("LightPurple02")
    static let Pink02 = Color("Pink02")
    static let Gray02 = Color("Gray02")
    static let Khaki02 = Color("Khaki02")
    static let Brown02 = Color("Brown02")
}

extension LinearGradient{
    //그라디언트가 들어가는 부분에 LinearGradient.RedGradient 와 같이 사용해주세요
    static let RedGradient = LinearGradient(colors: [.Red01,.Red02], startPoint: .topLeading, endPoint: .bottomTrailing)
    static let CoralGradient = LinearGradient(colors: [.Coral01,.Coral02], startPoint: .topLeading, endPoint: .bottomTrailing)
    static let OrangeGradient = LinearGradient(colors: [.Orange01,.Orange02], startPoint: .topLeading, endPoint: .bottomTrailing)
    static let YellowGradient = LinearGradient(colors: [.Yellow01,.Yellow02], startPoint: .topLeading, endPoint: .bottomTrailing)
    static let GreenGradient = LinearGradient(colors: [.Green01,.Green02], startPoint: .topLeading, endPoint: .bottomTrailing)
    static let MintGradient = LinearGradient(colors: [.Mint01,.Mint02], startPoint: .topLeading, endPoint: .bottomTrailing)
    static let TealGradient = LinearGradient(colors: [.Teal01,.Teal02], startPoint: .topLeading, endPoint: .bottomTrailing)
    static let CyanGradient = LinearGradient(colors: [.Cyan01,.Cyan02], startPoint: .topLeading, endPoint: .bottomTrailing)
    static let BlueGradient = LinearGradient(colors: [.Blue01,.Blue02], startPoint: .topLeading, endPoint: .bottomTrailing)
    static let PurpleGradient = LinearGradient(colors: [.Purple01,.Purple02], startPoint: .topLeading, endPoint: .bottomTrailing)
    static let LightPurpleGradient = LinearGradient(colors: [.LightPurple01,.LightPurple02], startPoint: .topLeading, endPoint: .bottomTrailing)
    static let PinkGradient = LinearGradient(colors: [.Pink01,.Pink02], startPoint: .topLeading, endPoint: .bottomTrailing)
    static let GrayGradient = LinearGradient(colors: [.Gray01,.Gray02], startPoint: .topLeading, endPoint: .bottomTrailing)
    static let KhakiGradient = LinearGradient(colors: [.Khaki01,.Khaki02], startPoint: .topLeading, endPoint: .bottomTrailing)
    static let BrownGradient = LinearGradient(colors: [.Brown01,.Brown02], startPoint: .topLeading, endPoint: .bottomTrailing)
}

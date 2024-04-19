//
//  Image+Extension.swift
//  HappyAnding
//
//  Created by 전지민 on 2022/11/29.
//

import SwiftUI

extension Image {
    
    ///SF Symbol
    func smallSF() -> some View {
        resizable()
            .scaledToFit()
            .frame(width: 24, height: 24)
    }
    func mediumSF() -> some View {
        resizable()
            .scaledToFit()
            .frame(width: 28, height: 28)
    }
    func largeSF() -> some View {
        resizable()
            .scaledToFit()
            .frame(width: 36, height: 36)
    }
    func extraLargeSF() -> some View {
        resizable()
            .scaledToFit()
            .frame(width: 46, height: 46)
    }
    func customSF(size: CGFloat) -> some View {
        resizable()
            .scaledToFit()
            .frame(width: size, height: size)
    }
    
    /// Color가 gray4, size: 24, frame size가 32인 Cell을 관리하는 함수입니다.
    func setCellIcon() -> some View {
        self
            .foregroundStyle(Color.gray4)
            .mediumShortcutIcon()
            .frame(height: 32)
    }
}

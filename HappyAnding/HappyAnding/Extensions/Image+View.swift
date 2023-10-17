//
//  Image+Extension.swift
//  HappyAnding
//
//  Created by 전지민 on 2022/11/29.
//

import SwiftUI

extension Image {
    
    /// Color가 gray4, size: 24, frame size가 32인 Cell을 관리하는 함수입니다.
    func setCellIcon() -> some View {
        self
            .foregroundStyle(Color.gray4)
            .mediumShortcutIcon()
            .frame(height: 32)
    }
}

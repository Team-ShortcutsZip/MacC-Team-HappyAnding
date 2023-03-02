//
//  Image+Extension.swift
//  HappyAnding
//
//  Created by 전지민 on 2022/11/29.
//

import SwiftUI

extension Image {
    func setCellIcon() -> some View {
        self
            .foregroundColor(.gray4)
            .mediumShortcutIcon()
            .frame(height: 32)
    }
}

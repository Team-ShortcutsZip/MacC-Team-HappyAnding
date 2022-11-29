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
            .foregroundColor(.Gray4)
            .font(.system(size: 24, weight: .medium))
            .frame(height: 32)
    }
}

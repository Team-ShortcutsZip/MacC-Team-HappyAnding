//
//  ShortcutIcon.swift
//  HappyAnding
//
//  Created by JeonJimin on 4/2/24.
//

import SwiftUI

struct ShortcutIcon: View {
    @Environment(\.colorScheme) var colorScheme
    
    let sfsymbol: String
    let color: String
    let size: CGFloat
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 13)
                .foregroundStyle(SCZColor.colors[color]?.color(for: colorScheme).fillGradient() ?? SCZColor.defaultColor)
                .overlay(
                    RoundedRectangle(cornerRadius: 13)
                        .strokeBorder(.white.opacity(0.24), lineWidth: 2)
                )
                .frame(width: size, height: size)
            Image(systemName: sfsymbol)
                .font(.system(size: 28))
                .foregroundStyle(Color.white)
        }
    }
}

#Preview {
    ShortcutIcon(sfsymbol: "play.rectangle.fill", color: "Red", size: 56)
}

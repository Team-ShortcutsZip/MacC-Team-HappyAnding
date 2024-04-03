//
//  ShortcutIcon.swift
//  HappyAnding
//
//  Created by JeonJimin on 4/2/24.
//

import SwiftUI

struct ShortcutIcon: View {
    @Environment(\.colorScheme) var colorScheme
    
    let sfSymbol: String
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
            Image(systemName: sfSymbol)
                .font(.system(size: 28))
                .foregroundStyle(Color.white)
        }
    }
}

#Preview {
    ShortcutIcon(sfSymbol: "play.rectangle.fill", color: "Red", size: 56)
}

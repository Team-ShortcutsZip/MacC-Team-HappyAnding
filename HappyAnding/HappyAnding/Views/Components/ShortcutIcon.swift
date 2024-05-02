//
//  ShortcutIcon.swift
//  HappyAnding
//
//  Created by JeonJimin on 4/2/24.
//

import SwiftUI

//TODO: 추후 사이즈별 아이콘 크기 조절 필요
struct ShortcutIcon: View {
    @Environment(\.colorScheme) var colorScheme
    
    let sfSymbol: String
    let color: String
    let size: CGFloat
    
    var body: some View {
        ZStack {
            Image(systemName: "app.fill")
                .resizable()
                .scaledToFit()
                .frame(width: size, height: size)
                .foregroundStyle(SCZColor.colors[color]?.color(for: colorScheme).fillGradient() ??  Color.clear.toGradient())
            Image(size>50 ? "appLarge" : "app")
                .resizable()
                .scaledToFit()
                .frame(width: size, height: size)
                .foregroundStyle(SCZColor.colors[color]?.color(for: colorScheme).strokeGradient() ??  Color.clear.toGradient())
            Image(systemName: sfSymbol)
                .font(.system(size: size/2))
                .foregroundStyle(Color.white)
        }
    }
}
 
#Preview {
    ShortcutIcon(sfSymbol: "alarm.fill", color: "Yellow", size: 96)
}

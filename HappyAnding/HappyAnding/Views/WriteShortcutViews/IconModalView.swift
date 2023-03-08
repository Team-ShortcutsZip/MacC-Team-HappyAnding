//
//  IconModalView.swift
//  HappyAnding
//
//  Created by 이지원 on 2022/10/19.
//

import SwiftUI

struct IconModalView: View {
    
    @Binding var isShowingIconModal: Bool
    @Binding var iconColor: String
    @Binding var iconSymbol: String
    
    private let gridLayout = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]
    
    let symbols = [
        "square.stack.3d.up.fill",
        "house.fill",
        "map.fill",
        "bus.fill",
        "alarm.fill",
        "calendar",
        "magnifyingglass",
        "bubble.left.fill",
        "phone.fill",
        "speaker.wave.2.fill",
        "music.note",
        "photo.fill",
        "doc.text.fill",
        "keyboard.fill",
        "mic.fill",
        "creditcard.fill",
        "paintpalette.fill",
        "cloud.sun.fill",
        "figure.walk",
        "globe",
        "gearshape.fill"
    ]
    
    let colors = [
        "Red",
        "Coral",
        "Orange",
        "Yellow",
        "Green",
        "Mint",
        "Teal",
        "Cyan",
        "Blue",
        "Purple",
        "LightPurple",
        "Pink",
        "Gray",
        "Khaki",
        "Brown"
    ]
    
    var body: some View {
        VStack {
            HStack(spacing: 0) {
                Button {
                    self.isShowingIconModal = false
                } label: {
                    Text(TextLiteral.close)
                        .foregroundColor(.gray5)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.leading, 16)
                }
                
                Text(TextLiteral.iconModalViewTitle)
                    .shortcutsZipHeadline()
                    .frame(maxWidth: .infinity)
                
                Spacer()
                    .frame(maxWidth: .infinity)
            }
            .padding(.top, 24)
            .padding(.bottom, 24)
            
            ZStack(alignment: .center) {
                Rectangle()
                    .fill(Color.gray1)
                    .cornerRadius(UIScreen.main.bounds.size.height > 700 ? 20 : 12.35)
                    .frame(width: UIScreen.main.bounds.size.height > 700 ? 136 : 84, height: UIScreen.main.bounds.size.height > 700 ? 136 : 84)
                
                Rectangle()
                    .fill(Color.fetchGradient(color: iconColor))
                    .cornerRadius(UIScreen.main.bounds.size.height > 700 ? 20 : 12.35)
                    .frame(width: UIScreen.main.bounds.size.height > 700 ? 136 : 84, height: UIScreen.main.bounds.size.height > 700 ? 136 : 84)
                
                Image(systemName: iconSymbol)
                    .font(.system(size: UIScreen.main.bounds.size.height > 700 ? 48 : 32, weight: .medium))
                    .frame(width: UIScreen.main.bounds.size.height > 700 ? 136 : 84, height: UIScreen.main.bounds.size.height > 700 ? 136 : 84)
                    .foregroundColor(.textIcon)
            }
            .padding(.bottom, 24)
            
            Text(TextLiteral.iconModalViewColor)
                .shortcutsZipSubtitle()
                .padding(.leading, 16)
                .foregroundColor(.gray4)
                .frame(maxWidth: .infinity, alignment: .leading)
            LazyVGrid(columns: gridLayout, spacing: 12) {
                ForEach(colors, id: \.self) { item in
                    ColorCell(iconColor: $iconColor, paletteColor: item)
                }
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 24)
            
            Text(TextLiteral.iconModalViewIcon)
                .shortcutsZipSubtitle()
                .padding(.leading, 16)
                .foregroundColor(.gray4)
                .frame(maxWidth: .infinity, alignment: .leading)
            LazyVGrid(columns: gridLayout, spacing: 12) {
                ForEach(symbols, id: \.self) { item in
                    SymbolCell(iconSymbol: $iconSymbol, paletteSymbol: item)
                }
            }
            .padding(.horizontal, 16)
            
            Spacer()
            
            Button(action: {
                isShowingIconModal = false 
            }, label: {
                ZStack {
                    RoundedRectangle(cornerRadius: 12)
                        .foregroundColor(!iconColor.isEmpty && !iconSymbol.isEmpty ? .shortcutsZipPrimary : .shortcutsZipPrimary.opacity(0.13) )
                        .frame(maxWidth: .infinity, maxHeight: 52)
                    
                    Text(TextLiteral.done)
                        .foregroundColor(!iconColor.isEmpty && !iconSymbol.isEmpty ? .textButton : .textButtonDisable )
                        .shortcutsZipBody1()
                }
            })
            .disabled(iconColor.isEmpty || iconSymbol.isEmpty)
            .padding(.horizontal, 16)
            .padding(.bottom, 24)
        }
        .background(Color.shortcutsZipBackground)
    }
    
    struct ColorCell: View {
        @Binding var iconColor: String
        
        let paletteColor: String
        
        var body: some View {
            Button(action: {
                iconColor = paletteColor
            }, label: {
                ZStack {
                    Rectangle()
                        .fill(Color.fetchGradient(color: paletteColor))
                        .cornerRadius(8)
                        .frame(width: 36, height: 36)
                    
                    if paletteColor == iconColor {
                        Image(systemName: "checkmark")
                            .smallIcon()
                            .foregroundColor(.textIcon)
                    }
                }
            })
        }
    }
    
    struct SymbolCell: View {
        @Binding var iconSymbol: String
        
        let paletteSymbol: String
        
        var body: some View {
            Button(action: {
                iconSymbol = paletteSymbol
            }, label: {
                ZStack(alignment: .center) {
                    Rectangle()
                        .fill(paletteSymbol == iconSymbol ? Color.gray1 : Color.clear)
                        .cornerRadius(8)
                        .frame(width: 36, height: 36)
                    
                    Image(systemName: paletteSymbol)
                        .foregroundColor(paletteSymbol == iconSymbol ? Color.gray5 : Color.gray3)
                }
            })
        }
    }
}

struct IconModalView_Previews: PreviewProvider {
    static var previews: some View {
        IconModalView(isShowingIconModal: .constant(true), iconColor: .constant("LightPurple"), iconSymbol: .constant("bus.fill"))
    }
}

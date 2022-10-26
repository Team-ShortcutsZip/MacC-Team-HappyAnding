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
        "graduationcap.fill",
        "books.vertical.fill",
        "creditcard.fill",
        "printer.fill",
        "phone.fill",
        "cross.fill",
        "newspaper.fill",
        "bus.fill",
        "alarm.fill",
        "calendar",
        "cloud.sun.fill",
        "camera.fill",
        "paintpalette.fill",
        "paintbrush.fill",
        "hammer.fill",
        "tray.fill",
        "speaker.wave.2.fill",
        "gearshape.fill",
        "command.square.fill",
        "bubble.left.fill",
        "headphones"
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
            Text("아이콘")
                .font(.headline)
                .padding(.top, 16)
                .padding(.bottom, 24)
            
            ZStack(alignment: .center) {
                Rectangle()
                    .fill(Color.Gray1)
                    .cornerRadius(UIScreen.main.bounds.size.height > 700 ? 20 : 12.35)
                    .frame(width: UIScreen.main.bounds.size.height > 700 ? 136 : 84, height: UIScreen.main.bounds.size.height > 700 ? 136 : 84)
                
                Rectangle()
                    .fill(Color.fetchGradient(color: iconColor))
                    .cornerRadius(UIScreen.main.bounds.size.height > 700 ? 20 : 12.35)
                    .frame(width: UIScreen.main.bounds.size.height > 700 ? 136 : 84, height: UIScreen.main.bounds.size.height > 700 ? 136 : 84)
                
                Image(systemName: iconSymbol)
                    .font(.system(size: UIScreen.main.bounds.size.height > 700 ? 48 : 32))
                    .frame(width: UIScreen.main.bounds.size.height > 700 ? 136 : 84, height: UIScreen.main.bounds.size.height > 700 ? 136 : 84)
                    .foregroundColor(.White)
            }
            .padding(.bottom, 24)
            
            Text("색상")
                .Subtitle()
                .padding(.leading, 16)
                .foregroundColor(.Gray4)
                .frame(maxWidth: .infinity, alignment: .leading)
            LazyVGrid(columns: gridLayout, spacing: 12) {
                ForEach(colors, id: \.self) { item in
                    ColorCell(paletteColor: item, iconColor: $iconColor)
                }
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 24)
            
            Text("기호")
                .Subtitle()
                .padding(.leading, 16)
                .foregroundColor(.Gray4)
                .frame(maxWidth: .infinity, alignment: .leading)
            LazyVGrid(columns: gridLayout, spacing: 12) {
                ForEach(symbols, id: \.self) { item in
                    SymbolCell(paletteSymbol: item, iconSymbol: $iconSymbol)
                }
            }
            .padding(.horizontal, 16)
            
            Spacer()
            
            Button(action: {
                isShowingIconModal = false
            }, label: {
                ZStack {
                    RoundedRectangle(cornerRadius: 12)
                        .foregroundColor(!iconColor.isEmpty && !iconSymbol.isEmpty ? .Primary : .Gray1 )
                        .frame(maxWidth: .infinity, maxHeight: 52)
                    
                    Text("완료")
                        .foregroundColor(!iconColor.isEmpty && !iconSymbol.isEmpty ? .Background : .Gray3 )
                        .Body1()
                }
            })
            .disabled(iconColor.isEmpty || iconSymbol.isEmpty)
            .padding(.horizontal, 16)
            .padding(.bottom, 24)
        }
    }
    
    struct ColorCell: View {
        let paletteColor: String
        @Binding var iconColor: String
        
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
                            .foregroundColor(.Gray1)
                    }
                }
            })
        }
    }
    
    struct SymbolCell: View {
        let paletteSymbol: String
        @Binding var iconSymbol: String
        
        var body: some View {
            Button(action: {
                iconSymbol = paletteSymbol
            }, label: {
                ZStack(alignment: .center) {
                    Rectangle()
                        .fill(paletteSymbol == iconSymbol ? Color.Gray1 : Color.clear)
                        .cornerRadius(8)
                        .frame(width: 36, height: 36)
                    
                    Image(systemName: paletteSymbol)
                        .foregroundColor(paletteSymbol == iconSymbol ? Color.Gray5 : Color.Gray3)
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

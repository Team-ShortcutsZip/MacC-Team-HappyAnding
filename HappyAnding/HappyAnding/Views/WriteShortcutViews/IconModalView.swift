//
//  IconModalView.swift
//  HappyAnding
//
//  Created by 이지원 on 2022/10/19.
//

import SwiftUI

struct IconModalView: View {
    
    @StateObject var viewModel: WriteShortcutModalViewModel
    
    @Binding var isShowingIconModal: Bool
    @Binding var iconColor: String
    @Binding var iconSymbol: String
    
    private let gridLayout = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]
    
    var body: some View {
        ScrollViewReader { proxy in
            VStack {
                HStack(spacing: 0) {
                    Button {
                        self.isShowingIconModal = false
                    } label: {
                        Text(TextLiteral.close)
                            .foregroundStyle(Color.gray5)
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
                .padding(.bottom, 8)
                
                ZStack(alignment: .center) {
                    Rectangle()
                        .foregroundStyle(iconColor.isEmpty
                                         ? LinearGradient(colors: [Color.gray1, Color.gray2], startPoint: .topLeading, endPoint: .bottomTrailing)
                                         : Color.fetchGradient(color: iconColor))
                        .aspectRatio(contentMode: .fit)
                        .cornerRadius(UIScreen.screenHeight > 700 ? 20 : 12.35)
                        .frame(height: UIScreen.screenHeight > 700 ? 136 : 84)
                    
                    Image(systemName: iconSymbol)
                        .font(.system(size: UIScreen.screenHeight > 700 ? 48 : 32))
                        .aspectRatio(contentMode: .fit)
                        .frame(height: UIScreen.screenHeight > 700 ? 136 : 84)
                        .foregroundStyle(Color.textIcon)
                }
                .padding(.vertical, 24)
                
                ScrollView(.vertical) {
                    
                    Text(TextLiteral.iconModalViewColor)
                        .shortcutsZipSubtitle()
                        .padding(.horizontal, 16)
                        .foregroundStyle(Color.gray4)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    LazyVGrid(columns: gridLayout, spacing: 12) {
                        ForEach(viewModel.colors, id: \.self) { item in
                            ColorCell(iconColor: $iconColor, paletteColor: item)
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.bottom, 24)
                    
                    Text(TextLiteral.iconModalViewIcon)
                        .shortcutsZipSubtitle()
                        .padding(.horizontal, 16)
                        .foregroundStyle(Color.gray4)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    LazyVStack(pinnedViews: [.sectionHeaders]) {
                        Section {
                            ForEach(viewModel.categories, id: \.self) { key in
                                Text(key)
                                    .shortcutsZipBody2()
                                    .foregroundStyle(Color.gray4)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .padding(.top, 12)
                                    .id(key)

                                LazyVGrid(columns: gridLayout, spacing: 12) {
                                    ForEach(viewModel.symbols[key] ?? [], id: \.self) { value in
                                        SymbolCell(iconSymbol: $iconSymbol, paletteSymbol: value)
                                    }
                                }
                            }
                            .padding(.horizontal, 16)
                        } header: {
                            ScrollView(.horizontal) {
                                HStack {
                                    ForEach(viewModel.categories, id: \.self) { key in
                                        Button {
                                            viewModel.selectedCategory = key
                                            withAnimation() {
                                                proxy.scrollTo(key, anchor: .top)
                                            }
                                        } label: {
                                            Text(key)
                                                .shortcutsZipBody2()
                                                .padding(.horizontal, 12)
                                                .padding(.vertical, 6)
                                                .foregroundStyle(key == viewModel.selectedCategory ? Color.tagText : Color.gray4)
                                                .background(key == viewModel.selectedCategory ? Color.tagBackground : nil)
                                                .clipShape(Capsule())
                                                .overlay(
                                                    Capsule()
                                                        .strokeBorder(key == viewModel.selectedCategory ? Color.shortcutsZipPrimary : Color.gray4, lineWidth: 1)
                                                )
                                        }
                                    }
                                }
                                .frame(maxHeight: .infinity)
                                .padding(.horizontal, 16)
                                .padding(.bottom, 8)
                            }
                            .background(Color.shortcutsZipBackground)
                            .scrollIndicators(.hidden)
                        }
                    }
                }
                .scrollIndicators(.hidden)
                
                Button {
                    self.isShowingIconModal = false
                } label: {
                    ZStack {
                        RoundedRectangle(cornerRadius: 12)
                            .foregroundStyle(!iconColor.isEmpty && !iconSymbol.isEmpty ? Color.shortcutsZipPrimary : Color.shortcutsZipPrimary.opacity(0.13))
                            .frame(maxWidth: .infinity, maxHeight: 52)
                        
                        Text(TextLiteral.done)
                            .foregroundStyle(!iconColor.isEmpty && !iconSymbol.isEmpty ? Color.textButton : Color.textButtonDisable)
                            .shortcutsZipBody1()
                    }
                }
                .disabled(iconColor.isEmpty || iconSymbol.isEmpty)
                .padding(.horizontal, 16)
                .padding(.bottom, 24)
            }
            .background(Color.shortcutsZipBackground)
        }
        .onAppear {
            viewModel.categories = Array(viewModel.symbols.keys)
            viewModel.selectedCategory = viewModel.categories[0]
        }
    }
    
    struct ColorCell: View {
        @Binding var iconColor: String
        
        let paletteColor: String
        
        var body: some View {
            Button {
                iconColor = paletteColor
            } label: {
                ZStack {
                    Rectangle()
                        .fill(Color.fetchGradient(color: paletteColor))
                        .cornerRadius(8)
                        .frame(width: 36, height: 36)
                    
                    if paletteColor == iconColor {
                        Image(systemName: "checkmark")
                            .smallIcon()
                            .foregroundStyle(Color.textIcon)
                    }
                }
            }
        }
    }
    
    struct SymbolCell: View {
        @Binding var iconSymbol: String
        
        let paletteSymbol: String
        
        var body: some View {
            Button {
                iconSymbol = paletteSymbol
            } label: {
                ZStack(alignment: .center) {
                    Rectangle()
                        .fill(paletteSymbol == iconSymbol ? Color.gray1 : Color.clear)
                        .cornerRadius(8)
                        .frame(width: 36, height: 36)
                    
                    Image(systemName: paletteSymbol)
                        .foregroundStyle(paletteSymbol == iconSymbol ? Color.gray5 : Color.gray3)
                }
            }
        }
    }
}

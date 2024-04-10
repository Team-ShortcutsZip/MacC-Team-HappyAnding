//
//  ExploreCell.swift
//  HappyAnding
//
//  Created by JeonJimin on 4/2/24.
//

import SwiftUI

enum CellType {
    case ordered
    case unorderd
}

struct OrderedCell: View {
    @Environment(\.colorScheme) var colorScheme

    let shortcut: Shortcuts
    let index: Int
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Seal(index: index, type: .exploreCell)
            Text(shortcut.title)
                .foregroundStyle(SCZColor.Basic)
                .font(.system(size: 15, weight: .bold))
                .multilineTextAlignment(.leading)
                .lineLimit(2)
                .blendMode(.plusDarker)
            Spacer()
            HStack(spacing: 8) {
                HStack(spacing: 3) {
                    Image(systemName: "arrow.down.to.line.circle.fill")
                        .frame(width: 14)
                    Text(formatNumber(shortcut.numberOfDownload))
                        .font(.system(size: 11, weight: .medium))
                        .lineLimit(1)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                .foregroundStyle(SCZColor.CharcoalGray.opacity24)
                .blendMode(.colorBurn)
                Image(systemName: shortcut.sfSymbol)
                    .foregroundStyle(Color.white)
                    .font(.system(size: 20))
            }
            
        }
        .padding(12)
        .frame(width: 108, height: 144, alignment: .top)
        .background( SCZColor.colors[shortcut.color]?.color(for: colorScheme).fillGradient() ?? SCZColor.defaultColor)
        .cornerRadius(16)
        .roundedBorder(cornerRadius: 16, color: Color.white, isNormalBlend: true, opacity: 0.12)
    }
    
    private func formatNumber(_ number: Int) -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        return numberFormatter.string(from: NSNumber(value: number))!
    }
}

struct UnorderedCell: View{
    @Environment(\.colorScheme) var colorScheme
    
    let shortcut: Shortcuts
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                RoundedRectangle(cornerRadius: 1)
                    .frame(width: 2, height: 30)
                    .foregroundStyle(SCZColor.colors[shortcut.color]?.color(for: colorScheme).fillGradient() ?? SCZColor.defaultColor)
                Image(systemName: shortcut.sfSymbol)
                    .foregroundStyle(SCZColor.CharcoalGray.opacity88)
            }
            Text(shortcut.title)
                .foregroundStyle(SCZColor.Basic)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .font(.system(size: 15, weight: .bold))
        .padding(12)
        .frame(width: 108, height: 144, alignment: .top)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.white)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(SCZColor.Basic.opacity(0.12), lineWidth: 2)
                )
        )
        .cornerRadius(16)
        .dropShadow()
    }
}

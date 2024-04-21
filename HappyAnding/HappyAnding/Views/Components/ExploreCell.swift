//
//  ExploreCell.swift
//  HappyAnding
//
//  Created by JeonJimin on 4/2/24.
//

import SwiftUI

struct OrderedCell: View {
    @Environment(\.colorScheme) var colorScheme

    let type: SectionType
    let index: Int
    let shortcut: Shortcuts
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            if type == .download || type == .popular {
                Seal(index: index, type: .exploreCell)
            }
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
        .background( SCZColor.colors[shortcut.color]?.color(for: colorScheme).fillGradient() ?? Color.clear.toGradient())
        .cornerRadius(16)
        .roundedBorder(cornerRadius: 16, color: Color.white, isNormalBlend: true, opacity: 0.12)
        .navigationLinkRouter(data: shortcut)
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
                    .foregroundStyle(SCZColor.colors[shortcut.color]?.color(for: colorScheme).fillGradient() ?? Color.clear.toGradient())
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
        .navigationLinkRouter(data: shortcut)
    }
}

struct ExpandedCell: View {
    let type: SectionType
    let shortcuts: [Shortcuts]
    
    var body: some View {
        VStack(alignment: .center, spacing: 4) {
            Image(systemName: "rectangle.portrait.on.rectangle.portrait.angled.fill")
            Text("더보기")
        }
        .foregroundStyle(SCZColor.CharcoalGray.opacity64)
        .font(.system(size: 15, weight: .semibold))
        .frame(width: 108, height: 144, alignment: .center)
        .background(
            ZStack {
                Color.white.opacity(0.24)
                SCZColor.CharcoalGray.opacity08
            }
        )
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .strokeBorder(Color.white.opacity(0.12), lineWidth: 2)
        )
        .shadow(color: SCZColor.CharcoalGray.opacity04, radius: 4, x: 0, y: 2)
        .navigationLinkRouter(data: type)
    }
}

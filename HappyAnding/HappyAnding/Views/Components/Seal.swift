//
//  Seal.swift
//  HappyAnding
//
//  Created by JeonJimin on 4/3/24.
//

import SwiftUI

enum SealType {
    case exploreCell
    case ranking
}
struct Seal: View {
    let index: Int
    let type: SealType
    
    var body: some View {
        ZStack {
            Image(systemName: "seal.fill")
                .resizable()
                .scaledToFit()
                .frame(width: fetchSealSize())
                .foregroundStyle(fetchSealColor())
            Image(systemName: "seal")
                .resizable()
                .scaledToFit()
                .frame(width: fetchSealSize())
                .foregroundStyle(fetchSealStrokeColor())
            Text("\(index)")
            //TODO: 폰트 적용 필요
                .font(.system(size: 15, weight: .medium))
                .foregroundStyle(fetchTextColor())
                .blendMode(fetchBlendMode())
        }
    }
    
    private func fetchSealColor() -> LinearGradient {
        switch type {
        case .ranking:
            switch index {
            case 1:
                return SCZColor.Seal.gold
            case 2:
                return SCZColor.Seal.silver
            case 3:
                return SCZColor.Seal.bronze
            case 4,5:
                return SCZColor.Seal.iron
            default:
                return SCZColor.Seal.defaultColor
                
            }
        case .exploreCell:
            return Color.white.opacity(0.64).toGradient()
        }
    }
    
    private func fetchSealStrokeColor() -> Color {
        switch type {
        case .ranking:
            switch index {
            case 1,2,3:
                return Color.white.opacity(0.12)
            case 4,5:
                return SCZColor.CharcoalGray.opacity04
            default:
                return Color.clear
            }
        case .exploreCell:
            return Color.white.opacity(0.24)
        }
        
    }
    private func fetchTextColor() ->  LinearGradient {
        switch type {
        case .ranking:
            switch index {
            case 1:
                return SCZColor.Seal.textGold
            case 2:
                return SCZColor.Seal.textSilver
            case 3:
                return SCZColor.Seal.textBronze
            case 4,5:
                return SCZColor.Seal.textIron
            default:
                return SCZColor.Seal.textDefault
            }
        case .exploreCell:
            return SCZColor.CharcoalGray.opacity64.toGradient()
        }
    }
    
    private func fetchBlendMode() -> BlendMode {
        switch type {
        case .ranking:
            switch index{
            case 1, 2, 3:
                return .multiply
            case 4,5:
                return .colorBurn
            default:
                return .normal
            }
        case .exploreCell:
            return .colorBurn
        }
    }
    
    private func fetchSealSize() -> CGFloat {
        switch type {
        case .ranking, .exploreCell:
            return 28
        }
    }
}

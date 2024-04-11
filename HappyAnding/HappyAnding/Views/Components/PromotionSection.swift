//
//  PromotionSection.swift
//  HappyAnding
//
//  Created by JeonJimin on 4/2/24.
//

import SwiftUI

//TODO: 폰트 적용 및 PromotionCard shortDescription 적용 필요
struct PromoteSection: View {
    
    let items: [Curation]
    
    let pageCount: Int
    let visibleEdgeSpace: CGFloat = 10
    let spacing: CGFloat = 6
    
    @GestureState var dragOffset: CGFloat = 0
    @State var currentIndex: Int = 0
    
    init(items: [Curation]) {
        self.items = items
        self.pageCount = items.count
    }
    
    var body: some View {
        VStack(spacing: 16) {
            TabView(selection: $currentIndex) {
                ForEach(0..<items.count, id: \.self) { index in
                    PromotionCard(promotion: items[index])
                }
                
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            .frame(height:240)
            HStack(spacing: 8) {
                ForEach((0..<items.count), id: \.self) { index in
                    Circle()
                        .fill(index == self.currentIndex ?
                              SCZColor.promotionIndicator.opacity(1) :
                                SCZColor.promotionIndicator.opacity(0.38)
                        )
                        .frame(width: 8)
                }
            }
        }
    }
}

struct PromotionCard: View {
    var promotion: Curation
    var body: some View {
        ZStack {
            backgroundImage
            VStack(alignment: .center, spacing: 8) {
                VStack(alignment: .center, spacing: 4) {
                    Text(promotion.subtitle.replacingOccurrences(of: "\\n", with: "\n"))
                        .font(.system(size: 12))
                    Text(promotion.title)
                        .font(.system(size: 20))
                }
                
                HStack(alignment: .center, spacing: 12) {
                    
                    let count = promotion.shortcuts.count
                    let maxIcons = count > 3 ? 2 : 3

                    ForEach(Array(promotion.shortcuts.enumerated()).prefix(maxIcons), id: \.offset) { index, shortcut in
                        ShortcutIcon(sfSymbol: shortcut.sfSymbol, color: shortcut.color, size: 66)
                    }
                    if maxIcons == 2 {
                        MoreShortcutIcon(count: count - 2)
                    }
                }
                .padding(.vertical, 13)
                Text(promotion.subtitle.replacingOccurrences(of: "\\n", with: "\n"))
                    .font(Font.system(size: 14))
                    .multilineTextAlignment(.center)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 24)
        }
        .frame(width: UIScreen.screenWidth-(16*2), height: 240)
    }
    
    var backgroundImage: some View {
        ZStack {
            //TODO: 이미지 변경 필요
            Image("bannerBg")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .blur(radius: 12)
            Rectangle()
                .foregroundStyle(SCZColor.promotionBanner)
                .blendMode(.colorDodge)
            
        }
        .frame(height: 240)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .padding(.horizontal, 16)
    }
}

struct MoreShortcutIcon: View {
    let count: Int
    var body: some View {
        Text("+\(count)")
            .foregroundStyle(SCZColor.CharcoalGray.opacity48)
            .font(.system(size: 24, weight: .medium))
            .frame(width: 66, height: 66)
            .background(Color.white.opacity(0.12))
            .roundedBorder(cornerRadius: 13, color: Color.white, isNormalBlend: true, opacity: 0.24)
    }
}

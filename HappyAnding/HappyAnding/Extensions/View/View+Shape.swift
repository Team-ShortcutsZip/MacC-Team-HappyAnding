//
//  View+Shape.swift
//  HappyAnding
//
//  Created by 이지원 on 2023/02/26.
//

import SwiftUI

/// 뷰의 모서리를 설정하기 위한 확장입니다.
extension View {
    
    //TODO: 디자인 업데이트 완료 후 해당 익스텐션 삭제 필요
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape( RoundedCorner(radius: radius, corners: corners) )
    }
    
    ///반투명 테두리가 있는 둥근 모서리를 설정하기 위한 확장입니다.
    ///테두리의 두께는 고정값입니다.
    ///
    ///cornerRadius: 둥근 모서리의 정도를 설정합니다. 기본값 16.
    ///color: 테두리의 색상을 설정합니다. 기본값 "CharcoalGray"
    ///isBlendMode: 블랜드모드 적용을 조정합니다. 기본값 false
    ///opacity: 테두리의 투명도를 설정합니다. 기본값 1.0
    func roundedBorder(cornerRadius: CGFloat = 16, color: Color = Color("CharcoalGray"), isNormalBlend: Bool = true, opacity: Double = 1.0) -> some View {
        self.overlay(
            RoundedRectangle(cornerRadius: cornerRadius)
                .strokeBorder(color.opacity(opacity), lineWidth: 2)
                .blendMode(isNormalBlend ? .normal : .multiply)
        )
        .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
    }
    
    func roundedBackground(background: Color) -> some View {
        self
            .padding(.horizontal, 10)
            .padding(.vertical, 8)
            .background(background)
            .roundedBorder(cornerRadius: 16, color: Color.white.opacity(0.12), isNormalBlend: true)
    }
}


//MARK: - 둥근 모서리

/// 해당 Shape을 이용하여 다른 뷰에 적용합니다.
struct RoundedCorner: Shape {
    
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}

//MARK: - 삼각형
/// 삼각형 모양을 그리는 경우에 사용합니다.
struct Triangle: Shape {
    func path(in rect: CGRect) -> Path {
        Path { path in
            path.move(to: CGPoint(x: rect.midX, y: rect.minY))
            path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
            path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
            path.closeSubpath() 
        }
    }
}

//
//  View+Shape.swift
//  HappyAnding
//
//  Created by 이지원 on 2023/02/26.
//

import SwiftUI

/// 뷰의 모서리를 설정하기 위한 확장입니다.
extension View {
    
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape( RoundedCorner(radius: radius, corners: corners) )
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

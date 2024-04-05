//
//  View+Shadow.swift
//  HappyAnding
//
//  Created by HanGyeongjun on 4/5/24.
//

import SwiftUI

extension View {
    
    ///View에 Drop Shadow를 적용합니다.
    ///모든 View에서 사용되는 값에 변화가 없어 매개변수는 없습니다.
    func dropShadow() -> some View {
        self.shadow(color: Color("CharcoalGray").opacity(0.04),
                    radius: 8,
                    x: 0,
                    y: 2)
    }
}

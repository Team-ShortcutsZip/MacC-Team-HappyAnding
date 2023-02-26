//
//  Binding.swift
//  HappyAnding
//
//  Created by 이지원 on 2022/11/13.
//

import SwiftUI

extension Binding {
    
    /// Binding 변수가 Optional로 선언된 경우, 안전하게 Optional을 벗겨 리턴해주는 함수입나다.
    func unwrap<Wrapped>() -> Binding<Wrapped>? where Optional<Wrapped> == Value {
        guard let value = self.wrappedValue else { return nil }
        return Binding<Wrapped>(
            get: {
                return value
            },
            set: { value in
                self.wrappedValue = value
            }
        )
    }
}

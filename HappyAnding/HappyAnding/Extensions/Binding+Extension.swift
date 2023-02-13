//
//  Binding.swift
//  HappyAnding
//
//  Created by 이지원 on 2022/11/13.
//

import SwiftUI

extension Binding {
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

extension Binding where Value == Int {
    public func float() -> Binding<Float> {
        return Binding<Float>(get:{ Float(self.wrappedValue) },
            set: { self.wrappedValue = Int($0)})
    }
}

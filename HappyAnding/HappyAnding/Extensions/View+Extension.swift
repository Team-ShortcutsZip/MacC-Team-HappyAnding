//
//  View+Extension.swift
//  HappyAnding
//
//  Created by 이지원 on 2022/11/21.
//

import SwiftUI

//MARK: - 제스쳐
extension View {
    func readSize(onChange: @escaping (CGSize) -> Void) -> some View {
        background(
            GeometryReader { geometryProxy in
                Color.clear
                    .preference(key: SizePreferenceKey.self, value: geometryProxy.size)
            }
        )
        .onPreferenceChange(SizePreferenceKey.self, perform: onChange)
    }
    
    func swipeBack(perform action: @escaping () -> Void) -> some View {
        gesture(
            DragGesture()
                .onEnded({ value in
                    if value.translation.width > 50 {
                        action()
                    }
                })
        )
    }
    
    func swipeForward(perform action: @escaping () -> Void) -> some View {
        gesture(
            DragGesture()
                .onEnded({ value in
                    if value.translation.width < 0 {
                        action()
                    }
                })
            )
    }
    
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape( RoundedCorner(radius: radius, corners: corners) )
    }
}

//MARK: - 둥근 모서리
struct RoundedCorner: Shape {

    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}

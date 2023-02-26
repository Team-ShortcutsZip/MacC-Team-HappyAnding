//
//  View+Gesture.swift
//  HappyAnding
//
//  Created by 이지원 on 2023/02/26.
//

import SwiftUI

//MARK: - 제스쳐
/**
Read Shortcut View에서 커스텀 탭 뷰를 위한 확장입니다.
 */
extension View {
    
    /**
     Scroll View 내부에 tab view를 넣기 위해 사용되는 함수입니다. 해당 함수로 뷰의 크기를 확인할 수 있습니다.
     */
    func readSize(onChange: @escaping (CGSize) -> Void) -> some View {
        background(
            GeometryReader { geometryProxy in
                Color.clear
                    .preference(key: SizePreferenceKey.self, value: geometryProxy.size)
            }
        )
        .onPreferenceChange(SizePreferenceKey.self, perform: onChange)
    }
    
    
    /**
     사용자가 Swipe back 제스처를 실행할 때, action을 수행하게 하는 함수입니다.
     - parameters:
        - perform: swipe back 제스처를 수행하면 동작할 행위를 넣어주세요
     */
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
    
    
    /**
     사용자가 Swipe forward 제스처를 실행할 때, action을 수행하게 하는 함수입니다.
     - parameters:
        - perform: swipe forward 제스처를 수행하면 동작할 행위를 넣어주세요
     */
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
    
}

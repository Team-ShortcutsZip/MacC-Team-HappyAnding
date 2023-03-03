//
//  UINavigationContoller+Extension.swift
//  HappyAnding
//
//  Created by 이지원 on 2022/11/07.
//

import UIKit

/// Navigation의 Swipe Gesture를 위한 확장입니다.
extension UINavigationController: ObservableObject, UIGestureRecognizerDelegate {
    override open func viewDidLoad() {
        super.viewDidLoad()
        interactivePopGestureRecognizer?.delegate = self
    }
    
    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return viewControllers.count > 1
    }
}

//
//  NavigationUtil.swift
//  HappyAnding
//
//  Created by 이지원 on 2023/02/28.
//

import SwiftUI


struct NavigationUtil {
    
    static func popToRootView() {
        guard let windowScene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene,
              let rootViewController = windowScene.windows.filter({ $0.isKeyWindow }).first?.rootViewController else { return }
        
        let navigationController = findNavigationController(from: rootViewController)
        navigationController?.popToRootViewController(animated: true)
    }
    
    static func findNavigationController(from viewController: UIViewController) -> UINavigationController? {
        if let navigationController = viewController as? UINavigationController {
            return navigationController
        }
        for childViewController in viewController.children {
            if let navigationController = findNavigationController(from: childViewController) {
                return navigationController
            }
        }
        return nil
    }
}


//
//  Navigationbar+Extension.swift
//  HappyAnding
//
//  Created by 전지민 on 2022/10/25.
//

import UIKit

/**
 맨 처음 뷰가 선언되는 시점에 Theme.navigationBarColors() 를 선언하여 사용해주세요.
*/
///네비게이션바 아이템 색상을 변경하기 위한 클래스 입니다.
class Theme {
    static func navigationBarColors() {
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
     //   appearance.backgroundColor = UIColor.clear
        appearance.shadowColor = .clear
        appearance.largeTitleTextAttributes = [.font : UIFont.LargeTitle, .foregroundColor: UIColor(.Gray5)]
        //back button color 지정
        let backItemAppearance = UIBarButtonItemAppearance()
        backItemAppearance.normal.titleTextAttributes = [
            .foregroundColor: UIColor.clear
        ]
        appearance.backButtonAppearance = backItemAppearance
        
        //indicator color 지정
        let image = UIImage(systemName: "chevron.backward")?
            .withTintColor(UIColor(.Gray4), renderingMode: .alwaysOriginal)
        appearance.setBackIndicatorImage(image, transitionMaskImage: image)
        
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
        UINavigationBar.appearance().compactAppearance = appearance
        UINavigationBar.appearance().compactScrollEdgeAppearance = appearance
    }
}

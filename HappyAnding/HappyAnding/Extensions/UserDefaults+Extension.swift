//
//  UserDefaults+Extension.swift
//  HappyAnding
//
//  Created by HanGyeongjun on 2022/12/02.
//

import Foundation

extension UserDefaults {
    static var shared: UserDefaults {
        let appGroupId = "group.com.happyanding.HappyAnding"
        return UserDefaults(suiteName: appGroupId)!
    }
}

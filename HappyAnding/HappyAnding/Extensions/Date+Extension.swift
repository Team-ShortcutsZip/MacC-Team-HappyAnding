//
//  Date+Extension.swift
//  HappyAnding
//
//  Created by 전지민 on 2022/11/04.
//

import Foundation

extension Date {
    func getDate() -> String {
        let current = Date()
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_kr")
        formatter.timeZone = TimeZone(abbreviation: "KST")
        formatter.dateFormat = "yyyyMMddHHmmss"
        
        return formatter.string(from: current)
    }
}

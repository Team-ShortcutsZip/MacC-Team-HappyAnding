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

extension String {
    func getVersionUpdateDateFormat() -> String {
        var date = self.substring(from: 0, to: 7)
        let index1 = date.index(date.startIndex, offsetBy: 4)
        let index2 = date.index(date.startIndex, offsetBy: 6)
        date.insert(".", at: index2)
        date.insert(".", at: index1)
        
        return date
    }
}

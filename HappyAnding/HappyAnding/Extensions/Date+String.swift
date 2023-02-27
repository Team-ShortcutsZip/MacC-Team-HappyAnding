//
//  Date+Extension.swift
//  HappyAnding
//
//  Created by 전지민 on 2022/11/04.
//

import Foundation

extension Date {
    
    /// Date를 yyyyMMddHHmmss 형태의 String으로 변환해주는 함수입니다.
    func getDate() -> String {
        let current = Date()
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_kr")
        formatter.timeZone = TimeZone(abbreviation: "KST")
        formatter.dateFormat = "yyyyMMddHHmmss"
        
        return formatter.string(from: current)
    }
}



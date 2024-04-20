//
//  String+Date.swift
//  HappyAnding
//
//  Created by 이지원 on 2023/02/24.
//

import Foundation

/**
 Read Shortcut View의 업데이트 날짜를 보여주기 위한 확장입니다.
 */
extension String {
    
    // substring to string
    func substring(from: Int, to: Int) -> String {
        guard from < count, to >= 0, to - from >= 0 else {
            return ""
        }
        
        let startIndex = index(self.startIndex, offsetBy: from)
        let endIndex = index(self.startIndex, offsetBy: to + 1)
        
        return String(self[startIndex ..< endIndex])
    }
    
    /// firebase에 저장된 날짜 형식을 yyyy.mm.dd의 String 형태로 변환합니다.
    func getVersionUpdateDateFormat() -> String {
        var date = self.substring(from: 0, to: 7)
        let index1 = date.index(date.startIndex, offsetBy: 4)
        let index2 = date.index(date.startIndex, offsetBy: 6)
        date.insert(".", at: index2)
        date.insert(".", at: index1)
        
        return date
    }
    
    func getPostDateFormat() -> String? {
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyyMMddHHmmss"
        
        if let date = inputFormatter.date(from: self) {
            let outputFormatter = DateFormatter()
            outputFormatter.locale = Locale(identifier: "ko_KR")
            outputFormatter.dateFormat = "M월 d일 a h시 m분"
            
            let output = outputFormatter.string(from: date)
            return output
        } else {
            return nil
        }
    }
    func getVersionDateFormat() -> String? {
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyyMMddHHmmss"
        
        if let date = inputFormatter.date(from: self) {
            let outputFormatter = DateFormatter()
            outputFormatter.locale = Locale(identifier: "ko_KR")
            outputFormatter.dateFormat = "yyyy년 M월 d일"
            
            let output = outputFormatter.string(from: date)
            return output
        } else {
            return nil
        }
    }
}

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
    
    func getCommentDateFormat() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMMddHHmmss"
        
        let commentDateFormatter = DateFormatter()
        commentDateFormatter.dateFormat = "yyyy.MM.dd"
        
        guard let date = dateFormatter.date(from: self) else {
            return ""
        }
        
        let calendar = Calendar.current
        let currentDate = Date()
        
        let difference = calendar.dateComponents([.year, .month, .weekOfYear, .day, .hour, .minute], from: date, to: currentDate)
        
        if let years = difference.year, years > 0 {
            return commentDateFormatter.string(from: date)
        } else if let months = difference.month, months >= 11 {
            return commentDateFormatter.string(from: date)
        } else if let months = difference.month, months > 0 {
            return "\(months)개월 전"
        } else if let weeks = difference.weekOfYear, weeks > 0 {
            return "\(weeks)주 전"
        } else if let days = difference.day, days > 0 {
            return "\(days)일 전"
        } else if let hours = difference.hour, hours > 0 {
            return "\(hours)시간 전"
        } else if let minutes = difference.minute, minutes > 0 {
            return "\(minutes)분 전"
        } else {
            return "방금 전"
        }
    }
}

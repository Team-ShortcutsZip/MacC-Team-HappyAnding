//
//  String+Extension.swift
//  HappyAnding
//
//  Created by KiWoong Hong on 2022/11/15.
//

import SwiftUI

extension String {
    
    func isNormalString() -> Bool {
        let specialCharacters = "!@#$%^&*()~`_+-=[]{}|;':\",./<>? "
        var result = true
        
        for char in specialCharacters {
            if self.contains(char) {
                result = false
            }
        }
        return result
    }
    
    func checkCorrectNickname() -> Bool {
        let arr = Array(self)
        let pattern = "^[가-힣ㄱ-ㅎㅏ-ㅣa-zA-Z0-9_]$"
        if let regex = try? NSRegularExpression(pattern: pattern, options: .caseInsensitive) {
            var index = 0
            while index < arr.count {
                let results = regex.matches(in: String(arr[index]), options: [], range: NSRange(location: 0, length: 1))
                if results.count == 0 {
                    return false
                } else {
                    index += 1
                }
            }
        }
        return true
    }
}


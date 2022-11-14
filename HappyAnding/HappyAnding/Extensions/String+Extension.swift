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
}


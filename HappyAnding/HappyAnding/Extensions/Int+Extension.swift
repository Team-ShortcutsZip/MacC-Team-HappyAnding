//
//  Int+Extension.swift
//  HappyAnding
//
//  Created by JeonJimin on 4/25/24.
//

import Foundation

extension Int {
    /// Int 타입의 숫자를 받아서 천 단위로 콤마를 추가한 문자열을 반환
    func formatNumber() -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter.string(from: NSNumber(value: self)) ?? ""
    }
}

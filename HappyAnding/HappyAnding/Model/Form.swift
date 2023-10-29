//
//  Form.swift
//  HappyAnding
//
//  Created by HanGyeongjun on 10/29/23.
//

import Foundation

struct Form: Identifiable, Codable, Hashable {
    
    var id = UUID().uuidString
    var userInfo: String
    var dateTime = Date().getDate()
    var formContent: String
    
    var dictionary: [String: Any] {
        let data = (try? JSONEncoder().encode(self)) ?? Data()
        return (try? JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any]) ?? [:]
    }
    
    init(userInfo: String, formContent: String) {
        self.id = UUID().uuidString
        self.userInfo = userInfo
        self.dateTime = Date().getDate()
        self.formContent = formContent
    }
    
    init() {
        self.id = UUID().uuidString
        self.userInfo = ""
        self.dateTime = Date().getDate()
        self.formContent = ""
    }
}

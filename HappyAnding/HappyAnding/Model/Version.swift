//
//  Version.swift
//  HappyAnding
//
//  Created by 전지민 on 2022/11/30.
//

import Foundation

struct Version: Codable {
    var latestVersion: String
    var minimumVersion: String
    var description: String
    var title: String
    
    enum CodingKeys: String, CodingKey {
        case latestVersion = "latest_version"
        case minimumVersion = "minimum_version"
        case title, description
    }
}

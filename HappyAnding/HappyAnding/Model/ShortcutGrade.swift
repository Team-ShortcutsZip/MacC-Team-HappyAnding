//
//  ShortcutGrade.swift
//  HappyAnding
//
//  Created by 전지민 on 2023/02/28.
//

import Foundation

enum ShortcutGrade: Int {
    case level0 = 0
    case level1 = 1
    case level5 = 2
    case level10 = 3
    case level25 = 4
    case level50 = 5
    
    ///레벨 이름
    func fetchTitle() -> String {
        switch self {
        case.level0:
            return "Level 0"
        case.level1:
            return "Level 1"
        case.level5:
            return "Level 2"
        case.level10:
            return "Level 3"
        case.level25:
            return "Level 4"
        case.level50:
            return "Level 5"
        }
    }
    
    ///레벨 아이콘
    func fetchIcon() -> String {
        switch self {
        case.level0:
            return "person.crop.circle.fill"
        case.level1:
            return "level1Big"
        case.level5:
            return "level5Big"
        case.level10:
            return "level10Big"
        case.level25:
            return "level25Big"
        case.level50:
            return "level50Big"
        }
    }
    
    ///레벨에 대한 설명
    func fetchDescription() -> String {
        switch self {
        case.level0:
            return "기본 레벨이에요"
        case.level1:
            return "단축어를 1개 작성하면 얻어요"
        case.level5:
            return "단축어를 5개 작성하면 얻어요"
        case.level10:
            return "단축어를 10개 작성하면 얻어요"
        case.level25:
            return "단축어를 25개 작성하면 얻어요"
        case.level50:
            return "단축어를 50개 작성하면 얻어요"
        }
    }
}

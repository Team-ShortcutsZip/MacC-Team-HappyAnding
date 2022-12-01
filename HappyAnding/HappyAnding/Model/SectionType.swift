//
//  SectionType.swift
//  HappyAnding
//
//  Created by 이지원 on 2022/10/22.
//

import Foundation

enum SectionType: String {
    case download = "다운로드 순위"
    case popular = "사랑받는 단축어"
    case myShortcut = "내가 작성한 단축어"
    case myLovingShortcut = "좋아요한 단축어"
    case myDownloadShortcut = "다운로드한 단축어"
    
    var description: String {
        switch self {
        case .download:
            return "1위 ~ 100위"
        case .popular:
            return "💡 좋아요를 많이 받은 단축어들로 구성되어 있어요!"
        case .myShortcut:
            return ""
        case .myLovingShortcut:
            return "💗 내가 좋아요를 누른 단축어를 모아볼 수 있어요"
        case .myDownloadShortcut:
            return "💫 내가 다운로드한 단축어를 모아볼 수 있어요"
        }
    }
}


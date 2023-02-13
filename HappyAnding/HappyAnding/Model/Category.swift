//
//  Category.swift
//  HappyAnding
//
//  Created by 이지원 on 2022/10/22.
//

import Foundation

enum Category: String, CaseIterable {
    case lifestyle = "lifestyle"
    case health = "health"
    case sns = "sns"
    case utility = "utility"
    case business = "business"
    case photo = "photo"
    case education = "education"
    case finance = "finance"
    case weather = "weather"
    case decoration = "decoration"
    case entertainment = "entertainment"
    case trip = "trip"
    
    var category: String {
        String(describing: self)
    }
    
    static func withLabel(_ label: String) -> Category? {
        return self.allCases.first{ "\($0)" == label }
    }
    
    var index: Int {
        switch self {
        case .lifestyle: return 0
        case .health: return 1
        case .sns: return 2
        case .utility: return 3
        case .business: return 4
        case .photo: return 5
        case .education: return 6
        case .finance: return 7
        case .weather: return 8
        case .decoration: return 9
        case .entertainment: return 10
        case .trip: return 11
        }
    }
    
    // TODO: 설명 내용 수정하기
    
    /// 카테고리에 대한 짧은 소개를 반환하는 함수
    func fetchDescription() -> String {
        switch self {
        case .education:
            return "공부, 학업, 교육과 관련된 단축어들이 모여있어요"
        case .finance:
            return "모바일 뱅킹, 소비와 관련된 단축어들이 모여있어요"
        case .business:
            return "파일 관리, 클라우드와 관련된 단축어들이 모여있어요"
        case .health:
            return "운동, 건강정보와 관련된 단축어들이 모여있어요"
        case .lifestyle:
            return "일정관리, 취미와 관련된 단축어들이 모여있어요"
        case .weather:
            return "날씨정보와 관련된 단축어들이 모여있어요"
        case .photo:
            return "이미지 편집, 사진과 관련된 단축어들이 모여있어요"
        case .decoration:
            return "위젯 꾸미기, 화면 꾸미기와 관련된 단축어들이 모여있어요"
        case .utility:
            return "기본설정과 관련된 단축어들이 모여있어요"
        case .sns:
            return "커뮤니케이션과 관련된 단축어들이 모여있어요"
        case .entertainment:
            return "방송, 음악과 관련된 단축어들이 모여있어요"
        case .trip:
            return "지도, 예매와 관련된 단축어들이 모여있어요"
        }
    }
    
    
    func translateName() -> String {
        switch self {
        case .education:
            return "교육"
        case .finance:
            return "금융"
        case .business:
            return "비즈니스"
        case .health:
            return "건강 및 피트니스"
        case .lifestyle:
            return "라이프스타일"
        case .weather:
            return "날씨"
        case .photo:
            return "사진 및 비디오"
        case .decoration:
            return "데코레이션"
        case .utility:
            return "유틸리티"
        case .sns:
            return "소셜 네트워킹"
        case .entertainment:
            return "엔터테인먼트"
        case .trip:
            return "여행"
        }
    }
}

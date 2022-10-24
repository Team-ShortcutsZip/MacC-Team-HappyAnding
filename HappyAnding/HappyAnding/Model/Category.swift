//
//  Category.swift
//  HappyAnding
//
//  Created by 이지원 on 2022/10/22.
//

import Foundation

enum Category: String, CaseIterable {
    case education = "교육"
    case finance = "금융"
    case business = "비즈니스"
    case health = "건강"
    case lifestyle = "라이프스타일"
    case weather = "날씨"
    case photo = "사진 및 비디오"
    case decoration = "데코레이션 / 꾸미기"
    case utility = "유틸리티"
    case sns = "소셜 네트워킹"
    case entertainment = "엔터테인먼트"
    case trip = "여행"
    
    
    // TODO: 설명 내용 수정하기
    
    /// 카테고리에 대한 짧은 소개를 반환하는 함수
    func fetchDescription() -> String {
        switch self {
        case .education:
            return "공부, 학업 등 교육 등의 단축어들이 모여있어요"
        case .finance:
            return "모바일 뱅킹, 주식 등의 단축어들이 모여있어요"
        case .business:
            return "파일 정리, 파일 확장자 변환 등의 단축어들이 모여있어요"
        case .health:
            return "운동, 건강정보 등의 단축어들이 모여있어요"
        case .lifestyle:
            return "일기장, 집안 살림 등의 단축어들이 모여있어요"
        case .weather:
            return "일기예보, 미세먼지 등의 단축어들이 모여있어요"
        case .photo:
            return "이미지 편집기, 사진 촬영 등의 단축어들이 모여있어요"
        case .decoration:
            return "위젯 꾸미기, 화면 꾸미기 등의 단축어들이 모여있어요"
        case .utility:
            return "계산기, 압축해제 등의 단축어들이 모여있어요"
        case .sns:
            return "채팅 어플리케이션 등의 단축어들이 모여있어요"
        case .entertainment:
            return "아이돌, 음악 등의 단축어들이 모여있어요"
        case .trip:
            return "번역기, 예매 등의 단축어들이 모여있어요"
        }
    }
}

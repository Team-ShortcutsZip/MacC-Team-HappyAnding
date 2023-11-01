//
//  CurationType.swift
//  HappyAnding
//
//  Created by 이지원 on 2023/06/05.
//

import Foundation

enum CurationType {
    case myCuration
    case userCuration
    case personalCuration
    
    var title: String {
        switch self {
        case .myCuration:
            return TextLiteral.myPageViewMyCuration
        case .userCuration:
            return TextLiteral.exploreCurationViewUserCurations
        case .personalCuration:
            return "님을 위한 추천 모음집"
        }
    }

    func filterCuration(from viewModel: ShortcutsZipViewModel) -> [Curation] {
        switch self {
        case .myCuration:
            return viewModel.curationsMadeByUser
        case .userCuration:
            return viewModel.userCurations
        case .personalCuration:
            return viewModel.personalCurations
        }
    }
    
}

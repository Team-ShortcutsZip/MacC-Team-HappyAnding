//
//  ListCurationViewModel.swift
//  HappyAnding
//
//  Created by 이지원 on 2023/06/25.
//

import Foundation

final class ListCurationViewModel: ObservableObject {
    var shortcutsZipViewModel = ShortcutsZipViewModel.share
    
    @Published var curationType: CurationType
    @Published private(set) var curationList = [Curation]()
    @Published private(set) var sectionTitle: String = ""
    
    init(data: CurationType) {
        self.curationType = data
        self.curationList = curationType.filterCuration(from: shortcutsZipViewModel)
        self.sectionTitle = fetchSectionTitle()
        print("new viewModel: ", curationType, curationList)
    }
    
    private func fetchSectionTitle() -> String {
        switch curationType {
        case .personalCuration:
            return (shortcutsZipViewModel.userInfo?.nickname ?? "") + curationType.title
        default:
            return curationType.title
        }
    }
    
    func getEmptyContentsWording() -> String {
        "아직 \(sectionTitle)\(sectionTitle.contains("단축어") ? "가" : "이") 없어요"
    }
}

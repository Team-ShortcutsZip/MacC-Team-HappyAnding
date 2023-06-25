//
//  ExploreCurationViewModel.swift
//  HappyAnding
//
//  Created by 이지원 on 2023/06/25.
//

import Foundation

final class ExploreCurationViewModel: ObservableObject {
    var shortcutsZipViewModel = ShortcutsZipViewModel.share
    @Published var adminCurationList = [Curation]()
    @Published var personalCurationList = [Curation]()
    @Published var userCurationList = [Curation]()
    
    init() {
        fetchAdminCurationList()
    }
    
    private func fetchAdminCurationList() {
        self.adminCurationList = shortcutsZipViewModel.adminCurations
    }
    
    func getCurationList(with curationType: CurationType) -> [Curation] {
        curationType.filterCuration(from: shortcutsZipViewModel)
    }
    
    func getSectionTitle(with curationType: CurationType) -> String {
        switch curationType {
        case .personalCuration:
            return (shortcutsZipViewModel.userInfo?.nickname ?? "") + curationType.title
        default:
            return curationType.title
        }
    }
}

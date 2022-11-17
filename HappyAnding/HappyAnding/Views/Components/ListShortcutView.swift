//
//  ListShortcutView.swift
//  HappyAnding
//
//  Created by 이지원 on 2022/10/20.
//

import SwiftUI

/// - parameters:
/// - categoryName: 카테고리에서 접근할 시, 해당 카테고리의 이름을 넣어주시고, 그렇지 않다면 nil을 넣어주세요
/// sectionType: 다운로드 순위에서 접근할 시, .download를, 사랑받는 앱에서 접근시 .popular를 넣어주세요.
struct ListShortcutView: View {
    
    @EnvironmentObject var shortcutsZipViewModel: ShortcutsZipViewModel
    
    @State var shortcuts:[Shortcuts]?
//    @State var shortcutsArray: [Shortcuts] = []
    @State private var isLastItem = false
    @State var description: String = ""
    
    // TODO: let으로 변경필요, 현재 작업중인 코드들과 충돌될 가능성이 있어 우선 변수로 선언
    var categoryName: Category?
    var sectionType: SectionType?
    
    var body: some View {
        
        List {
            
            if sectionType != .myShortcut {
                header
                    .listRowBackground(Color.Background)
                    .listRowSeparator(.hidden)
                    .listRowInsets(EdgeInsets())
            }
            
            //TODO: 무한 스크롤을 위한 업데이트 함수 필요
            if let shortcuts {
                ForEach(Array(shortcuts.enumerated()), id: \.offset) { index, shortcut in
                    if sectionType == .download {
                        ShortcutCell(shortcut: shortcut, rankNumber: index + 1)
                            .listRowInsets(EdgeInsets())
                            .listRowSeparator(.hidden)
                        
                    } else {
                        ShortcutCell(shortcut: shortcut)
                            .listRowInsets(EdgeInsets())
                            .listRowSeparator(.hidden)
                    }
                }
            }
            
            
            Rectangle()
                .fill(Color.Background)
                .frame(height: 44)
                .listRowInsets(EdgeInsets())
                .listRowSeparator(.hidden)
        }
        .listRowBackground(Color.Background)
        .listStyle(.plain)
        .background(Color.Background.ignoresSafeArea(.all, edges: .all))
        .scrollContentBackground(.hidden)
        .navigationBarTitle((categoryName == nil ? getNavigationTitle(sectionType!) : categoryName?.translateName())!)
        .navigationBarTitleDisplayMode(.inline)
        .onAppear() {
            if let categoryName {
                description = categoryName.fetchDescription()
                shortcutsZipViewModel.fetchCategoryShortcutLimit(category: categoryName, orderBy: "date") { shortcuts in
                    self.shortcuts = shortcuts
                }
            } else if let sectionType {
                description = getDescriptions(sectionType)
            }
        }
    }
    
    var header: some View {
        
            // TODO: 추후 옵셔널 타입 삭제 (무조건 타입이 존재하기 때문)
        
        VStack {
            Text(description)
                .foregroundColor(.Gray5)
                .Body2()
                .padding(16)
                .frame(maxWidth: .infinity, alignment: sectionType == .download ? .center : .leading)
                .background(
                    Rectangle()
                        .foregroundColor(Color.Gray1)
                        .cornerRadius(12)
                )
                .listRowSeparator(.hidden)
                .listRowBackground(Color.Background)
        }
        .padding(.vertical, 20)
        .padding(.horizontal, 16)
    }
    
    
    private func getNavigationTitle(_ sectionType: SectionType) -> String {
        switch sectionType {
        case .download:
            return sectionType.rawValue
        case .popular:
            return "사랑받는 단축어"
        case .myShortcut:
            return "나의 단축어"
        case .myLovingShortcut:
            return "좋아요한 단축어"
        case .myDownloadShortcut:
            return "다운로드한 단축어"
        }
    }
    
    private func getDescriptions(_ sectionType: SectionType) -> String {
        switch sectionType {
        case .download:
            return "\(self.categoryName?.translateName() ?? "") 1위 ~ 100위"
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

struct ListShortcutView_Previews: PreviewProvider {
    static var previews: some View {
        ListShortcutView(sectionType: .myLovingShortcut)
    }
}

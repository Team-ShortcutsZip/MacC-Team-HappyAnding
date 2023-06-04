//
//  ExploreShortcutView.swift
//  HappyAnding
//
//  Created by 이지원 on 2022/10/19.
//

import SwiftUI

struct ExploreShortcutView: View {
    
    @EnvironmentObject var shortcutsZipViewModel: ShortcutsZipViewModel
    
    // TODO: 추후 UpdateInfoView 제작 시 true로 변경해서 cell 보이게 하기
    @AppStorage("isUpdateAnnnouncementShow") var isUpdateAnnnouncementShow: Bool = false
    
    @Binding var isCategoryCellViewFolded: Bool
    
    @State var isTappedAnnouncementCell = false
    @State private var numberOfDisplayedCategories = 6
    
    let randomCategories: [Category]
    
    var body: some View {
        ScrollView {
            VStack(spacing: 32) {
                if isUpdateAnnnouncementShow {
                    Button {
                        isTappedAnnouncementCell = true
                    } label: {
                        AnnouncementCell(icon: "updateAppIcon",
                                         tagName: TextLiteral.updateTag,
                                         discription: TextLiteral.updateCellDescription,
                                         isAnnouncementShow: $isUpdateAnnnouncementShow)
                    }
                    .id(000)
                }
                
                sectionView(with: .recent)
                    .id(111)
                
                categoryCardView(with: randomCategories[0])

                sectionView(with: .download)
                
                categoryCardView(with: randomCategories[1])
                
                sectionView(with: .popular)
                
                VStack {
                    HStack {
                        SubtitleTextView(text: TextLiteral.categoryViewTitle)
                        
                        Spacer()
                                        
                        Button(action: {
                            self.isFolded.toggle()
                        }, label: {
                            MoreCaptionTextView(text: isFolded ? TextLiteral.categoryViewUnfold : TextLiteral.categoryViewFold)
                        })
                        .onChange(of: isFolded) { _ in
                            categoryIndex = isFolded ? 6 : 12
                        }
                    }
                    .padding(.horizontal, 16)
                    
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())]) {
                        ForEach(Array(Category.allCases.enumerated()), id: \.offset) { index, value in
                            
                            let data = NavigationListCategoryShortcutType(shortcuts: [],
                                                                          categoryName: value,
                                                                          navigationParentView: .shortcuts)
                            
                            if index < categoryIndex {
                                
                                categoryCellView(with: value.translateName())
                                    .navigationLinkRouter(data: data)
                                
                            }
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.bottom, 16)
                    .id(999)
                }
            }
            .padding(.top, 20)
            .padding(.bottom, 44)
        }
        .scrollIndicators(.hidden)
        .navigationBarTitle(TextLiteral.exploreShortcutViewTitle)
        .navigationBarTitleDisplayMode(.large)
        .background(Color.shortcutsZipBackground)
        .toolbar {
            ToolbarItem {
                Image(systemName: "magnifyingglass")
                    .shortcutsZipHeadline()
                    .foregroundColor(.gray5)
                    .navigationLinkRouter(data: NavigationSearch.first)
            }
        }
        .navigationBarBackground ({ Color.shortcutsZipBackground })
        .sheet(isPresented: $isTappedAnnouncementCell) {
            UpdateInfoView()
                .presentationDetents([.large])
                .presentationDragIndicator(.visible)
        }
    }
    
}

// MARK: ViewBuilder
extension ExploreShortcutView {
    
    @ViewBuilder
    private func sectionView(with sectionType: SectionType) -> some View {
        
        let shortcuts = sectionType.filteredShortcuts(from: shortcutsZipViewModel)
        
        VStack(spacing: 0) {
            HStack {
                SubtitleTextView(text: sectionType.title)
                
                Spacer()
                
                MoreCaptionTextView(text: TextLiteral.more)
                    .navigationLinkRouter(data: NavigationListShortcutType(sectionType: sectionType,
                                                                           shortcuts: shortcuts,
                                                                           navigationParentView: .shortcuts))
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 12)
            
            ForEach(Array(shortcuts.enumerated()), id:\.offset) { index, shortcut in
                if index < 3 {
                    let data = NavigationReadShortcutType(shortcutID:shortcut.id,
                                                          navigationParentView: .shortcuts)
                    
                    ShortcutCell(shortcut: shortcut,
                                 rankNumber: index + 1,
                                 navigationParentView: .shortcuts)
                    .navigationLinkRouter(data: data)
                }
            }
            .background(Color.shortcutsZipBackground)
        }
    }
    
    @ViewBuilder
    private func categoryCardView(with category: Category) -> some View {
        
        VStack(spacing: 0) {
            HStack {

                SubtitleTextView(text: category.translateName())

                Spacer()

                MoreCaptionTextView(text: TextLiteral.more)
                    .navigationLinkRouter(data: NavigationListCategoryShortcutType(shortcuts: [],
                                                                                   categoryName: category,
                                                                                   navigationParentView: .shortcuts))
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 12)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(Array((shortcutsZipViewModel.shortcutsInCategory[randomCategories[0].index].enumerated())), id: \.offset) { index, shortcut in
                        if index < 7 {
                            let data = NavigationReadShortcutType(
                                shortcutID: shortcut.id,
                                navigationParentView: .shortcuts)

                            ShortcutCardCell(
                                categoryShortcutIcon: shortcut.sfSymbol,
                                categoryShortcutName: shortcut.title,
                                categoryShortcutColor: shortcut.color)
                            .navigationLinkRouter(data: data)
                        }
                    }
                }
                .padding(.horizontal, 16)
            }
        }
    }
    
    @ViewBuilder
    private func categoryCellView(with categoryName: String) -> some View {
        RoundedRectangle(cornerSize: CGSize(width: 12, height: 12))
            .strokeBorder(Color.gray1, lineWidth: 1)
            .background(Color.shortcutsZipWhite)
            .cornerRadius(12)
            .frame(maxWidth: .infinity, minHeight:48, maxHeight: 48)
            .overlay {
                Text(categoryName)
                    .shortcutsZipBody2()
                    .foregroundColor(Color.gray5)
            }
    }
}

struct ExploreShortcutView_Previews: PreviewProvider {
    static var previews: some View {
        ExploreShortcutView(isFolded: .constant(true), randomCategories: [Category.lifestyle, Category.utility])
    }
}


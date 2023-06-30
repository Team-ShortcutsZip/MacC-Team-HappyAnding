//
//  ExploreShortcutView.swift
//  HappyAnding
//
//  Created by 이지원 on 2022/10/19.
//

import SwiftUI

struct ExploreShortcutView: View {
    
    @StateObject var viewModel: ExploreShortcutViewModel
    
    // TODO: 추후 UpdateInfoView 제작 시 true로 변경해서 cell 보이게 하기
    @AppStorage("isUpdateAnnnouncementShow") var isUpdateAnnnouncementShow: Bool = false
    
    var body: some View {
        ScrollViewReader { proxy in
            ScrollView {
                VStack(spacing: 32) {
                    if isUpdateAnnnouncementShow {
                        Button {
                            viewModel.isShowingAnnouncement()
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
                    
                    categoryCardView(with: viewModel.randomCategories[0])
                    
                    sectionView(with: .download)
                    
                    categoryCardView(with: viewModel.randomCategories[1])
                    
                    sectionView(with: .popular)
                    
                    VStack {
                        HStack {
                            SubtitleTextView(text: TextLiteral.categoryViewTitle)
                            
                            Spacer()
                            
                            Button {
                                viewModel.changeNumberOfCategories()
                            } label: {
                                MoreCaptionTextView(text: viewModel.isCategoryCellViewFolded ? TextLiteral.categoryViewUnfold : TextLiteral.categoryViewFold)
                            }
                        }
                        .padding(.horizontal, 16)
                        
                        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())]) {
                            ForEach(Array(Category.allCases.enumerated()), id: \.offset) { index, value in
                                
                                if index < viewModel.numberOfDisplayedCategories {
                                    
                                    categoryCellView(with: value.translateName())
                                        .navigationLinkRouter(data: value)
                                    
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
            .onChange(of: viewModel.isCategoryCellViewFolded) { _ in
                withAnimation {
                    proxy.scrollTo(999, anchor: .bottom)
                }
            }
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
        .sheet(isPresented: $viewModel.isTappedAnnouncementCell) {
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
        
        let shortcuts = sectionType.filterShortcuts(from: viewModel.shortcutsZipViewModel)
        
        VStack(spacing: 0) {
            HStack {
                SubtitleTextView(text: sectionType.title)
                
                Spacer()
                
                MoreCaptionTextView(text: TextLiteral.more)
                    .navigationLinkRouter(data: sectionType)
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
                    .navigationLinkRouter(data: category)
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 12)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(viewModel.fetchShortcutsByCategories(category: category).prefix(7), id: \.self) { shortcut in
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


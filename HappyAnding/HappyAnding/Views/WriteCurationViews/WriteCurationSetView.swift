//
//  WriteCurationSetView.swift
//  HappyAnding
//
//  Created by 이지원 on 2022/10/19.
//

import SwiftUI

struct WriteCurationSetView: View {
    
    @EnvironmentObject var shortcutsZipViewModel: ShortcutsZipViewModel
    @EnvironmentObject var writeCurationNavigation: WriteCurationNavigation
    
    @Binding var isWriting: Bool
    
    @State var shortcutCells = [ShortcutCellModel]()
    @State var isSelected = false
    @Binding var curation: Curation
    @State var isTappedQuestionMark: Bool = false
    @State var deletedShortcutCells = [ShortcutCellModel]()
    
    let isEdit: Bool
    
    var body: some View {
        VStack {
            ProgressView(value: 1, total: 2)
                .padding(.bottom, 26)
            
            listHeader
            infomation
            if shortcutCells.isEmpty {
                Spacer()
                Text(TextLiteral.writeCurationSetViewNoShortcuts)
                    .shortcutsZipBody2()
                    .foregroundStyle(Color.gray4)
                    .multilineTextAlignment(.center)
                Spacer()
                
            } else {
                shortcutList
            }
        }
        .background(Color.shortcutsZipBackground)
        .navigationTitle(isEdit ? TextLiteral.writeCurationSetViewEdit : TextLiteral.writeCurationSetViewPost)
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            self.shortcutCells = shortcutsZipViewModel.fetchShortcutMakeCuration().sorted { $0.title < $1.title }
            if isEdit {
                deletedShortcutCells = curation.shortcuts
            }
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    self.isWriting.toggle()
                } label: {
                    Text(TextLiteral.cancel)
                        .shortcutsZipBody1()
                        .foregroundStyle(Color.gray4)
                }
            }
            
            ToolbarItem(placement: .navigationBarTrailing) {
                Text(TextLiteral.next)
                    .navigationLinkRouter(data: WriteCurationInfoType(curation: curation, deletedShortcutCells: deletedShortcutCells, isEdit: isEdit), isPresented: $isWriting)
                    .shortcutsZipHeadline()
                    .foregroundStyle(curation.shortcuts.isEmpty ? Color.shortcutsZipPrimary.opacity(0.3) : Color.shortcutsZipPrimary)
                    .disabled(curation.shortcuts.isEmpty)
            }
        }
    }
    
    ///단축어 선택 텍스트 및 카운터
    var listHeader: some View {
        HStack(alignment: .bottom, spacing: 8) {
            Text(TextLiteral.writeCurationSetViewSelectionTitle)
                .shortcutsZipSb()
                .foregroundStyle(Color.gray5)
            Text(TextLiteral.writeCurationSetViewSelectionDescription)
                .shortcutsZipFootnote()
                .foregroundStyle(Color.gray3)
            Spacer()
            Text("\(curation.shortcuts.count)개")
                .shortcutsZipBody2()
                .foregroundStyle(Color.shortcutsZipPrimary)
        }
        .padding(.horizontal, 16)
    }
    
    ///내가 작성한, 좋아요를 누른 단축어 목록
    var shortcutList: some View {
        
        ScrollView {
            ForEach(Array(shortcutCells)) { shortcut in
                CheckBoxShortcutCell(
                    selectedShortcutCells: $curation.shortcuts, isShortcutTapped: curation.shortcuts.contains(shortcut),
                    shortcutCell: shortcut
                )
            }
        }
        .frame(maxWidth: .infinity)
        .scrollIndicators(.hidden)
    }
    
    // MARK: - 안내문구
    var infomation: some View {
        Text(TextLiteral.writeCurationSetViewSelectionInformation)
            .frame(maxWidth: .infinity, alignment: .leading)
            .shortcutsZipBody2()
            .foregroundStyle(Color.gray5)
            .padding(.all, 16)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.gray1)
            )
            .padding(.horizontal, 16)
            .padding(.bottom, 20)
    }
}

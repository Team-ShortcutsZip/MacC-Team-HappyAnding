//
//  WriteCurationSetView.swift
//  HappyAnding
//
//  Created by 이지원 on 2022/10/19.
//

import SwiftUI

struct WriteCurationSetView: View {
    
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var shortcutsZipViewModel: ShortcutsZipViewModel
    
    @Binding var isWriting: Bool
    
    @State var shortcutCells = Set<ShortcutCellModel>()
    @State var isSelected = false
    @State var curation = Curation(title: "",
                                   subtitle: "",
                                   isAdmin: false,
                                   background: "White",
                                   author: "",
                                   shortcuts: [ShortcutCellModel]())
    
    let isEdit: Bool
    let navigationParentView: NavigationParentView
    
    var body: some View {
        VStack() {
            
            ProgressView(value: 1, total: 2)
                .padding(.bottom, 36)
            
            listHeader
            
            ScrollView {
                shortcutList
            }
            
            bottomButton
        }
        .background(Color.Background)
        .navigationTitle(isEdit ? "나의 큐레이션 편집" : "나의 큐레이션 만들기")
        .navigationBarTitleDisplayMode(.inline)
        .navigationDestination(for: Float.self) { isEdit in
            WriteCurationInfoView(curation: curation,
                                  isWriting: $isWriting,
                                  isEdit: self.isEdit,
                                  navigationParentView: self.navigationParentView)
        }
        .onAppear() {
            shortcutsZipViewModel.fetchMadeShortcutCell { shortcuts in
                self.shortcutCells = self.shortcutCells.union(shortcuts)
            }
            shortcutsZipViewModel.fetchLikedShortcutCell { shortcuts in
                self.shortcutCells = self.shortcutCells.union(shortcuts)
            }
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                if isEdit {
                    Button {
                        self.presentationMode.wrappedValue.dismiss()
                    } label: {
                        Text("닫기")
                    }
                }
            }
        }
    }
    
    ///단축어 선택 텍스트 및 카운터
    var listHeader: some View {
        HStack(alignment: .bottom) {
            Text("단축어 선택")
                .Headline()
                .foregroundColor(.Gray5)
            Text("최대 10개 선택")
                .Footnote()
                .foregroundColor(.Gray3)
            Spacer()
            Text("\(curation.shortcuts.count)개")
                .Body2()
                .foregroundColor(.Primary)
        }
        .padding(.horizontal, 16)
        .padding(.bottom, 20)
    }
    
    ///내가 작성한, 좋아요를 누른 단축어 목록
    var shortcutList: some View {
        ForEach(Array(shortcutCells)) { shortcut in
            CheckBoxShortcutCell(
                isShortcutTapped: curation.shortcuts.contains(shortcut),
                selectedShortcutCells: $curation.shortcuts,
                shortcutCell: shortcut
            )
        }
    }
    
    ///완료 버튼
    var bottomButton: some View {
        
        NavigationLink(value: Float(0.0)) {
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .foregroundColor(curation.shortcuts.count > 0 ? .Primary : .Gray1)
                    .padding(.horizontal, 16)
                    .frame(height: 52)
                Text("다음")
                    .foregroundColor(curation.shortcuts.count > 0 ? .Text_Button : .Text_Button_Disable)
            }
        }
        .padding(.bottom, 24)
        .disabled(curation.shortcuts.count == 0)
    }
}

struct WriteCurationSetView_Previews: PreviewProvider {
    static var previews: some View {
        WriteCurationSetView(isWriting: .constant(false),
                             isEdit: false,
                             navigationParentView: .curations)
    }
}

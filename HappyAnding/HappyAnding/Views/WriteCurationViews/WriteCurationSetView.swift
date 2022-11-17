//
//  WriteCurationSetView.swift
//  HappyAnding
//
//  Created by 이지원 on 2022/10/19.
//

import SwiftUI

struct WriteCurationSetView: View {
    
    @EnvironmentObject var shortcutsZipViewModel: ShortcutsZipViewModel
    @EnvironmentObject var curationNavigation: CurationNavigation
    @EnvironmentObject var profileNavigation: ProfileNavigation
    @EnvironmentObject var editCurationNavigation: EditCurationNavigation
    
    @Binding var isWriting: Bool
    
    @State var shortcutCells = Set<ShortcutCellModel>()
    @State var isSelected = false
    @State var curation = Curation(title: "",
                                   subtitle: "",
                                   isAdmin: false,
                                   background: "White",
                                   author: "",
                                   shortcuts: [ShortcutCellModel]())
    @State var isTappedQuestionMark: Bool = false
    
    let isEdit: Bool
    let navigationParentView: NavigationParentView
    
    var body: some View {
        ZStack {
            VStack {
                ProgressView(value: 1, total: 2)
                    .padding(.bottom, 36)
                
                listHeader
                
                if shortcutCells.isEmpty {
                    VStack {
                        Spacer()
                        Text("아직 선택할 수 있는 단축어가 없어요.\n단축어를 업로드하거나 좋아요를 눌러주세요:)")
                            .Body2()
                            .foregroundColor(.Gray4)
                            .multilineTextAlignment(.center)
                        Spacer()
                        
                    }
                } else {
                    ScrollView {
                        shortcutList
                    }
                }
                
                bottomButton
                
            }
            .background(Color.Background)
            .navigationTitle(isEdit ? "큐레이션 편집" : "큐레이션 만들기")
            .navigationBarTitleDisplayMode(.inline)
            .navigationDestination(for: Float.self) { isEdit in
                WriteCurationInfoView(curation: $curation,
                                      isWriting: self.$isWriting,
                                      isEdit: self.isEdit,
                                      navigationParentView: self.navigationParentView)
            }
            .onAppear {
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
                            self.isWriting.toggle()
                        } label: {
                            Text("닫기")
                        }
                    }
                }
            }
            
            if isTappedQuestionMark {
                VStack {
                    infomation
                        .padding(.top, 76)
                    Spacer()
                }
            }
            
        }
    }
    
    ///단축어 선택 텍스트 및 카운터
    var listHeader: some View {
        HStack(alignment: .bottom, spacing: 0) {
            Text("단축어 선택")
                .Headline()
                .foregroundColor(.Gray5)
                .padding(.trailing, 12)
            Text("최대 10개 선택")
                .Footnote()
                .foregroundColor(.Gray3)
            Spacer()
            Text("\(curation.shortcuts.count)개")
                .Body2()
                .foregroundColor(.Primary)
                .padding(.trailing, 8)
            Image(systemName: "questionmark.circle")
                .foregroundColor(Color.Gray5)
                .frame(width: 20, height: 20)
                .onTapGesture {
                    isTappedQuestionMark.toggle()
                }
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
    
    //안내문구 팝업
    var infomation: some View {
        HStack (alignment: .top) {
            Text("큐레이션은 ‘내가 업로드한 단축어’와 ‘좋아요를 누른 단축어’로 구성할 수 있습니다.")
                .Body2()
                .foregroundColor(.Gray5)
            Spacer()
            Image(systemName: "xmark")
                .foregroundColor(.Gray5)
                .frame(width: 16, height: 16)
                .onTapGesture {
                    isTappedQuestionMark = false
                }
        }
        .padding(.all, 16)
        .background(Color.Gray1)
        .cornerRadius(12)
        .frame(height: 72)
        .padding(.horizontal, 16)
    }
}

struct WriteCurationSetView_Previews: PreviewProvider {
    static var previews: some View {
        WriteCurationSetView(isWriting: .constant(false),
                             isEdit: false,
                             navigationParentView: .curations)
    }
}

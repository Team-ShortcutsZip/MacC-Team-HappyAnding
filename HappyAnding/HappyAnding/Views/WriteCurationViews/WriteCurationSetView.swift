//
//  WriteCurationSetView.swift
//  HappyAnding
//
//  Created by 이지원 on 2022/10/19.
//

import SwiftUI

struct WriteCurationSetView: View {
    
    @Binding var isWriting: Bool
    
    //TODO: 데이터 모델 제작 후 해당 ObservedObject 삭제 필요.
    @ObservedObject var shortcutData = fetchData()
    
    
    // TODO: firebase 함수로 결괏값 가져오면, 그 배열의 길이를 넣어야함!
    @State var shortcuts: [ShortcutCellModel] = []
    @State var isSelected = false
    @State var curation = Curation(title: "",
                                   subtitle: "",
                                   isAdmin: false,
                                   background: "White",
                                   author: "",
                                   shortcuts: [ShortcutCellModel]())
    
    let firebase = FirebaseService()
    let isEdit: Bool
    
    var body: some View {
        NavigationStack {
            VStack() {
                HStack {
                    Button(action: {
                        isWriting.toggle()
                    }, label: {
                        Image(systemName: "chevron.left")
                            .foregroundColor(.Gray4)
                            .Title2()
                    })
                    .frame(alignment: .leading)
                    
                    Text(isEdit ? "나의 큐레이션 편집" : "나의 큐레이션 만들기")
                        .font(.headline)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .fixedSize(horizontal: false, vertical: true)
                    Image(systemName: "chevron.left")
                        .foregroundColor(Color(UIColor.clear))
                        .Title2()
                }
                .padding(.top, 12)
                .padding(.horizontal, 16)
                ProgressView(value: 1, total: 2)
                    .padding(.bottom, 36)
                listHeader
                ScrollView {
                    shortcutList
                }
                
                bottomButton
            }
            .background(Color.Background)
            .onAppear() {
                firebase.fetchShortcutCell { shortcuts in
                    self.shortcuts = shortcuts
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
        ForEach(Array(shortcuts.enumerated()), id: \.offset) { index, shortcut in
            CheckBoxShortcutCell(
                isShortcutTapped: curation.shortcuts.contains(shortcut),
                selectedShortcut: $curation.shortcuts,
                shortcut: shortcut)
        }
//        ForEach(0..<10, id: \.self) { index in
//            CheckBoxShortcutCell(isShortcutTapped: isSelected[index], numberOfSelected: $numberOfSelected, selectedShortcut: $selectedShortcut, color: self.shortcutData.data[index].color,
//                         sfSymbol: self.shortcutData.data[index].sfSymbol,
//                         name: self.shortcutData.data[index].name,
//                         description: self.shortcutData.data[index].description)
//        }
    }
    
    ///완료 버튼
    var bottomButton: some View {
        
        NavigationLink {
            WriteCurationInfoView(curation: curation, isWriting: $isWriting, isEdit: isEdit)
            
        } label: {
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .foregroundColor(curation.shortcuts.count > 0 ? .Primary : .Gray1)
                    .padding(.horizontal, 16)
                    .frame(height: 52)
                Text("다음")
                    .foregroundColor(curation.shortcuts.count > 0 ? .Background : .Gray3)
            }
        }
        .padding(.bottom, 24)
        .disabled(curation.shortcuts.count == 0)
    }
}

struct WriteCurationSetView_Previews: PreviewProvider {
    static var previews: some View {
        WriteCurationSetView(isWriting: .constant(false), isEdit: false)
    }
}

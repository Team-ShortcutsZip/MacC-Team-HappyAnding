//
//  WriteShortcutdescriptionView.swift
//  HappyAnding
//
//  Created by 이지원 on 2022/10/19.
//

import SwiftUI

struct WriteShortcutdescriptionView: View {
    
    @Binding var shortcut: Shortcuts
    @Binding var isWriting: Bool
    
    @State var isOneLineValid = false
    @State var isMultiLineValid = false
    
    let isEdit: Bool
    let navigationParentView: NavigationParentView
    
    enum NavigationWriteTagView: Hashable, Equatable {
        case first
    }
    
    var body: some View {
        VStack {
            ProgressView(value: 0.66, total: 1)
                .padding(.bottom, 36)
            
            ValidationCheckTextField(textType: .mandatory,
                                     isMultipleLines: false,
                                     title: "한줄 설명",
                                     placeholder: "간단하게 설명을 작성해주세요",
                                     lengthLimit: 35,
                                     isDownloadLinkTextField: false,
                                     content: $shortcut.subtitle,
                                     isValid: $isOneLineValid
            )
            
            ValidationCheckTextField(textType: .mandatory,
                                     isMultipleLines: true,
                                     title: "설명",
                                     placeholder: "단축어에 대한 설명을 작성해주세요\n\n예시)\n- 이럴때 사용하면 좋아요\n- 이 단축어는 이렇게 사용해요",
                                     lengthLimit: 500,
                                     isDownloadLinkTextField: false,
                                     content: $shortcut.description,
                                     isValid: $isMultiLineValid
            )
            
            Spacer()
            
            NavigationLink(value: NavigationWriteTagView.first) {
                ZStack {
                    RoundedRectangle(cornerRadius: 12)
                        .foregroundColor(isOneLineValid && isMultiLineValid ? .Primary : .Gray1 )
                        .frame(maxWidth: .infinity, maxHeight: 52)
                    
                    Text("다음")
                        .foregroundColor(isOneLineValid && isMultiLineValid ? .Text_icon : .Text_Button_Disable )
                        .Body1()
                }
            }
            
            .disabled(!isOneLineValid || !isMultiLineValid)
            .padding(.horizontal, 16)
            .padding(.bottom, 24)
        }
        .navigationDestination(for: NavigationWriteTagView.self) { value in
            WriteShortcutTagView(isWriting: $isWriting,
                                 shortcut: $shortcut,
                                 isEdit: isEdit,
                                 navigationParentView: self.navigationParentView)
        }
        .navigationTitle(isEdit ? "단축어 편집" : "단축어 등록")
        .ignoresSafeArea(.keyboard)
        .background(Color.Background)
    }
}
/*
struct WriteShortcutdescriptionView_Previews: PreviewProvider {
    static var previews: some View {
        WriteShortcutdescriptionView(isWriting: .constant(true), isEdit: false)
    }
}
*/

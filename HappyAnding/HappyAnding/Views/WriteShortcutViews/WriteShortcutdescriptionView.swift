//
//  WriteShortcutdescriptionView.swift
//  HappyAnding
//
//  Created by 이지원 on 2022/10/19.
//

import SwiftUI

struct WriteShortcutdescriptionView: View {
    @Binding var isWriting: Bool
    
    @State var oneLineDescription = ""
    @State var multiLineDescription = ""
    
    @State var isOneLineValid = false
    @State var isMultiLineValid = false
    
    var body: some View {
        VStack {
            ProgressView(value: 0.66, total: 1)
                .padding(.bottom, 36)
            
            ValidationCheckTextField(textType: .mandatory,
                                     isMultipleLines: false,
                                     title: "한줄 설명",
                                     placeholder: "간단하게 설명을 작성해주세요",
                                     lengthLimit: 20,
                                     content: $oneLineDescription,
                                     isValid: $isOneLineValid
            )
            
            ValidationCheckTextField(textType: .mandatory,
                                     isMultipleLines: true,
                                     title: "설명",
                                     placeholder: "단축어에 대한 설명을 작성해주세요\n\n예시)\n- 이럴때 사용하면 좋아요\n- 이 단축어는 이렇게 사용해요",
                                     lengthLimit: 500,
                                     content: $multiLineDescription,
                                     isValid: $isMultiLineValid
            )
            
            Spacer()
            
            NavigationLink {
                WriteShortcutTagView(isWriting: $isWriting)
            } label: {
                ZStack {
                    RoundedRectangle(cornerRadius: 12)
                        .foregroundColor(isOneLineValid && isMultiLineValid ? .Primary : .Gray1 )
                        .frame(maxWidth: .infinity, maxHeight: 52)
                    
                    Text("다음")
                        .foregroundColor(isOneLineValid && isMultiLineValid ? .Background : .Gray3 )
                        .Body1()
                }
            }
            .disabled(!isOneLineValid || !isMultiLineValid)
            .padding(.horizontal, 16)
            .padding(.bottom, 24)
        }
        .navigationTitle("단축어 등록")
        .ignoresSafeArea(.keyboard)
    }
}

struct WriteShortcutdescriptionView_Previews: PreviewProvider {
    static var previews: some View {
        WriteShortcutdescriptionView(isWriting: .constant(true))
    }
}

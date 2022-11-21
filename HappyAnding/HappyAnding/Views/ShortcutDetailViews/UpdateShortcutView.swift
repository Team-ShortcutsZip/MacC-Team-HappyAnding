//
//  UpdateShortcutView.swift
//  HappyAnding
//
//  Created by kimjimin on 2022/11/21.
//

import SwiftUI

struct UpdateShortcutView: View {
    @Binding var isUpdating: Bool
    @Binding var shortcut: Shortcuts?
    
    @State var updatedLink = ""
    @State var updateDescription = ""
    @State var isLinkValid = false
    @State var isDescriptionValid = false
    
    var body: some View {
        VStack {
            HStack {
                Button(action: {
                    isUpdating.toggle()
                }, label: {
                    Text("취소")
                        .foregroundColor(.Gray5)
                })
                .frame(maxWidth: .infinity, alignment: .leading)
                
                Text("업데이트")
                    .font(.headline)
                    .frame(maxWidth: .infinity, alignment: .center)
                
                Text("")
                    .frame(maxWidth: .infinity, alignment: .trailing)
            }
            .padding(.top, 12)
            .padding(.horizontal, 16)
            ValidationCheckTextField(textType: .mandatory,
                                     isMultipleLines: false,
                                     title: "업데이트된 단축어 링크",
                                     placeholder: "업데이트된 단축어 링크를 추가하세요",
                                     lengthLimit: 100,
                                     isDownloadLinkTextField: true,
                                     content: $updatedLink,
                                     isValid: $isLinkValid
            )
            .onAppear(perform : UIApplication.shared.hideKeyboard)
            .padding(.top, 30)
            
            ValidationCheckTextField(textType: .mandatory,
                                     isMultipleLines: false,
                                     title: "업데이트 설명",
                                     placeholder: "업데이트된 내용을 입력해주세요",
                                     lengthLimit: 50,
                                     isDownloadLinkTextField: false,
                                     content: $updateDescription,
                                     isValid: $isDescriptionValid
            )
            
            Spacer()
            
            Button(action: {
                
                // TODO: updatedLink, updateDescription을 shortcut에 저장
                
                isUpdating.toggle()
            }, label: {
                ZStack {
                    RoundedRectangle(cornerRadius: 12)
                        .foregroundColor(isLinkValid && isDescriptionValid ? .Primary : .Primary.opacity(0.13))
                        .frame(maxWidth: .infinity, maxHeight: 52)
                    
                    Text("업데이트")
                        .foregroundColor(isLinkValid && isDescriptionValid ? .Text_Button : .Text_Button_Disable)
                        .Body1()
                }
            })
            .disabled(!isLinkValid || !isDescriptionValid)
            .padding(.horizontal, 16)
            .padding(.bottom, 24)
        }
        .background(Color.Background)
    }
}

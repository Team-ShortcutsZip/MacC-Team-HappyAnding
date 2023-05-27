//
//  UpdateShortcutView.swift
//  HappyAnding
//
//  Created by kimjimin on 2022/11/21.
//

import SwiftUI

struct UpdateShortcutView: View {
    @EnvironmentObject var shortcutsZipViewModel: ShortcutsZipViewModel
    
    @FocusState var focusedField: String?
    
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
                    Text(TextLiteral.cancel)
                        .foregroundColor(.gray5)
                })
                .frame(maxWidth: .infinity, alignment: .leading)
                
                Text(TextLiteral.update)
                    .font(.headline)
                    .frame(maxWidth: .infinity, alignment: .center)
                
                Text("")
                    .frame(maxWidth: .infinity, alignment: .trailing)
            }
            .padding(.top, 12)
            .padding(.horizontal, 16)
            ValidationCheckTextField(textType: .mandatory,
                                     isMultipleLines: false,
                                     title: TextLiteral.updateShortcutViewLinkTitle,
                                     placeholder: TextLiteral.updateShortcutViewLinkPlaceholder,
                                     lengthLimit: 100,
                                     isDownloadLinkTextField: true,
                                     content: $updatedLink,
                                     isValid: $isLinkValid
            )
            .onSubmit {
                focusedField = "updateDescription"
            }
            .submitLabel(.next)
            .onAppear(perform : UIApplication.shared.hideKeyboard)
            .padding(.top, 30)
            
            ValidationCheckTextField(textType: .mandatory,
                                     isMultipleLines: false,
                                     title: TextLiteral.updateShortcutViewDescriptionTitle,
                                     placeholder: TextLiteral.updateShortcutViewDescriptionPlaceholder,
                                     lengthLimit: 50,
                                     isDownloadLinkTextField: false,
                                     content: $updateDescription,
                                     isValid: $isDescriptionValid
            )
            .focused($focusedField, equals: "updateDescription")
            
            Spacer()
            
            Button(action: {
                if let shortcut {
                    shortcutsZipViewModel.updateShortcutVersion(shortcut: shortcut, updateDescription: updateDescription, updateLink: updatedLink)
                }
                isUpdating.toggle()
            }, label: {
                ZStack {
                    RoundedRectangle(cornerRadius: 12)
                        .foregroundColor(isLinkValid && isDescriptionValid ? .shortcutsZipPrimary : .shortcutsZipPrimary.opacity(0.13))
                        .frame(maxWidth: .infinity, maxHeight: 52)
                    Text(TextLiteral.update)
                        .foregroundColor(isLinkValid && isDescriptionValid ? .textButton : .textButtonDisable)
                        .shortcutsZipBody1()
                }
            })
            .disabled(!isLinkValid || !isDescriptionValid)
            .padding(.horizontal, 16)
            .padding(.bottom, 24)
        }
        .background(Color.shortcutsZipBackground)
    }
}

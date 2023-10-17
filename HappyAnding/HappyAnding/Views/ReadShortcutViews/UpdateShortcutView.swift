//
//  UpdateShortcutView.swift
//  HappyAnding
//
//  Created by kimjimin on 2022/11/21.
//

import SwiftUI

struct UpdateShortcutView: View {
    
    @StateObject var viewModel: ReadShortcutViewModel
    
    @FocusState var isDescriptionFieldFocused: Bool
    
    var body: some View {
        VStack {
            HStack {
                Button {
                    viewModel.isUpdatingShortcut.toggle()
                } label: {
                    Text(TextLiteral.cancel)
                        .foregroundStyle(Color.gray5)
                }
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
                                     content: $viewModel.updatedLink,
                                     isValid: $viewModel.isLinkValid
            )
            .onSubmit {
                isDescriptionFieldFocused = true
            }
            .submitLabel(.next)
            .onAppear(perform: UIApplication.shared.hideKeyboard)
            .padding(.top, 30)
            
            ValidationCheckTextField(textType: .mandatory,
                                     isMultipleLines: false,
                                     title: TextLiteral.updateShortcutViewDescriptionTitle,
                                     placeholder: TextLiteral.updateShortcutViewDescriptionPlaceholder,
                                     lengthLimit: 50,
                                     isDownloadLinkTextField: false,
                                     content: $viewModel.updateDescription,
                                     isValid: $viewModel.isDescriptionValid
            )
            .focused($isDescriptionFieldFocused)
            
            Spacer()
            
            Button {
                viewModel.updateShortcut()
            } label: {
                ZStack {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(viewModel.isUpdateValid ? Color.shortcutsZipPrimary : Color.shortcutsZipPrimary.opacity(0.13))
                        .frame(maxWidth: .infinity, maxHeight: 52)
                    Text(TextLiteral.update)
                        .foregroundStyle(viewModel.isUpdateValid ? Color.textButton : Color.textButtonDisable)
                        .shortcutsZipBody1()
                }
            }
            .disabled(!viewModel.isUpdateValid)
            .padding(.horizontal, 16)
            .padding(.bottom, 24)
        }
        .background(Color.shortcutsZipBackground)
    }
}

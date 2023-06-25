//
//  WriteCurationInfoView.swift
//  HappyAnding
//
//  Created by 이지원 on 2022/10/19.
//

import SwiftUI

struct WriteCurationInfoView: View {
    @StateObject var viewModel: WriteCurationViewModel
    
    @FocusState var isDescriptionFieldFocused: Bool
    
    var body: some View {
        VStack(spacing: 24) {
            ProgressView(value: 2, total: 2)
            
            ValidationCheckTextField(textType: .mandatory,
                                     isMultipleLines: false,
                                     title: TextLiteral.writeCurationInfoViewNameTitle,
                                     placeholder: TextLiteral.writeCurationInfoViewNamePlaceholder,
                                     lengthLimit: 20,
                                     isDownloadLinkTextField: false,
                                     content: $viewModel.curation.title,
                                     isValid: $viewModel.isValidTitle)
            .padding(.top, 12)
            .onSubmit {
                isDescriptionFieldFocused = true
            }
            .submitLabel(.next)
            
            ValidationCheckTextField(textType: .mandatory,
                                     isMultipleLines: true,
                                     title: TextLiteral.writeCurationInfoViewDescriptionTitle,
                                     placeholder: TextLiteral.writeCurationInfoViewDescriptionPlaceholder,
                                     lengthLimit: 40,
                                     isDownloadLinkTextField: false,
                                     inputHeight: 72,
                                     content: $viewModel.curation.subtitle,
                                     isValid: $viewModel.isValidDescription)
            .focused($isDescriptionFieldFocused)
            
            Spacer()
                .frame(maxHeight: .infinity)
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    viewModel.addCuration()
                } label: {
                    Text(TextLiteral.upload)
                        .shortcutsZipHeadline()
                        .foregroundColor(viewModel.isIncomplete ? .shortcutsZipPrimary.opacity(0.3) : .shortcutsZipPrimary)
                }
                .disabled(viewModel.isIncomplete)
            }
        }
        .background(Color.shortcutsZipBackground)
        .navigationBarTitle(viewModel.isEdit ? TextLiteral.writeCurationInfoViewEdit : TextLiteral.wrietCurationInfoViewPost)
        .onAppear(perform : UIApplication.shared.hideKeyboard)
    }
}

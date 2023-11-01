//
//  SuggestionFormView.swift
//  HappyAnding
//
//  Created by HanGyeongjun on 10/23/23.
//

import SwiftUI

struct SuggestionFormView: View {
        
    enum Field: Hashable {
        case text
    }
    
    @StateObject var viewModel: SuggestionFormViewModel
    
    @FocusState var focusState: Bool
    @State var formText: String = ""
    @State var isFormSendSuccess: Bool = false
    
    var body: some View {
        VStack(spacing: 0) {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    Text(TextLiteral.SuggestionFormViewTitle)
                        .shortcutsZipTitle1()
                        .foregroundStyle(Color.gray6)
                    Text(TextLiteral.SuggestionFormViewSubTitle)
                        .shortcutsZipHeadline()
                        .foregroundStyle(Color.gray4)
                    
                    if (isFormSendSuccess) {
                        HStack {
                            Spacer()
                            VStack(alignment: .center, spacing: 16) {
                                Image(systemName: "checkmark.circle.fill")
                                    .largeShortcutIcon()
                                    .foregroundStyle(Color.shortcutsZipSuccess)
                                Text(TextLiteral.SuggestionFormViewSuccessMessage)
                                    .shortcutsZipHeadline()
                                    .foregroundStyle(Color.gray4)
                            }
                            .padding(.all, 16)
                            .background( Color.gray1 )
                            .cornerRadius(16)
                            Spacer()
                        }
                    } else {
                        TextField(TextLiteral.SuggestionFormViewTextPlaceholder, text: $formText, axis: .vertical)
                            .shortcutsZipBody1()
                            .padding(.horizontal, 12)
                            .padding(.vertical, 16)
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .strokeBorder(lineWidth: 1)
                                    .foregroundStyle(Color.gray4)
                            )
                            .cornerRadius(12, corners: .allCorners)
                            .lineLimit(5)
                            .focused($focusState, equals: true)
                    }
                    
                }
                .padding(.top, 40)
                .padding(16)
            }
            .onAppear() {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    self.focusState = true
                }
            }
            
            Button {
                viewModel.uploadUserForm(formContent: formText)
                formText = ""
                isFormSendSuccess = true
            } label: {
                Text(TextLiteral.confirm)
                    .shortcutsZipBody1()
                    .fontWeight(.semibold)
                    .foregroundStyle( Color.textIcon )
                    .padding(.vertical, 16)
                    .frame(maxWidth: .infinity)
                    .background( formText.isEmpty ? Color.gray3 : Color.shortcutsZipPrimary )
                
            }
            .disabled(formText.isEmpty)
        }
        .background( Color.shortcutsZipBackground )
        .onTapGesture {
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        }
    }
}

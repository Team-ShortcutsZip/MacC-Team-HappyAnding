//
//  WriteCurationInfoView.swift
//  HappyAnding
//
//  Created by 이지원 on 2022/10/19.
//

import SwiftUI

struct WriteCurationInfoView: View {
    
    @EnvironmentObject var shortcutsZipViewModel: ShortcutsZipViewModel
    @EnvironmentObject var writeCurationNavigation: WriteCurationNavigation
    
    @FocusState var focusedField: String?
    
    @State var data: WriteCurationInfoType
    @Binding var isWriting: Bool
    
    @State var isValidTitle = false
    @State var isValidDescription = false
    
    private var isIncomplete: Bool {
        !(isValidTitle && isValidDescription)
    }
    
    var body: some View {
        VStack(spacing: 24) {
            ProgressView(value: 2, total: 2)
            
            ValidationCheckTextField(textType: .mandatory,
                                     isMultipleLines: false,
                                     title: TextLiteral.writeCurationInfoViewNameTitle,
                                     placeholder: TextLiteral.writeCurationInfoViewNamePlaceholder,
                                     lengthLimit: 20,
                                     isDownloadLinkTextField: false,
                                     content: $data.curation.title,
                                     isValid: $isValidTitle)
            .padding(.top, 12)
            .onSubmit {
                focusedField = "curationDescription"
            }
            
            ValidationCheckTextField(textType: .mandatory,
                                     isMultipleLines: true,
                                     title: TextLiteral.writeCurationInfoViewDescriptionTitle,
                                     placeholder: TextLiteral.writeCurationInfoViewDescriptionPlaceholder,
                                     lengthLimit: 40,
                                     isDownloadLinkTextField: false,
                                     inputHeight: 72,
                                     content: Binding(get: {data.curation.subtitle},
                                                      set: {data.curation.subtitle = $0}),
                                     isValid: $isValidDescription)
            .focused($focusedField, equals: "curationDescription")
            
            Spacer()
                .frame(maxHeight: .infinity)
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    
                    shortcutsZipViewModel.addCuration(curation: data.curation, isEdit: data.isEdit, deletedShortcutCells: data.deletedShortcutCells)
                    
                    self.isWriting.toggle()
                    if #available(iOS 16.1, *) {
                        writeCurationNavigation.navigationPath = .init()
                    }
                } label: {
                    Text(TextLiteral.upload)
                        .shortcutsZipHeadline()
                        .foregroundColor(isIncomplete ? .shortcutsZipPrimary.opacity(0.3) : .shortcutsZipPrimary)
                }
                .disabled(isIncomplete)
            }
        }
        .background(Color.shortcutsZipBackground)
        .navigationBarTitle(data.isEdit ? TextLiteral.writeCurationInfoViewEdit : TextLiteral.wrietCurationInfoViewPost)
        .onAppear(perform : UIApplication.shared.hideKeyboard)
    }
}

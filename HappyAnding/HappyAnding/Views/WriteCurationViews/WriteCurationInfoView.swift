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
    
    @Binding var curation: Curation
    @Binding var isWriting: Bool
    @Binding var deletedShortcutCells: [ShortcutCellModel]
    
    @State var isValidTitle = false
    @State var isValidDescription = false
    
    private var isIncomplete: Bool {
        !(isValidTitle && isValidDescription)
    }
    
    let isEdit: Bool
    
    var body: some View {
        VStack(spacing: 24) {
            ProgressView(value: 2, total: 2)
            
            ValidationCheckTextField(textType: .mandatory,
                                     isMultipleLines: false,
                                     title: TextLiteral.writeCurationInfoViewNameTitle,
                                     placeholder: TextLiteral.writeCurationInfoViewNamePlaceholder,
                                     lengthLimit: 20,
                                     isDownloadLinkTextField: false,
                                     content: $curation.title,
                                     isValid: $isValidTitle)
            .padding(.top, 12)
            
            ValidationCheckTextField(textType: .mandatory,
                                     isMultipleLines: true,
                                     title: TextLiteral.writeCurationInfoViewDescriptionTitle,
                                     placeholder: TextLiteral.writeCurationInfoViewDescriptionPlaceholder,
                                     lengthLimit: 40,
                                     isDownloadLinkTextField: false,
                                     inputHeight: 72,
                                     content: Binding(get: {curation.subtitle},
                                                      set: {curation.subtitle = $0}),
                                     isValid: $isValidDescription)
            
            Spacer()
                .frame(maxHeight: .infinity)
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    
                    shortcutsZipViewModel.addCuration(curation: curation, isEdit: isEdit, deletedShortcutCells: deletedShortcutCells)
                    
                    self.isWriting.toggle()
                    writeCurationNavigation.navigationPath = .init()
                } label: {
                    Text(TextLiteral.upload)
                        .shortcutsZipHeadline()
                        .foregroundColor(isIncomplete ? .shortcutsZipPrimary.opacity(0.3) : .shortcutsZipPrimary)
                }
                .disabled(isIncomplete)
            }
        }
        .background(Color.shortcutsZipBackground)
        .navigationBarTitle(isEdit ? TextLiteral.writeCurationInfoViewEdit : TextLiteral.wrietCurationInfoViewPost)
        .onAppear(perform : UIApplication.shared.hideKeyboard)
    }
}

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
    
    @State var isValidTitle = false
    @State var isValidDescription = false
    
    @Binding var curation: Curation
    @Binding var isWriting: Bool
    
    let isEdit: Bool
    
    private var isIncomplete: Bool {
        !(isValidTitle && isValidDescription)
    }
    
    var body: some View {
        VStack(spacing: 24) {
            ProgressView(value: 2, total: 2)
            
            ValidationCheckTextField(textType: .mandatory,
                                     isMultipleLines: false,
                                     title: "큐레이션 이름",
                                     placeholder: "큐레이션 이름을 작성해주세요",
                                     lengthLimit: 20,
                                     isDownloadLinkTextField: false,
                                     content: $curation.title,
                                     isValid: $isValidTitle)
                .padding(.top, 12)
            
            ValidationCheckTextField(textType: .mandatory,
                                     isMultipleLines: true,
                                     title: "한 줄 설명",
                                     placeholder: "나의 큐레이션을 설명할 수 있는 간단한 내용을 작성해주세요",
                                     lengthLimit: 40,
                                     isDownloadLinkTextField: false,
                                     content: Binding(get: {curation.subtitle},
                                                      set: {curation.subtitle = $0}),
                                     isValid: $isValidDescription)
            
            Spacer()
                .frame(maxHeight: .infinity)
            
            Button {
                curation.author = shortcutsZipViewModel.currentUser()
                shortcutsZipViewModel.setData(model: curation)
                shortcutsZipViewModel.updateShortcutCurationID(
                    shortcutCells: curation.shortcuts,
                    curationID: curation.id
                )
                if let index = shortcutsZipViewModel.userCurations.firstIndex(where: { $0.id == curation.id}) {
                    shortcutsZipViewModel.userCurations[index] = curation
                }
                
                self.isWriting.toggle()
                writeCurationNavigation.navigationPath = .init()
            } label: {
                ZStack {
                    RoundedRectangle(cornerRadius: 12)
                        .foregroundColor(isIncomplete ? .Primary .opacity(0.13) : .Primary)
                        .padding(.horizontal, 16)
                        .frame(height: 52)
                    Text("완료")
                        .foregroundColor(isIncomplete ? .Text_Button_Disable : .Text_Button)
                        .Body1()
                }
            }
            .disabled(isIncomplete)
        }
        .background(Color.Background)
        .navigationBarTitle(isEdit ? "큐레이션 편집" : "큐레이션 만들기")
        .onAppear(perform : UIApplication.shared.hideKeyboard)
    }
}

//struct WriteCurationInfoView_Previews: PreviewProvider {
//    static var previews: some View {
//        WriteCurationInfoView(isWriting: .constant(true),
//                              isEdit: false, navigationParentView: .curations)
//    }
//}

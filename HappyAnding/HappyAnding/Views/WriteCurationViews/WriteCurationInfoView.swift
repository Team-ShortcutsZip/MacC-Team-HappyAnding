//
//  WriteCurationInfoView.swift
//  HappyAnding
//
//  Created by 이지원 on 2022/10/19.
//

import SwiftUI

struct WriteCurationInfoView: View {
    
    @State var isValidTitle = false
    @State var isValidDescription = false
    @State var curation = Curation(title: "",
                                   subtitle: "",
                                   dateTime: "",
                                   isAdmin: false,
                                   background: "White",
                                   author: "",
                                   shortcuts: [ShortcutCellModel]())
    @Binding var isWriting: Bool
    
    let firebase = FirebaseService()
    let isEdit: Bool
//    var shortcuts: [Shortcuts]
    
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
                                     content: Binding(get: {curation.subtitle ?? ""},
                                                      set: {curation.subtitle = $0}),
                                     isValid: $isValidDescription)
            
            Spacer()
                .frame(maxHeight: .infinity)
            
            Button(action: {
                curation.author = firebase.currentUser()
                firebase.setData(model: curation)
                
                isWriting.toggle()
            }, label: {
                ZStack {
                    RoundedRectangle(cornerRadius: 12)
                        .foregroundColor(isIncomplete ?.Gray1 : .Primary)
                        .padding(.horizontal, 16)
                        .frame(height: 52)
                    Text("완료")
                        .foregroundColor(isIncomplete ? .Gray3 : .Background)
                }
            })
            .disabled(isIncomplete)
        }
        .navigationBarTitle(isEdit ? "나의 큐레이션 편집" : "나의 큐레이션 만들기")
        .onAppear {
            print("WriteCurationView \(curation)")
        }
    }
}

//struct WriteCurationInfoView_Previews: PreviewProvider {
//    static var previews: some View {
//        WriteCurationInfoView()
//    }
//}

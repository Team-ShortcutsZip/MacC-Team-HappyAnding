//
//  WriteCurationInfoView.swift
//  HappyAnding
//
//  Created by 이지원 on 2022/10/19.
//

import SwiftUI

struct WriteCurationInfoView: View {
    
    @State var title = ""
    @State var description = ""
    @State var isValidTitle = false
    @State var isValidDescription = false
    
    let firebase = FirebaseService()
    var shortcuts: [Shortcuts]
    
    @Binding var isWriting: Bool
    
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
                                     content: $title,
                                     isValid: $isValidTitle)
                .padding(.top, 12)
            
            ValidationCheckTextField(textType: .mandatory,
                                     isMultipleLines: true,
                                     title: "한 줄 설명",
                                     placeholder: "나의 큐레이션을 설명할 수 있는 간단한 내용을 작성해주세요",
                                     lengthLimit: 40,
                                     content: $description,
                                     isValid: $isValidDescription)
            
            Spacer()
                .frame(maxHeight: .infinity)
            
            Button(action: {
                let curation = Curation(
                    title: self.title,
                    subtitle: self.description,
                    dateTime: "",
                    idAdmin: false,
                    background: "White",
                    author: "testUser",
                    shortcuts: shortcuts
                )
                
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
    }
}

//struct WriteCurationInfoView_Previews: PreviewProvider {
//    static var previews: some View {
//        WriteCurationInfoView()
//    }
//}

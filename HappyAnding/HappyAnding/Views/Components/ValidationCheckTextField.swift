//
//  ValidationCheckTextField.swift.swift
//  HappyAnding
//
//  Created by 이지원 on 2022/10/20.
//

import SwiftUI

enum TextType {
    case optional
    case mandatory
    
    var isOptional: Bool {
        switch self {
        case .optional:
            return true
        case .mandatory:
            return false
        }
    }
}

struct ValidationCheckTextField: View {
    let textType: TextType
    let isMultipleLines: Bool
    let title: String
    let placeholder: String
    let lengthLimit: Int
    @Binding var content: String
    @Binding var isValid: Bool
    
    @State private var strokeColor = Color.Gray2
    @State private var isExceeded = false
    
    var body: some View {
        VStack {
            textFieldTitle
            
            HStack {
                if isMultipleLines {
                    multiLineEditor
                } else {
                    oneLineEditor
                }
                
                if isExceeded || content.isEmpty {
                    Button(action: {
                        content.removeAll()
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .Body2()
                            .foregroundColor(.Gray4)
                    }
                    .padding()
                } else {
                    Image(systemName: "checkmark.circle.fill")
                        .Body2()
                        .foregroundColor(.Success)
                        .padding()
                }
            }
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(lineWidth: 1)
                    .foregroundColor(strokeColor)
            ).padding(.horizontal, 16)
            
            HStack {
                if isExceeded {
                    Text("글자수를 초과하였습니다")
                        .Body2()
                        .foregroundColor(.Error)
                        .padding(.leading)
                }
                
                Spacer()
                
                Text("\(content.count)/\(lengthLimit)")
                    .Body2()
                    .foregroundColor(isExceeded ? .Error : .Gray4)
                    .padding(.trailing, 16)
            }
        }
    }
    
    var textFieldTitle: some View {
        HStack {
            Text(title)
                .Headline()
                .foregroundColor(.Gray5)
                .padding(.leading, 16)
            
            if textType.isOptional {
                Text("(선택입력)")
                    .Footnote()
                    .foregroundColor(.Gray3)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    var oneLineEditor: some View {
        TextField(placeholder, text: $content)
            .Body2()
            .padding(16)
            .onAppear {
                checkValidation()
            }
            .onSubmit {
                checkValidation()
            }
            .onChange(of: content, perform: {_ in
                checkValidation()
        })
    }
    
    var multiLineEditor: some View {
        ZStack(alignment: .leading) {
            TextEditor(text: $content)
                .Body2()
                .frame(height: 206)
                .padding(16)
                .onAppear {
                    checkValidation()
                }
                .onSubmit {
                    checkValidation()
                }
                .onChange(of: content, perform: {_ in
                    checkValidation()
                })
            
            if content.isEmpty {
                VStack {
                    Text(placeholder)
                        .Body2()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.top, 7)
                        .padding(.leading, 20)
                    Spacer()
                }
                .opacity(content.isEmpty ? 0.2 : 0)
                .frame(height: 206)
            }
        }
    }
}

extension ValidationCheckTextField {
    func checkValidation() {
        if content.isEmpty {
            isValid = textType.isOptional
            isExceeded = false
            self.strokeColor = Color.Gray2
        } else if content.count <= lengthLimit {
            isValid = true
            isExceeded = false
            self.strokeColor = Color.Success
        } else {
            isValid = textType.isOptional
            isExceeded = true
            self.strokeColor = Color.Error
        }
    }
}

struct ValidationCheckTextField_Previews: PreviewProvider {
    static var previews: some View {
        ValidationCheckTextField(
            textType: .optional,
            isMultipleLines: true,
            title: "설명",
            placeholder: "단축어에 대한 설명을 작성해주세요\n\n예시)\n- 이럴때 사용하면 좋아요\n- 이 단축어는 이렇게 사용해요",
            lengthLimit: 20,
            content: .constant(""),
            isValid: .constant(true)
        )
    }
}

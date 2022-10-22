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
}

struct ValidationCheckTextField: View {
    
    // TODO: 단축어 이름에 이모지 포함되면 에러처리
    
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
                    Button(action: { content.removeAll() }) {
                        Image(systemName: "x.circle.fill")
                            .font(.body)
                            .foregroundColor(.Gray4)
                    }
                    .padding()
                } else {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.body)
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
                .frame(alignment: .leading)
                .padding(.leading, 16)
            if textType == .optional {
                Text("(선택입력)")
                    .Footnote()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .foregroundColor(.Gray3)
            }
        }
    }
    
    var oneLineEditor: some View {
        TextField(placeholder, text: $content, onEditingChanged: {_ in
            self.strokeColor = Color.Gray5
        })
        .padding(16)
        .onAppear {
            checkValidation(isDoneWriting: false)
        }
        .onSubmit {
            checkValidation(isDoneWriting: true)
        }
        .onChange(of: content, perform: {_ in
            checkValidation(isDoneWriting: false)
        })
    }
    
    var multiLineEditor: some View {
        ZStack(alignment: .leading) {
            TextEditor(text: $content)
                .frame(height: 206)
                .padding(16)
                .onAppear {
                    checkValidation(isDoneWriting: false)
                }
                .onSubmit {
                    checkValidation(isDoneWriting: true)
                }
                .onChange(of: content, perform: {_ in
                    checkValidation(isDoneWriting: false)
                })
            
            if content.isEmpty {
                VStack {
                    Text(placeholder)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.top, 7)
                        .padding(.leading, 20)
                    Spacer()
                }
                .opacity(content.isEmpty ? 0.5 : 0)
                .frame(height: 206)
            }
        }
    }
}

extension ValidationCheckTextField {
    func checkValidation(isDoneWriting: Bool) {
        if textType == .optional {
            isValid = true
        } else {
            if content.isEmpty {
                isValid = false
                isExceeded = false
                self.strokeColor = isDoneWriting ? Color.Gray2 : Color.Gray5
            }
            else if content.count <= lengthLimit {
                isValid = true
                isExceeded = false
                self.strokeColor = Color.Success
            }
            else {
                isValid = false
                isExceeded = true
                self.strokeColor = Color.Error
            }
        }
    }
}

struct ValidationCheckTextField_Previews: PreviewProvider {
    static var previews: some View {
        ValidationCheckTextField(textType: .optional, isMultipleLines: true, title: "설명", placeholder: "단축어에 대한 설명을 작성해주세요\n\n예시)\n- 이럴때 사용하면 좋아요\n- 이 단축어는 이렇게 사용해요", lengthLimit: 20, content: .constant(""), isValid: .constant(true))
    }
}

//
//  ValidationCheckTextField.swift.swift
//  HappyAnding
//
//  Created by 이지원 on 2022/10/20.
//

import SwiftUI

struct ValidationCheckTextField: View {
    
    // TODO: 설명이 옵셔널일 경우
    // TODO: 단축어 이름에 이모지 포함되면 에러처리
    
    let isMultipleLines: Bool
    let title: String
    let placeholder: String
    let lengthLimit: Int
    @Binding var content: String
    
    @State private var strokeColor = Color.Gray2
    @State private var isExceeded = false
    
    var body: some View {
        VStack {
            Text(title)
                .Headline()
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.leading, 16)
            
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
    
    var oneLineEditor: some View {
        TextField(placeholder, text: $content, onEditingChanged: {_ in
            self.strokeColor = Color.Gray5
        })
        .padding(16)
        .onSubmit {
            changeStrokeColor(isDoneWriting: true)
        }
        .onChange(of: content, perform: {_ in
            changeStrokeColor(isDoneWriting: false)
        })
    }
    
    var multiLineEditor: some View {
        ZStack(alignment: .leading) {
            TextEditor(text: $content)
                .frame(height: 206)
                .padding(16)
                .onSubmit {
                    changeStrokeColor(isDoneWriting: true)
                }
                .onChange(of: content, perform: {_ in
                    changeStrokeColor(isDoneWriting: false)
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
    func changeStrokeColor(isDoneWriting: Bool) {
        if content.isEmpty {
            isExceeded = false
            self.strokeColor = isDoneWriting ? Color.Gray2 : Color.Gray5
        }
        else if content.count <= lengthLimit {
            isExceeded = false
            self.strokeColor = Color.Success
        }
        else {
            isExceeded = true
            self.strokeColor = Color.Error
        }
    }
}

struct ValidationCheckTextField_Previews: PreviewProvider {
    static var previews: some View {
        ValidationCheckTextField(isMultipleLines: true, title: "설명", placeholder: "단축어에 대한 설명을 작성해주세요\n\n예시)\n- 이럴때 사용하면 좋아요\n- 이 단축어는 이렇게 사용해요", lengthLimit: 20, content: .constant(""))
    }
}

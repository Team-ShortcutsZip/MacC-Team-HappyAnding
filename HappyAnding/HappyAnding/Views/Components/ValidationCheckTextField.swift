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
    @State var placeholder: String
    let lengthLimit: Int
    let isDownloadLinkTextField: Bool
    
    @Binding var content: String
    @Binding var isValid: Bool
    
    @State private var strokeColor = Color.Gray2
    @State private var isExceeded = false
    
    var body: some View {
        VStack {
            textFieldTitle
            
            ZStack {
                if isMultipleLines {
                    multiLineEditor
                } else {
                    HStack(alignment: .center) {
                        oneLineEditor
                        
                        if isExceeded {
                            Button(action: {
                                content.removeAll()
                            }) {
                                Image(systemName: "xmark.circle.fill")
                                    .Body2()
                                    .foregroundColor(.Gray4)
                            }
                            .padding()
                        } else if !content.isEmpty {
                            Image(systemName: "checkmark.circle.fill")
                                .Body2()
                                .foregroundColor(.Success)
                                .padding()
                        }
                    }
                    
                }
            }
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(lineWidth: 1)
                    .foregroundColor(strokeColor)
            )
            .padding(.horizontal, 16)
            
            HStack {
                if isExceeded {
                    Text(isDownloadLinkTextField ? "유효하지 않은 링크입니다" : "글자수를 초과하였습니다")
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
            .frame(height: 20)
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
        ZStack(alignment: .top) {
            if content.isEmpty {
                TextEditor(text: $placeholder)
                    .scrollContentBackground(.hidden)
                    .background(Color.Background)
                    .Body2()
                    .foregroundColor(.Gray2)
                    .frame(height: 206)
                    .padding(16)
                    .opacity(1)
            }
            
            TextEditor(text: $content)
                .scrollContentBackground(.hidden)
                .background(Color.Background)
                .Body2()
                .frame(height: 206)
                .padding(16)
                .opacity(self.content.isEmpty ? 0.25 : 1)
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
    }
}

extension ValidationCheckTextField {
    func checkValidation() {
        if content.isEmpty {
            isValid = textType.isOptional
            isExceeded = false
            self.strokeColor = Color.Gray2
        } else if content.count <= lengthLimit {
            if isDownloadLinkTextField {
                if content.hasPrefix("https://www.icloud.com/shortcuts/") {
                    isValid = true
                    isExceeded = false
                    self.strokeColor = Color.Success
                } else {
                    isValid = textType.isOptional
                    isExceeded = true
                    self.strokeColor = Color.Error
                }
            } else {
                isValid = true
                isExceeded = false
                self.strokeColor = Color.Success
            }
            
        } else {
            isValid = false
            isExceeded = true
            self.strokeColor = Color.Error
        }
    }
}

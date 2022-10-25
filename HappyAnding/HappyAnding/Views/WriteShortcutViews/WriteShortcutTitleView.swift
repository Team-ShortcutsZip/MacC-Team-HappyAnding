//
//  WriteShortcutTitleView.swift
//  HappyAnding
//
//  Created by 이지원 on 2022/10/19.
//

import SwiftUI

struct WriteShortcutTitleView: View {
    @Binding var shortcutName: String
    @Binding var shortcutLink: String
    @Binding var iconColor: String
    @Binding var iconSymbol: String
    
    @State var isShowingIconModal = false
    @State var isNameValid = false
    @State var isLinkValid = false
    
    var body: some View {
        NavigationStack {
            VStack {
                ProgressView(value: 0.33, total: 1)
                
                Button(action: {
                    isShowingIconModal = true
                }, label: {
                    if iconSymbol.isEmpty {
                        ZStack(alignment: .center) {
                            Rectangle()
                                .fill(Color.Gray1)
                                .cornerRadius(12.35)
                                .frame(width: 84, height: 84)
                            
                            Image(systemName: "plus")
                                .resizable()
                                .frame(width: 24, height: 24)
                                .foregroundColor(.Gray5)
                        }

                    } else {
                        ZStack(alignment: .center) {
                            Rectangle()
                                .fill(Color.fetchGradient(color: iconColor))
                                .cornerRadius(12.35)
                                .frame(width: 84, height: 84)
                            
                            Image(systemName: iconSymbol)
                                .resizable()
                                .frame(width: 32, height: 32)
                                .foregroundColor(.White)
                        }
                    }
                })
                .padding(36)
                .sheet(isPresented: $isShowingIconModal) {
                    IconModalView(isShowing: $isShowingIconModal, iconColor: $iconColor, iconSymbol: $iconSymbol)
                }
                
                ValidationCheckTextField(textType: .mandatory,
                                         isMultipleLines: false,
                                         title: "단축어 이름",
                                         placeholder: "단축어 이름을 입력하세요",
                                         lengthLimit: 20,
                                         content: $shortcutName,
                                         isValid: $isNameValid
                )
                .keyboardType(.asciiCapable)
                
                ValidationCheckTextField(textType: .mandatory,
                                         isMultipleLines: false,
                                         title: "단축어 링크",
                                         placeholder: "단축어 링크를 추가하세요",
                                         lengthLimit: 100,
                                         content: $shortcutLink,
                                         isValid: $isLinkValid
                )
                
                Spacer()
                
                NavigationLink {
                    WriteShortcutdescriptionView()
                } label: {
                    Text("다음")
                        .Body1()
                        .frame(maxWidth: .infinity, maxHeight: 52)
                }
                .disabled(iconColor.isEmpty || iconSymbol.isEmpty || !isNameValid || !isLinkValid)
                .padding(.horizontal, 16)
                .buttonStyle(.borderedProminent)
            }
            .ignoresSafeArea(.keyboard)
        }
    }
}

struct WriteShortcutTitleView_Previews: PreviewProvider {
    static var previews: some View {
        WriteShortcutTitleView(shortcutName: .constant(""), shortcutLink: .constant(""), iconColor: .constant("LightPurple"), iconSymbol: .constant("bus.fill"))
    }
}

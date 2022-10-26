//
//  WriteShortcutTitleView.swift
//  HappyAnding
//
//  Created by 이지원 on 2022/10/19.
//

import SwiftUI

struct WriteShortcutTitleView: View {
    @Binding var isWriting: Bool
    
    @State var shortcutName = ""
    @State var shortcutLink = ""
    @State var iconColor = ""
    @State var iconSymbol = ""
    
    @State var isShowingIconModal = false
    @State var isNameValid = false
    @State var isLinkValid = false
    
    var body: some View {
        NavigationStack {
            VStack {
                HStack {
                    Button(action: {
                        isWriting.toggle()
                    }, label: {
                        Text("\(Image(systemName: "chevron.left")) Back")
                            .font(.body)
                    })
                    .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Text("단축어 등록")
                        .font(.headline)
                        .frame(maxWidth: .infinity, alignment: .center)
                    
                    Text("")
                        .frame(maxWidth: .infinity, alignment: .trailing)
                }
                .padding(.top, 12)
                .padding(.horizontal, 16)
                
                ProgressView(value: 0.33, total: 1)
                    .padding(.bottom, 36)
                
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
                .sheet(isPresented: $isShowingIconModal) {
                    IconModalView(isShowingIconModal: $isShowingIconModal,
                                  iconColor: $iconColor,
                                  iconSymbol: $iconSymbol
                    )
                }
                
                ValidationCheckTextField(textType: .mandatory,
                                         isMultipleLines: false,
                                         title: "단축어 이름",
                                         placeholder: "단축어 이름을 입력하세요",
                                         lengthLimit: 20,
                                         content: $shortcutName,
                                         isValid: $isNameValid
                )
                .padding(.top, 30)
                
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
                    WriteShortcutdescriptionView(isWriting: $isWriting)
                } label: {
                    ZStack {
                        RoundedRectangle(cornerRadius: 12)
                            .foregroundColor(!iconColor.isEmpty && !iconSymbol.isEmpty && isNameValid && isLinkValid ? .Primary : .Gray1 )
                            .frame(maxWidth: .infinity, maxHeight: 52)
                        
                        Text("다음")
                            .foregroundColor(!iconColor.isEmpty && !iconSymbol.isEmpty && isNameValid && isLinkValid ? .Background : .Gray3 )
                            .Body1()
                    }
                }
                .disabled(iconColor.isEmpty || iconSymbol.isEmpty || !isNameValid || !isLinkValid)
                .padding(.horizontal, 16)
                .padding(.bottom, 24)
            }
        }
        .navigationTitle("단축어 등록")
        .ignoresSafeArea(.keyboard, edges: .bottom)
    }
}

struct WriteShortcutTitleView_Previews: PreviewProvider {
    static var previews: some View {
        WriteShortcutTitleView(isWriting: .constant(true))
    }
}

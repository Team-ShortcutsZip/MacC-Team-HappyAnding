//
//  WriteShortcutTitleView.swift
//  HappyAnding
//
//  Created by 이지원 on 2022/10/19.
//

import SwiftUI

struct WriteShortcutTitleView: View {
    @Binding var isWriting: Bool
    
    @State var isShowingIconModal = false
    @State var isNameValid = false
    @State var isLinkValid = false
    @State var shortcut = Shortcuts(sfSymbol: "", color: "", title: "", subtitle: "", description: "", category: [String](), requiredApp: [String](), numberOfLike: 0, numberOfDownload: 0, author: "", shortcutRequirements: "", downloadLink: [""], curationIDs: [String]())
    
    let isEdit: Bool
    
    var body: some View {
        NavigationStack {
            VStack {
                HStack {
                    Button(action: {
                        isWriting.toggle()
                    }, label: {
                        Image(systemName: "chevron.backward")
                            .Title2()
                            .foregroundColor(.Gray4)
                    })
                    .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Text(isEdit ? "단축어 편집" : "단축어 등록")
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
                    if shortcut.sfSymbol.isEmpty {
                        ZStack(alignment: .center) {
                            Rectangle()
                                .fill(Color.Gray1)
                                .cornerRadius(12.35)
                                .frame(width: 84, height: 84)
                            
                            Image(systemName: "plus")
                                .font(.system(size: 24))
                                .frame(width: 84, height: 84)
                                .foregroundColor(.Gray5)
                        }
                        
                    } else {
                        ZStack(alignment: .center) {
                            Rectangle()
                                .fill(Color.fetchGradient(color: shortcut.color))
                                .cornerRadius(12.35)
                                .frame(width: 84, height: 84)
                            
                            Image(systemName: shortcut.sfSymbol)
                                .font(.system(size: 32))
                                .frame(width: 84, height: 84)
                                .foregroundColor(.Background)
                        }
                    }
                })
                .sheet(isPresented: $isShowingIconModal) {
                    IconModalView(isShowingIconModal: $isShowingIconModal,
                                  iconColor: $shortcut.color,
                                  iconSymbol: $shortcut.sfSymbol
                    )
                }
                
                ValidationCheckTextField(textType: .mandatory,
                                         isMultipleLines: false,
                                         title: "단축어 이름",
                                         placeholder: "단축어 이름을 입력하세요",
                                         lengthLimit: 20,
                                         isDownloadLinkTextField: false,
                                         content: $shortcut.title,
                                         isValid: $isNameValid
                )
                .onAppear(perform : UIApplication.shared.hideKeyboard)
                .padding(.top, 30)
                
                ValidationCheckTextField(textType: .mandatory,
                                         isMultipleLines: false,
                                         title: "단축어 링크",
                                         placeholder: "단축어 링크를 추가하세요",
                                         lengthLimit: 100,
                                         isDownloadLinkTextField: true   ,
                                         content: $shortcut.downloadLink[0],
                                         isValid: $isLinkValid
                )
                
                Spacer()
                
                NavigationLink {
                  //  WriteShortcutdescriptionView(isWriting: $isWriting, shortcut: shortcut, isEdit: isEdit)
                    WriteShortcutdescriptionView(isWriting: $isWriting, shortcut: $shortcut, isEdit: isEdit)
                } label: {
                    ZStack {
                        RoundedRectangle(cornerRadius: 12)
                            .foregroundColor(!shortcut.color.isEmpty && !shortcut.sfSymbol.isEmpty && isNameValid && isLinkValid ? .Primary : .Gray1 )
                            .frame(maxWidth: .infinity, maxHeight: 52)
                        
                        Text("다음")
                            .foregroundColor(!shortcut.color.isEmpty && !shortcut.sfSymbol.isEmpty && isNameValid && isLinkValid ? .Text_Button : .Text_Button_Disable )
                            .Body1()
                    }
                }
                .disabled(shortcut.color.isEmpty || shortcut.sfSymbol.isEmpty || !isNameValid || !isLinkValid)
                .padding(.horizontal, 16)
                .padding(.bottom, 24)
            }
            .ignoresSafeArea(.keyboard, edges: .bottom)
            .background(Color.Background)
        }
    }
}

struct WriteShortcutTitleView_Previews: PreviewProvider {
    static var previews: some View {
        WriteShortcutTitleView(isWriting: .constant(true), isEdit: false)
    }
}

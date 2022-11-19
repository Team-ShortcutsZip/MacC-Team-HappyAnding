//
//  WriteShortcutTitleView.swift
//  HappyAnding
//
//  Created by 이지원 on 2022/10/19.
//

import SwiftUI

struct WriteShortcutTitleView: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    @Binding var isWriting: Bool
    
    @State var isShowingIconModal = false
    @State var isNameValid = false
    @State var isLinkValid = false
    @State var shortcut = Shortcuts(sfSymbol: "",
                                    color: "",
                                    title: "",
                                    subtitle: "",
                                    description: "",
                                    category: [String](),
                                    requiredApp: [String](),
                                    numberOfLike: 0,
                                    numberOfDownload: 0,
                                    author: "",
                                    shortcutRequirements: "",
                                    downloadLink: [""],
                                    curationIDs: [String]())
    
    // TODO: Refactor 필요, iOS16.0에서 Binding이 안 되는 문제 해결
    @State var iconSymbol = ""
    @State var iconColor = ""
    @State var title = ""
    @State var downloadLink = ""
    
    let isEdit: Bool
    let navigationParentView: NavigationParentView
    
    var body: some View {
        VStack {
            
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
                            .font(.system(size: 24))
                            .frame(width: 84, height: 84)
                            .foregroundColor(.Gray5)
                    }
                    
                } else {
                    ZStack(alignment: .center) {
                        Rectangle()
                            .fill(Color.fetchGradient(color: iconColor))
                            .cornerRadius(12.35)
                            .frame(width: 84, height: 84)
                        
                        Image(systemName: iconSymbol)
                            .font(.system(size: 32))
                            .frame(width: 84, height: 84)
                            .foregroundColor(.Text_icon)
                    }
                }
            })
            .sheet(isPresented: $isShowingIconModal) {
                IconModalView(isShowingIconModal: $isShowingIconModal,
                              iconColor: $iconColor,
                              iconSymbol: $iconSymbol)
            }
            
            ValidationCheckTextField(textType: .mandatory,
                                     isMultipleLines: false,
                                     title: "단축어 이름",
                                     placeholder: "단축어 이름을 입력하세요",
                                     lengthLimit: 20,
                                     isDownloadLinkTextField: false,
                                     content: $title,
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
                                     content: $downloadLink,
                                     isValid: $isLinkValid
            )
            
            Spacer()
            
            NavigationLink(value: 1) {
                ZStack {
                    RoundedRectangle(cornerRadius: 12)
                        .foregroundColor(!iconColor.isEmpty && !iconSymbol.isEmpty && isNameValid && isLinkValid ? .Primary : .Gray1 )
                        .frame(maxWidth: .infinity, maxHeight: 52)
                    
                    Text("다음")
                        .foregroundColor(!iconColor.isEmpty && !iconSymbol.isEmpty && isNameValid && isLinkValid ? .Text_Button : .Text_Button_Disable )
                        .Body1()
                }
            }
            .disabled(iconColor.isEmpty || iconSymbol.isEmpty || !isNameValid || !isLinkValid)
            .padding(.horizontal, 16)
            .padding(.bottom, 24)
        }
        .onAppear {
            print("shortcut = \(shortcut)")
            self.iconColor = shortcut.color
            self.iconSymbol = shortcut.sfSymbol
            self.title = shortcut.title
            self.downloadLink = shortcut.downloadLink[0]
        }
        .onDisappear {
            shortcut.color = self.iconColor
            shortcut.sfSymbol = self.iconSymbol
            shortcut.title = self.title
            shortcut.downloadLink[0] = self.downloadLink
        }
        .ignoresSafeArea(.keyboard, edges: .bottom)
        .background(Color.Background)
        .navigationTitle(isEdit ? "단축어 편집" : "단축어 등록")
        .navigationBarTitleDisplayMode(.inline)
        .navigationDestination(for: Int.self) { value in
            WriteShortcutdescriptionView(shortcut: $shortcut,
                                         isWriting: $isWriting,
                                         isEdit: isEdit,
                                         navigationParentView: self.navigationParentView)
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                if isEdit {
                    Button {
                        self.presentationMode.wrappedValue.dismiss()
                    } label: {
                        Text("닫기")
                    }
                }
            }
        }
    }
}

//
//  WriteShortcutTagView.swift
//  HappyAnding
//
//  Created by 이지원 on 2022/10/19.
//

import SwiftUI

struct WriteShortcutTagView: View {
    
    let firebase = FirebaseService()
    
    @Binding var isWriting: Bool
    
    @State var isShowingCategoryModal = false
    @State var isRequirementValid = false
    @State var shortcut = Shortcuts(sfSymbol: "", color: "", title: "", subtitle: "", description: "", category: [String](), requiredApp: [String](), numberOfLike: 0, numberOfDownload: 0, author: "", shortcutRequirements: "", downloadLink: [""])
    
    let isEdit: Bool
    
    var body: some View {
        VStack {
            ProgressView(value: 1, total: 1)
            .padding(.bottom, 36)
            
            HStack {
                Text("카테고리")
                    .Headline()
                    .padding(.leading, 16)
                    .foregroundColor(.Gray5)
                Text("최대 3개 선택")
                    .Footnote()
                    .foregroundColor(.Gray3)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            categoryList(isShowingCategoryModal: $isShowingCategoryModal, selectedCategories: $shortcut.category)
            
            Text("단축어 사용에 필요한 앱")
                .Headline()
                .padding(.leading, 16)
                .foregroundColor(.Gray5)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            relatedAppList(relatedApps: $shortcut.requiredApp)
            
            ValidationCheckTextField(textType: .optional,
                                     isMultipleLines: true,
                                     title: "단축어 사용을 위한 요구사항",
                                     placeholder: "단축어를 사용하기 위해서 필수적으로 요구되는 내용이 있다면, 작성해주세요",
                                     lengthLimit: 100,
                                     isDownloadLinkTextField: false,
                                     content: $shortcut.shortcutRequirements,
                                     isValid: $isRequirementValid
            )
            
            Spacer()
            
            Button(action: {
                //새로운 단축어 생성 및 저장
                shortcut.author = firebase.currentUser()
                firebase.setData(model: shortcut)
                
                isWriting.toggle()
            }, label: {
                ZStack {
                    RoundedRectangle(cornerRadius: 12)
                        .foregroundColor(!shortcut.category.isEmpty && !shortcut.requiredApp.isEmpty && isRequirementValid ? .Primary : .Gray1 )
                        .frame(maxWidth: .infinity, maxHeight: 52)
                    
                    Text("완료")
                        .foregroundColor(!shortcut.category.isEmpty && !shortcut.requiredApp.isEmpty && isRequirementValid ? .Background : .Gray3 )
                        .Body1()
                }
            })
            .disabled(shortcut.category.isEmpty || shortcut.requiredApp.isEmpty || !isRequirementValid)
            .padding(.horizontal, 16)
            .padding(.bottom, 24)
        }
        .navigationTitle(isEdit ? "단축어 편집" :"단축어 등록")
        .ignoresSafeArea(.keyboard)
        .background(Color.Background)
    }
    
    struct categoryList: View {
        @Binding var isShowingCategoryModal: Bool
        @Binding var selectedCategories: [String]
        
        var body: some View {
            ScrollView(.horizontal) {
                HStack(spacing: 8) {
                    ForEach(selectedCategories, id:\.self) { item in
                        CategoryTag(item: item, items: $selectedCategories)
                    }
                    
                    Button(action: {
                        isShowingCategoryModal = true
                    }, label: {
                        HStack {
                            Image(systemName: "plus")
                            Text("카테고리 추가")
                        }
                    })
                    .modifier(CellModifier(color: .Gray3))
                    .sheet(isPresented: $isShowingCategoryModal) {
                        CategoryModalView(isShowingCategoryModal: $isShowingCategoryModal, selectedCategories: $selectedCategories)
                            .presentationDetents([.fraction(0.7)])
                    }
                }
            }
            .padding(.leading, 16)
        }
    }
    
    struct relatedAppList: View {
        @Binding var relatedApps: [String]
        
        @FocusState private var isFocused: Bool
        @State var isTextFieldShowing = false
        @State var relatedApp = ""
        
        var body: some View {
            ScrollView(.horizontal) {
                HStack(spacing: 8) {
                    ForEach(relatedApps, id:\.self) { item in
                        RelatedAppTag(item: item, items: $relatedApps)
                    }
                    
                    if isTextFieldShowing {
                        TextField("", text: $relatedApp)
                            .modifier(ClearButton(text: $relatedApp))
                            .focused($isFocused)
                            .onAppear {
                                isFocused = true
                            }
                            .onChange(of: isFocused) { _ in
                                if !isFocused && !relatedApp.isEmpty {
                                    relatedApps.append(relatedApp)
                                    relatedApp = ""
                                    isTextFieldShowing = false
                                }
                            }
                            .modifier(CellModifier(color: .Gray4))
                    }
                    
                    Button(action: {
                        isTextFieldShowing = true
                        isFocused = true
                    }, label: {
                        HStack {
                            Image(systemName: "plus")
                            Text("앱 추가")
                        }
                    })
                    .modifier(CellModifier(color: .Gray3))
                }
            }
            .padding(.leading, 16)
        }
    }
    
    struct CategoryTag: View {
        var item: String
        @Binding var items: [String]
        
        var body: some View {
            HStack {
                Text(Category.withLabel(item)!.translateName())
                
                Button(action: {
                    items.removeAll { $0 == item }
                }, label: {
                    Image(systemName: "xmark")
                })
            }
            .modifier(CellModifier(color: .Primary))
        }
    }
    
    struct RelatedAppTag: View {
        var item: String
        @Binding var items: [String]
        
        var body: some View {
            HStack {
                Text(item)
                
                Button(action: {
                    items.removeAll { $0 == item }
                }, label: {
                    Image(systemName: "xmark")
                })
            }
            .modifier(CellModifier(color: .Primary))
        }
    }
    
    struct CellModifier: ViewModifier {
        @State var color: Color
        
        public func body(content: Content) -> some View {
            content
                .Body2()
                .foregroundColor(color)
                .frame(height: 46)
                .padding(.horizontal)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .strokeBorder(color, lineWidth: 1))
        }
    }
    
    struct ClearButton: ViewModifier {
        @Binding var text: String
        
        public func body(content: Content) -> some View {
            HStack {
                content
                Button(action: {
                    self.text = ""
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .Body2()
                        .foregroundColor(.Gray4)
                }
            }
        }
    }
}

struct WriteShortcutTagView_Previews: PreviewProvider {
    static var previews: some View {
        WriteShortcutTagView(isWriting: .constant(true), isEdit: false)
    }
}

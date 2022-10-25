//
//  WriteShortcutTagView.swift
//  HappyAnding
//
//  Created by 이지원 on 2022/10/19.
//

import SwiftUI

struct WriteShortcutTagView: View {
    @State var selectedCategories = [Category]()
    @State var relatedApps = [String]()
    @State var requirements = ""
    
    @State var isShowingCategoryModal = false
    
    var body: some View {
        VStack {
            ProgressView(value: 1, total: 1)
            
            categoryList(isShowingCategoryModal: $isShowingCategoryModal, selectedCategories: $selectedCategories)
                .padding(.top, 36)
            
            relatedAppList(relatedApps: $relatedApps)
            
            Spacer()
            
            Button(action: {
                
                // TODO: 단축어 등록 완료 후 도착페이지로 이동
                
            }, label: {
                Text("다음")
                    .Body1()
                    .frame(maxWidth: .infinity, maxHeight: 52)
            })
            
            // MARK: 완료 버튼의 조건 - 카테고리와 단축어사용에 필요한 앱을 필수로 할 것인가?
            
            .disabled(selectedCategories.isEmpty || relatedApps.isEmpty)
            .tint(.Primary)
            .padding(.horizontal, 16)
            .buttonStyle(.borderedProminent)
        }
    }
    
    struct categoryList: View {
        @Binding var isShowingCategoryModal: Bool
        @Binding var selectedCategories: [Category]
        
        var body: some View {
            ScrollView(.horizontal) {
                HStack(spacing: 8) {
                    ForEach(selectedCategories, id:\.self) { item in
                        categoryCell(item: item.rawValue, items: $selectedCategories)
                    }
                    Button(action: {
                        isShowingCategoryModal = true
                    }, label: {
                        HStack {
                            Image(systemName: "plus")
                            Text("카테고리 추가")
                        }
                    })
                    .sheet(isPresented: $isShowingCategoryModal) {
                        CategoryModalView(isShowingCategoryModal: $isShowingCategoryModal, selectedCategories: $selectedCategories)
                            .presentationDetents([.fraction(0.7)])
                    }
                    .modifier(TagCell(color: .Gray3))
                }
            }
            .padding(.leading, 16)
        }
    }
    
    struct categoryCell: View {
        var item: String
        @Binding var items: [Category]
        
        var body: some View {
            HStack {
                Text(item)
                
                Button(action: {
                    items.removeAll { $0.rawValue == item }
                }, label: {
                    Image(systemName: "xmark")
                })
            }
            .modifier(TagCell(color: .Primary))
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
                        relatedAppCell(item: item, items: $relatedApps)
                    }
                    
                    if isTextFieldShowing {
                        TextField("", text: $relatedApp)
                            .modifier(ClearButton(text: $relatedApp))
                            .focused($isFocused)
                            .onAppear {
                                isFocused = true
                            }
                            .onSubmit {
                                if !relatedApp.isEmpty {
                                    relatedApps.append(relatedApp)
                                    relatedApp = ""
                                }
                                isTextFieldShowing = false
                            }
                            .modifier(TagCell(color: .Gray4))
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
                    .modifier(TagCell(color: .Gray3))
                }
            }
            .padding(.leading, 16)
        }
    }
    
    struct relatedAppCell: View {
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
            .modifier(TagCell(color: .Primary))
        }
    }
    
    struct TagCell: ViewModifier {
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
                    Image(systemName: "x.circle.fill")
                        .Body2()
                        .foregroundColor(.Gray4)
                }
            }
        }
    }
}

struct WriteShortcutTagView_Previews: PreviewProvider {
    static var previews: some View {
        WriteShortcutTagView()
    }
}

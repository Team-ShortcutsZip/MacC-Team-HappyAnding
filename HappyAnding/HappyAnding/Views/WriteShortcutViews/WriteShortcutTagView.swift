//
//  WriteShortcutTagView.swift
//  HappyAnding
//
//  Created by 이지원 on 2022/10/19.
//

import SwiftUI

struct WriteShortcutTagView: View {
    var body: some View {
        VStack {
            categoryList()
            relatedAppList()
        }
    }
    
    struct categoryList: View {
        
        //TODO: 카테고리는 최대 3개 선택 가능
        
        @State var categories: [Category] = [Category.lifestyle, Category.education, Category.finance]
        
        var body: some View {
            ScrollView(.horizontal) {
                HStack(spacing: 8) {
                    ForEach(categories, id:\.self) { item in
                        categoryCell(item: item.rawValue, items: $categories)
                    }
                    Button(action: {
                        
                        //TODO: CategoryModalView 열기
                        
                    }, label: {
                        HStack {
                            Image(systemName: "plus")
                            Text("카테고리 추가")
                        }
                    })
                    .Body2()
                    .foregroundColor(.Gray3)
                    .frame(height: 46)
                    .padding(.horizontal)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .strokeBorder(Color.Gray3, lineWidth: 1))
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
            .Body2()
            .foregroundColor(.Primary)
            .frame(height: 46)
            .padding(.horizontal)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .strokeBorder(Color.Primary, lineWidth: 1))
        }
    }
    
    struct relatedAppList: View {
        enum FocusField: Hashable {
            case field
        }
        
        @State var isTextFieldShowing = false
        @FocusState private var focusedField: FocusField?
        @State var relatedApp = ""
        @State var relatedApps: [String] = ["지도", "인스타그램"]
        
        var body: some View {
            ScrollView(.horizontal) {
                HStack(spacing: 8) {
                    ForEach(relatedApps, id:\.self) { item in
                        relatedAppCell(item: item, items: $relatedApps)
                    }
                    
                    if isTextFieldShowing {
                        TextField("", text: $relatedApp)
                            .modifier(ClearButton(text: $relatedApp))
                            .focused($focusedField, equals: .field)
                            .onAppear {
                                self.focusedField = .field
                            }
                            .onSubmit {
                                if !relatedApp.isEmpty {
                                    relatedApps.append(relatedApp)
                                    relatedApp = ""
                                }
                                isTextFieldShowing = false
                            }
                            .Body2()
                            .foregroundColor(.Gray4)
                            .frame(height: 46)
                            .padding(.horizontal)
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .strokeBorder(Color.Gray4, lineWidth: 1))
                    }
                    
                    Button(action: {
                        isTextFieldShowing = true
                    }, label: {
                        HStack {
                            Image(systemName: "plus")
                            Text("앱 추가")
                        }
                    })
                    .Body2()
                    .foregroundColor(.Gray3)
                    .frame(height: 46)
                    .padding(.horizontal)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .strokeBorder(Color.Gray3, lineWidth: 1))
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
            .Body2()
            .foregroundColor(.Primary)
            .frame(height: 46)
            .padding(.horizontal)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .strokeBorder(Color.Primary, lineWidth: 1))
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

//
//  WriteShortcutTitleView.swift
//  HappyAnding
//
//  Created by 이지원 on 2022/10/19.
//

import SwiftUI

struct WriteShortcutView: View {
    
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var shortcutsZipViewModel: ShortcutsZipViewModel
    @EnvironmentObject var writeShortcutNavigation: WriteShortcutNavigation
    
    @Binding var isWriting: Bool
    
    @State var isInfoButtonTouched = false
    
    @State var isShowingIconModal = false
    @State var isNameValid = false
    @State var isLinkValid = false
    @State var isOneLineValid = false
    @State var isMultiLineValid = false
    @State var isShowingCategoryModal = false
    @State var isRequirementValid = false
    
    @State var existingCategory: [String] = []
    @State var newCategory: [String] = []
    
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
    
    let isEdit: Bool
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 32){
                iconModalView
                shortcutTitleText
                shortcutLinkText
                shortcutSubtitleText
                shortcutDescriptionText
                shortcutCategory
                shortcutsRequiredApp
            }
        }
        .background(Color.shortcutsZipBackground)
        .navigationTitle(isEdit ? TextLiteral.writeShortcutViewEdit : TextLiteral.writeShortcutViewPost)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    self.presentationMode.wrappedValue.dismiss()
                } label: {
                    Text(TextLiteral.cancel)
                        .Body1()
                        .foregroundColor(.gray5)
                }
            }
            
            // MARK: -업로드 버튼
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    if let index = shortcutsZipViewModel.allShortcuts.firstIndex(where: {$0.id == shortcut.id}) {
                        shortcutsZipViewModel.allShortcuts[index] = shortcut
                    }
                    
                    shortcut.author = shortcutsZipViewModel.currentUser()
                    if isEdit {
                        //단축어 수정
                        //뷰모델의 카테고리별 단축어 목록에서 정보 수정 및 해당 단축어가 포함된 큐레이션 수정
                        shortcutsZipViewModel.updateShortcut(existingCategory: existingCategory, newCategory: shortcut.category, shortcut: shortcut)
                        
                    } else {
                        //새로운 단축어 생성 및 저장
                        // 뷰모델에 추가
                        shortcutsZipViewModel.shortcutsMadeByUser.insert(shortcut, at: 0)
                        
                    }
                    // 서버에 추가 또는 수정
                    shortcutsZipViewModel.setData(model: shortcut)
                    
                    isWriting.toggle()
                    
                    if #available(iOS 16.1, *) {
                        writeShortcutNavigation.navigationPath = .init()
                    }
                    
                }, label: {
                    Text(TextLiteral.upload)
                        .Headline()
                        .foregroundColor(.shortcutsZipPrimary)
                        .opacity(isUnavailableUploadButton() ? 0.3 : 1)
                })
                .disabled(isUnavailableUploadButton())
            }
        }
    }
    
    private func isUnavailableUploadButton() -> Bool {
        shortcut.color.isEmpty ||
        shortcut.sfSymbol.isEmpty ||
        shortcut.title.isEmpty ||
        !isNameValid ||
        shortcut.downloadLink.isEmpty ||
        !isLinkValid ||
        shortcut.subtitle.isEmpty ||
        !isOneLineValid ||
        shortcut.description.isEmpty ||
        !isMultiLineValid || shortcut.category.isEmpty
    }
    
    //MARK: -아이콘 모달 버튼
    private var iconModalView: some View {
        Button(action: {
            isShowingIconModal = true
        }, label: {
            ZStack(alignment: .center) {
                Rectangle()
                    .fill(!shortcut.sfSymbol.isEmpty ? Color.fetchGradient(color: shortcut.color) : Color.fetchDefualtGradient())
                    .cornerRadius(12.35)
                    .frame(width: 84, height: 84)
                Image(systemName: !shortcut.sfSymbol.isEmpty ? shortcut.sfSymbol : "plus")
                    .mediumIcon()
                    .frame(width: 84, height: 84)
                    .foregroundColor(!shortcut.sfSymbol.isEmpty ? .textIcon : .gray5)
            }
        })
        .sheet(isPresented: $isShowingIconModal) {
            IconModalView(isShowingIconModal: $isShowingIconModal,
                          iconColor: $shortcut.color,
                          iconSymbol: $shortcut.sfSymbol)
            .presentationDetents([.large])
            .presentationDragIndicator(.visible)
        }
        .padding(.top, 40)
        .padding(.bottom, 32)
    }
    
    //MARK: -단축어 이름
    private var shortcutTitleText: some View {
        ValidationCheckTextField(textType: .mandatory,
                                 isMultipleLines: false,
                                 title: TextLiteral.writeShortcutViewNameTitle,
                                 placeholder: TextLiteral.writeShortcutViewNamePlaceholder,
                                 lengthLimit: 20,
                                 isDownloadLinkTextField: false,
                                 content: $shortcut.title,
                                 isValid: $isNameValid
        )
        .onAppear(perform : UIApplication.shared.hideKeyboard)
    }
    
    //MARK: -단축어 링크
    private var shortcutLinkText: some View {
        ValidationCheckTextField(textType: .mandatory,
                                 isMultipleLines: false,
                                 title: TextLiteral.writeShortcutViewLinkTitle,
                                 placeholder: TextLiteral.writeShortcutViewLinkPlaceholder,
                                 lengthLimit: nil,
                                 isDownloadLinkTextField: true,
                                 content: $shortcut.downloadLink[0],
                                 isValid: $isLinkValid
        )
    }
    
    //MARK: -한줄 설명
    private var shortcutSubtitleText: some View {
        ValidationCheckTextField(textType: .mandatory,
                                 isMultipleLines: false,
                                 title: TextLiteral.writeShortcutViewOneLineTitle,
                                 placeholder: TextLiteral.writeShortcutViewOneLinePlaceholder,
                                 lengthLimit: 20,
                                 isDownloadLinkTextField: false,
                                 content: $shortcut.subtitle,
                                 isValid: $isOneLineValid
        )
    }
    
    //MARK: -상세 설명
    private var shortcutDescriptionText: some View {
        ValidationCheckTextField(textType: .mandatory,
                                 isMultipleLines: true,
                                 title: TextLiteral.writeShortcutViewMultiLineTitle,
                                 placeholder: TextLiteral.writeShortcutViewMultiLinePlaceholder,
                                 lengthLimit: 300,
                                 isDownloadLinkTextField: false,
                                 content: $shortcut.description,
                                 isValid: $isMultiLineValid
        )
    }
    
    //MARK: -카테고리
    private var shortcutCategory: some View {
        VStack {
            HStack(alignment: .bottom) {
                Text(TextLiteral.writeShortcutViewCategoryTitle)
                    .Headline()
                    .foregroundColor(.gray5)
                Text(TextLiteral.writeShortcutViewCategoryDescription)
                    .Footnote()
                    .foregroundColor(.gray3)
                Spacer()
            }
            .padding(.horizontal, 16)
            
            categoryList(isShowingCategoryModal: $isShowingCategoryModal, selectedCategories: $shortcut.category)
                .padding(.top, 2)
        }
    }
    struct categoryList: View {
        @Binding var isShowingCategoryModal: Bool
        @Binding var selectedCategories: [String]
        
        var body: some View {
            HStack {
                Button(action: {
                    isShowingCategoryModal = true
                }, label: {
                    HStack {
                        if selectedCategories.isEmpty {
                            Text(TextLiteral.writeShortcutViewCategoryCell)
                                .foregroundColor(.gray2)
                                .Body2()
                        } else {
                            Text(selectedCategories.map { Category(rawValue: $0)!.translateName() }.joined(separator: ", "))
                                .foregroundColor(.gray4)
                                .Body2()
                                .multilineTextAlignment(.leading)
                        }
                        Spacer()
                        Image(systemName: "chevron.forward")
                            .smallIcon()
                            .foregroundColor(selectedCategories.isEmpty ? .gray2 : .gray4)
                    }
                    .padding(.all, 16)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .strokeBorder(selectedCategories.isEmpty ? Color.gray2 : Color.gray4, lineWidth: 1)
                    )
                })
                .sheet(isPresented: $isShowingCategoryModal) {
                    CategoryModalView(isShowingCategoryModal: $isShowingCategoryModal, selectedCategories: $selectedCategories)
                        .presentationDetents([.fraction(0.7)])
                        .presentationDragIndicator(.visible)
                }
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 8)
        }
    }
    
    //MARK: -단축어 사용 필요 앱
    private var shortcutsRequiredApp: some View {
        VStack {
            HStack(alignment: .bottom) {
                Text(TextLiteral.writeShortcutViewRequiredAppsTitle)
                    .Headline()
                    .foregroundColor(.gray5)
                Text(TextLiteral.writeShortcutViewRequiredAppDescription)
                    .Footnote()
                    .foregroundColor(.gray3)
                Spacer()
                Image(systemName: "info.circle.fill")
                    .smallIcon()
                    .foregroundColor(.gray4)
                    .onTapGesture {
                        isInfoButtonTouched.toggle()
                    }
            }
            .padding(.horizontal, 16)
            ZStack(alignment: .top) {
                relatedAppList(relatedApps: $shortcut.requiredApp)
                    .padding(.bottom, 44)
                if isInfoButtonTouched {
                    ZStack(alignment: .center) {
                        RoundedRectangle(cornerRadius: 12)
                            .frame(maxWidth: .infinity, maxHeight: 68)
                            .foregroundColor(.gray5)
                        HStack(alignment: .top) {
                            Text(TextLiteral.writeShortcutViewRequiredAppInformation)
                                .Footnote()
                                .foregroundColor(.gray1)
                                .multilineTextAlignment(.leading)
                            Spacer()
                            Image(systemName: "xmark")
                                .smallIcon()
                                .frame(width: 16, height: 16)
                                .foregroundColor(.gray1)
                                .onTapGesture {
                                    isInfoButtonTouched = false
                                }
                        }
                        .padding(.horizontal, 20)
                    }
                    .padding(.horizontal, 16)
                }
            }
        }
    }
    struct relatedAppList: View {
        @FocusState private var isFocused: Bool
        
        @Binding var relatedApps: [String]
        
        @State var isTextFieldShowing = false
        @State var relatedApp = ""
        
        var body: some View {
            ScrollView(.horizontal) {
                HStack(spacing: 8) {
                    ForEach(relatedApps, id:\.self) { item in
                        RelatedAppTag(items: $relatedApps, item: item)
                    }
                    
                    if isTextFieldShowing {
                        TextField("", text: $relatedApp)
                            .modifier(ClearButton(text: $relatedApp))
                            .focused($isFocused)
                            .onAppear {
                                isFocused = true
                            }
                            .onChange(of: isFocused) { _ in
                                if !isFocused {
                                    if !relatedApp.isEmpty {
                                        relatedApps.append(relatedApp)
                                        relatedApp = ""
                                    }
                                    isTextFieldShowing = false
                                }
                            }
                            .modifier(CellModifier(foregroundColor: Color.gray4, strokeColor: Color.shortcutsZipPrimary))
                    }
                    
                    Button(action: {
                        isTextFieldShowing = true
                        isFocused = true
                    }, label: {
                        HStack {
                            Image(systemName: "plus")
                                .smallIcon()
                            Text(TextLiteral.writeShortcutViewRequiredAppCell)
                        }
                    })
                    .modifier(CellModifier(foregroundColor: Color.gray2, strokeColor: Color.gray2))
                }
                .padding(.leading, 16)
            }
            .scrollIndicators(.hidden)
        }
    }
    struct RelatedAppTag: View {
        @Binding var items: [String]
        
        var item: String
        
        var body: some View {
            HStack {
                Text(item)
                
                Button(action: {
                    items.removeAll { $0 == item }
                }, label: {
                    Image(systemName: "xmark")
                        .smallIcon()
                })
            }
            .modifier(CellModifier(foregroundColor: Color.gray4,
                                   backgroundColor: Color.shortcutsZipBackground,
                                   strokeColor: Color.gray4))
        }
    }
    struct CellModifier: ViewModifier {
        @State var foregroundColor: Color
        @State var backgroundColor = Color.clear
        @State var strokeColor: Color
        
        public func body(content: Content) -> some View {
            content
                .Body2()
                .foregroundColor(foregroundColor)
                .frame(height: 52)
                .padding(.horizontal)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill( backgroundColor )
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .strokeBorder(strokeColor, lineWidth: 1))
                )
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
                        .smallIcon()
                        .foregroundColor(.gray4)
                }
            }
        }
    }
}

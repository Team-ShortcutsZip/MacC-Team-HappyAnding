//
//  ShareExtensionWriteShortcutTitleView.swift
//  ShareExtension
//
//  Created by HanGyeongjun on 2022/11/22.
//

import SwiftUI



struct ShareExtensionWriteShortcutTitleView: View {
    
    enum TextFieldType {
        case shortcutTitleText
        case shortcutSubtitleText
        case shortcutDescriptionText
    }
    
    @Environment(\.presentationMode) var presentationMode
    
    @ObservedObject var shareExtensionViewModel: ShareExtensionViewModel
    
    @State var isShowingIconModal = false
    @State var isNameValid = false
    @State var isLinkValid = false
    @State var isOneLineValid = false
    @State var isMultiLineValid = false
    @State var isShowingCategoryModal = false
    @State var isRequirementValid = false
    @State var isInfoButtonTouched: Bool = false
    
    @State var isTextFocused = [Bool](repeating: false, count: 4)
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 32){
                iconModalView
                shortcutTitleText
                    .onTapGesture {
                        isTextFocused = [true, false, false, false]
                    }
                shortcutLinkText.disabled(true)
                    .onTapGesture {
                        isTextFocused = [false, true, false, false]
                    }
                shortcutSubtitleText
                    .onTapGesture {
                        isTextFocused = [false, false, true, false]
                    }
                shortcutDescriptionText
                    .onTapGesture {
                        isTextFocused = [false, false, false, true]
                    }
                shortcutCategory
                shortcutsRequiredApp
            }
        }
        //        .ignoresSafeArea(edges: .bottom)
        .background(Color.Background)
        .onChange(of: shareExtensionViewModel.shortcut) { _ in
            let isDoneValid = shareExtensionViewModel.isDoneValid()
            if isDoneValid {
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "enabledDoneButton"), object: nil)
            } else {
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "inEnabledDoneButton"), object: nil)
            }
        }
    }
    
    //MARK: -아이콘 모달 버튼
    private var iconModalView: some View {
        Button(action: {
            isShowingIconModal = true
        }, label: {
            if shareExtensionViewModel.shortcut.sfSymbol.isEmpty {
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
                        .fill(Color.fetchGradient(color: shareExtensionViewModel.shortcut.color))
                        .cornerRadius(12.35)
                        .frame(width: 84, height: 84)
                    
                    Image(systemName: shareExtensionViewModel.shortcut.sfSymbol)
                        .font(.system(size: 32))
                        .frame(width: 84, height: 84)
                        .foregroundColor(.Text_icon)
                }
            }
        })
        .sheet(isPresented: $isShowingIconModal) {
            IconModalView(isShowingIconModal: $isShowingIconModal,
                          iconColor: $shareExtensionViewModel.shortcut.color,
                          iconSymbol: $shareExtensionViewModel.shortcut.sfSymbol)
            .presentationDetents([.large])
            .presentationDragIndicator(.visible)
        }
        .padding(.top, 40)
        .padding(.bottom, 32)
    }
    
    //MARK: -단축어 이름
    private var shortcutTitleText: some View {
        ShareExtensionValidationCheckTextField(textType: .mandatory,
                                               isMultipleLines: false,
                                               title: "단축어 이름",
                                               placeholder: "단축어 이름을 입력하세요",
                                               lengthLimit: 20,
                                               isDownloadLinkTextField: false,
                                               content: $shareExtensionViewModel.shortcut.title,
                                               isValid: $isNameValid,
                                               isFocused: $isTextFocused, index: 0
        )
        //.onTapGesture {
        //  firstResponder = .shortcutTitleText
        // }
        //        .onAppear(perform : UIApplication.shared.hideKeyboard)
    }
    
    //MARK: -단축어 링크
    private var shortcutLinkText: some View {
        ShareExtensionValidationCheckTextField(textType: .mandatory,
                                               isMultipleLines: false,
                                               title: "단축어 링크",
                                               placeholder: "단축어 링크를 추가하세요",
                                               lengthLimit: 100,
                                               isDownloadLinkTextField: true   ,
                                               content: $shareExtensionViewModel.shortcut.downloadLink[0],
                                               isValid: $isLinkValid,
                                               isFocused: $isTextFocused,
                                               index: 1
        )
    }
    
    //MARK: -한줄 설명
    private var shortcutSubtitleText: some View {
        ShareExtensionValidationCheckTextField(textType: .mandatory,
                                               isMultipleLines: false,
                                               title: "한줄 설명",
                                               placeholder: "해당 단축어의 핵심 기능을 작성해주세요",
                                               lengthLimit: 20,
                                               isDownloadLinkTextField: false,
                                               content: $shareExtensionViewModel.shortcut.subtitle,
                                               isValid: $isOneLineValid,
                                               isFocused: $isTextFocused,
                                               index: 2
        )
    }
    
    //MARK: -상세 설명
    private var shortcutDescriptionText: some View {
        ShareExtensionValidationCheckTextField(textType: .mandatory,
                                               isMultipleLines: true,
                                               title: "상세 설명",
                                               placeholder: "단축어 사용법, 필수적으로 요구되는 사항 등 단축어를 이용하기 위해 필요한 정보를 입력해주세요",
                                               lengthLimit: 300,
                                               isDownloadLinkTextField: false,
                                               content: $shareExtensionViewModel.shortcut.description,
                                               isValid: $isMultiLineValid, isFocused: $isTextFocused,
                                               index: 3
        )
    }
    
    //MARK: -카테고리
    private var shortcutCategory: some View {
        VStack {
            HStack(alignment: .bottom) {
                Text("카테고리")
                    .Headline()
                    .foregroundColor(.Gray5)
                Text("최대 3개")
                    .Footnote()
                    .foregroundColor(.Gray3)
                Spacer()
            }
            .padding(.horizontal, 16)
            
            categoryList(isShowingCategoryModal: $isShowingCategoryModal, selectedCategories: $shareExtensionViewModel.shortcut.category)
                .padding(.top, 2)
        }
    }
    struct categoryList: View {
        @Binding var isShowingCategoryModal: Bool
        @Binding var selectedCategories: [String]
        
        var body: some View {
            ZStack {
                
                RoundedRectangle(cornerRadius: 12)
                    .foregroundColor(.Background)
                    .frame(height: 52)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .strokeBorder(selectedCategories.isEmpty ? Color.Gray2 : Color.Gray4, lineWidth: 1)
                    )
                HStack {
                    Button(action: {
                        isShowingCategoryModal = true
                    }, label: {
                        HStack {
                            if selectedCategories.isEmpty {
                                Text("카테고리 선택")
                                    .foregroundColor(.Gray2)
                                    .Body2()
                            } else {
                                ForEach(selectedCategories, id:\.self) { item in
                                    Text(Category.withLabel(item)!.translateName())
                                        .foregroundColor(.Gray4)
                                        .Body2()
                                }
                            }
                            Spacer()
                            Image(systemName: "chevron.forward")
                                .foregroundColor(selectedCategories.isEmpty ? .Gray2 : .Gray4)
                        }
                    })
                    .sheet(isPresented: $isShowingCategoryModal) {
                        CategoryModalView(isShowingCategoryModal: $isShowingCategoryModal, selectedCategories: $selectedCategories)
                            .presentationDetents([.fraction(0.7)])
                            .presentationDragIndicator(.visible)
                    }
                }
                .padding(.horizontal, 16)
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 8)
        }
    }
    
    //MARK: -단축어 사용 필요 앱
    private var shortcutsRequiredApp: some View {
        VStack {
            HStack(alignment: .bottom) {
                Text("단축어 사용을 위해 필요한 앱")
                    .Headline()
                    .foregroundColor(.Gray5)
                Text("(선택)")
                    .Footnote()
                    .foregroundColor(.Gray3)
                Spacer()
                Image(systemName: "info.circle.fill")
                    .frame(width: 20, height: 20)
                    .foregroundColor(.Gray4)
                    .onTapGesture {
                        isInfoButtonTouched.toggle()
                    }
            }
            .padding(.horizontal, 16)
            ZStack(alignment: .top) {
                relatedAppList(relatedApps: $shareExtensionViewModel.shortcut.requiredApp)
                    .padding(.bottom, 44)
                if isInfoButtonTouched {
                    ZStack(alignment: .center) {
                        RoundedRectangle(cornerRadius: 12)
                            .frame(maxWidth: .infinity, maxHeight: 68)
                            .foregroundColor(.Gray5)
                        HStack(alignment: .top) {
                            Text("해당 단축어를 사용하기 위해 필수로 다운로드해야 하는 앱을 작성해 주세요")
                                .Footnote()
                                .foregroundColor(.Gray1)
                                .multilineTextAlignment(.leading)
                            Spacer()
                            Image(systemName: "xmark")
                                .frame(width: 16, height: 16)
                                .foregroundColor(.Gray1)
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
                                if !isFocused {
                                    if !relatedApp.isEmpty {
                                        relatedApps.append(relatedApp)
                                        relatedApp = ""
                                    }
                                    isTextFieldShowing = false
                                }
                            }
                            .modifier(CellModifier(foregroundColor: Color.Gray4))
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
                    .modifier(CellModifier(foregroundColor: Color.Gray2))
                }
                .padding(.leading, 16)
            }
            .scrollIndicators(.hidden)
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
            .modifier(CellModifier(foregroundColor: Color.Gray4,
                                   backgroundColor: Color.Background,
                                   strokeColor: Color.Gray4))
        }
    }
    struct CellModifier: ViewModifier {
        @State var foregroundColor: Color
        @State var backgroundColor = Color.clear
        @State var strokeColor = Color.Gray2
        
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
                        .Body2()
                        .foregroundColor(.Gray4)
                }
            }
        }
    }
}

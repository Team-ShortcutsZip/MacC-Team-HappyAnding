//
//  ShareExtensionWriteShortcutView.swift
//  ShareExtension
//
//  Created by HanGyeongjun on 2022/11/22.
//

import SwiftUI

struct ShareExtensionWriteShortcutView: View {
    
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
    @State var isInfoButtonTouched: Bool = false
    @State var isTextFocused = [Bool](repeating: false, count: 5)
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 32){
                iconModalView
                shortcutTitleText
                shortcutLinkText.disabled(true)
                shortcutSubtitleText
                shortcutDescriptionText
                shortcutCategory
                shortcutsRequiredApp
            }
        }
        .background(Color.shortcutsZipBackground)
        
        .onChange(of: shareExtensionViewModel.shortcut) { _ in
            let isDoneValid = shareExtensionViewModel.isDoneValid()
            if isDoneValid {
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "enabledDoneButton"), object: nil)
            } else {
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "inEnabledDoneButton"), object: nil)
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: Notification.Name(rawValue: "keyboardHide"))) { object in
            isTextFocused = [false, false, false, false]
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
                        .fill(Color.gray1)
                        .cornerRadius(12.35)
                        .frame(width: 84, height: 84)
                    
                    Image(systemName: "plus")
                        .mediumIcon()
                        .frame(width: 84, height: 84)
                        .foregroundColor(.gray5)
                }
                
            } else {
                ZStack(alignment: .center) {
                    Rectangle()
                        .fill(Color.fetchGradient(color: shareExtensionViewModel.shortcut.color))
                        .cornerRadius(12.35)
                        .frame(width: 84, height: 84)
                    
                    Image(systemName: shareExtensionViewModel.shortcut.sfSymbol)
                        .mediumIcon()
                        .frame(width: 84, height: 84)
                        .foregroundColor(.textIcon)
                }
            }
        })
        .sheet(isPresented: $isShowingIconModal) {
            IconModalView(viewModel: WriteShortcutModalViewModel(),
                          isShowingIconModal: $isShowingIconModal,
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
                                               title: TextLiteral.writeShortcutViewNameTitle,
                                               placeholder: TextLiteral.writeShortcutViewNamePlaceholder,
                                               lengthLimit: 20,
                                               isDownloadLinkTextField: false,
                                               content: $shareExtensionViewModel.shortcut.title,
                                               isValid: $isNameValid,
                                               isFocused: $isTextFocused, index: 0
        )
    }
    
    //MARK: -단축어 링크
    private var shortcutLinkText: some View {
        ShareExtensionValidationCheckTextField(textType: .mandatory,
                                               isMultipleLines: false,
                                               title: TextLiteral.writeShortcutViewLinkTitle,
                                               placeholder: TextLiteral.writeShortcutViewLinkPlaceholder,
                                               lengthLimit: nil,
                                               isDownloadLinkTextField: true,
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
                                               title: TextLiteral.writeShortcutViewOneLineTitle,
                                               placeholder: TextLiteral.writeShortcutViewOneLinePlaceholder,
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
                                               title: TextLiteral.writeShortcutViewMultiLineTitle,
                                               placeholder: TextLiteral.writeShortcutViewMultiLinePlaceholder,
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
                Text(TextLiteral.writeShortcutViewCategoryTitle)
                    .shortcutsZipHeadline()
                    .foregroundColor(.gray5)
                Text(TextLiteral.writeShortcutViewCategoryDescription)
                    .shortcutsZipFootnote()
                    .foregroundColor(.gray3)
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
            HStack {
                Button(action: {
                    isShowingCategoryModal = true
                }, label: {
                    HStack {
                        if selectedCategories.isEmpty {
                            Text(TextLiteral.writeShortcutViewCategoryCell)
                                .foregroundColor(.gray2)
                                .shortcutsZipBody2()
                        } else {
                            Text(selectedCategories.map { String( Category(rawValue: $0)!.translateName()) }.joined(separator: ", "))
                                .foregroundColor(.gray4)
                                .shortcutsZipBody2()
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
//                .sheet(isPresented: $isShowingCategoryModal) {
//                    CategoryModalView(viewModel: WriteShortcutModalViewModel(isShowingCategoryModal: isShowingCategoryModal),
//                                      isShowingCategoryModal: $isShowingCategoryModal,
//                                      selectedCategories: $shareExtensionViewModel.shortcut.category
//                    )
//                    .presentationDetents([.fraction(0.7)])
//                    .presentationDragIndicator(.visible)
//                }
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
                    .shortcutsZipHeadline()
                    .foregroundColor(.gray5)
                Text(TextLiteral.writeShortcutViewRequiredAppDescription)
                    .shortcutsZipFootnote()
                    .foregroundColor(.gray3)
                Spacer()
                Image(systemName: "info.circle.fill")
                    .smallIcon()
                    .frame(width: 20, height: 20)
                    .foregroundColor(.gray4)
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
                            .foregroundColor(.gray5)
                        HStack(alignment: .top) {
                            Text(TextLiteral.writeShortcutViewRequiredAppInformation)
                                .shortcutsZipFootnote()
                                .foregroundColor(.gray1)
                                .multilineTextAlignment(.leading)
                            Spacer()
                            Image(systemName: "xmark")
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
        @Binding var relatedApps: [String]
        @State var isTextFocused = [Bool](repeating: false, count: 5)
        @State var isTextFieldShowing = false
        @State var relatedApp = ""
        
        var body: some View {
            ScrollView(.horizontal) {
                HStack(spacing: 8) {
                    ForEach(relatedApps, id:\.self) { item in
                        RelatedAppTag(items: $relatedApps, item: item)
                    }
                    
                    if isTextFieldShowing {
                        ShareExtensionTagTextField(text: $relatedApp, isFirstResponder: $isTextFocused[4])
                            .modifier(ClearButton(text: $relatedApp))
                            .onAppear {
                                isTextFocused[4] = true
                            }
                            .onChange(of: isTextFocused[4]) { _ in
                                if !isTextFocused[4] {
                                    if !relatedApp.isEmpty {
                                        relatedApps.append(relatedApp)
                                        relatedApp = ""
                                    }
                                    isTextFieldShowing = false
                                }
                            }
                            .onSubmit {
                                isTextFocused[4] = false
                            }
                            .modifier(CellModifier(foregroundColor: Color.gray4, strokeColor: Color.shortcutsZipPrimary))
                    }
                    
                    Button(action: {
                        isTextFieldShowing = true
                        isTextFocused[4] = true
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
                Button(action: {
                    //TODO: 탭 되었을 때 수정 로직 추가
                }, label: {
                    Text(item)
                })
                
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
                .shortcutsZipBody2()
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

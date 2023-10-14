//
//  WriteShortcutTitleView.swift
//  HappyAnding
//
//  Created by 이지원 on 2022/10/19.
//

import SwiftUI
import LinkPresentation

struct WriteShortcutView: View {
    
    enum FocusableField: Hashable {
        case link
        case title
        case subtitle
        case description
        case requiredApp
    }
    
    @Environment(\.presentationMode) var presentationMode
    @FocusState var focusedField: FocusableField?
    @StateObject var viewModel: WriteShortcutViewModel
    
    @State private var metadata: LPLinkMetadata? = nil
    @State private var isFetchingMetadata = false
    
    let metadataProvider = LPMetadataProvider()
    
    private let gridLayout = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]
    
    var body: some View {
        ScrollViewReader { proxy in
            ScrollView(showsIndicators: false) {
                VStack(spacing: 32) {
                    iconModalView
                    shortcutLinkText
                        .id(FocusableField.link)
                        .focused($focusedField, equals: .link)
                    
                        .onChange(of: self.viewModel.shortcut.downloadLink[0]) { newDownloadLink in
                            guard !isFetchingMetadata else { return }
                            
                            guard !newDownloadLink.isEmpty, newDownloadLink.hasPrefix(TextLiteral.validationCheckTextFieldPrefix) else {
                                return
                            }
                            
                            isFetchingMetadata = true
                            
                            if let downloadURL = URL(string: newDownloadLink) {
                                let metadataProvider = LPMetadataProvider()
                                metadataProvider.startFetchingMetadata(for: downloadURL) { metadata, error in
                                    DispatchQueue.main.async {
                                        isFetchingMetadata = false
                                        if error != nil {
                                            return
                                        }
                                        if viewModel.shortcut.title.isEmpty && viewModel.isLinkValid {
                                            if let metadataTitle = metadata?.title {
                                                viewModel.shortcut.title = String(metadataTitle.prefix(20))
                                            }
                                        }
                                    }
                                }
                            } else {
                                return
                            }
                        }
                    
                        .onSubmit {
                            focusedField = .title
                        }
                        .submitLabel(.next)
                    shortcutTitleText
                        .id(FocusableField.title)
                        .focused($focusedField, equals: .title)
                        .onSubmit {
                            focusedField = .subtitle
                        }
                        .submitLabel(.next)
                    shortcutSubtitleText
                        .id(FocusableField.subtitle)
                        .focused($focusedField, equals: .subtitle)
                        .onSubmit {
                            focusedField = .description
                        }
                        .submitLabel(.next)
                    shortcutDescriptionText
                        .id(FocusableField.description)
                        .focused($focusedField, equals: .description)
                    shortcutCategory
                    shortcutsRequiredApp
                        .id(FocusableField.requiredApp)
                        .focused($focusedField, equals: .requiredApp)
                }
            }
            .scrollDismissesKeyboard(.interactively)
            .onChange(of: focusedField) { id in
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    withAnimation {
                        proxy.scrollTo(id, anchor: .bottom)
                    }
                }
            }
            .background(Color.shortcutsZipBackground)
            .navigationTitle(viewModel.isEdit ? TextLiteral.writeShortcutViewEdit : TextLiteral.writeShortcutViewPost)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        self.presentationMode.wrappedValue.dismiss()
                    } label: {
                        Text(TextLiteral.cancel)
                            .shortcutsZipBody1()
                            .foregroundColor(.gray5)
                    }
                }
                
                // MARK: -업로드 버튼
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        viewModel.uploadShortcut()
                        self.presentationMode.wrappedValue.dismiss()
                    }, label: {
                        Text(TextLiteral.upload)
                            .shortcutsZipHeadline()
                            .foregroundColor(.shortcutsZipPrimary)
                            .opacity(viewModel.isUnavailableUploadButton() ? 0.3 : 1)
                    })
                    .disabled(viewModel.isUnavailableUploadButton())
                }
            }
        }
    }
    
    
    
    //MARK: -아이콘 모달 버튼
    private var iconModalView: some View {
        Button(action: {
            viewModel.isShowingIconModal = true
        }, label: {
            ZStack(alignment: .center) {
                Rectangle()
                    .fill(!viewModel.shortcut.sfSymbol.isEmpty ? Color.fetchGradient(color: viewModel.shortcut.color) : Color.fetchDefaultGradient())
                    .cornerRadius(12.35)
                Image(systemName: !viewModel.shortcut.sfSymbol.isEmpty ? viewModel.shortcut.sfSymbol : "plus")
                    .mediumIcon()
                    .foregroundColor(!viewModel.shortcut.sfSymbol.isEmpty ? .textIcon : .gray5)
            }
            .frame(width: 84, height: 84)
        })
        .sheet(isPresented: $viewModel.isShowingIconModal) {
            IconModalView(
                viewModel: WriteShortcutModalViewModel(),
                isShowingIconModal: $viewModel.isShowingIconModal,
                iconColor: $viewModel.shortcut.color,
                iconSymbol: $viewModel.shortcut.sfSymbol)
            .presentationDetents([.large])
            .presentationDragIndicator(.visible)
        }
        .padding(.top, 40)
        .padding(.bottom, 32)
    }
    
    //MARK: -단축어 링크
    private var shortcutLinkText: some View {
        ValidationCheckTextField(textType: .mandatory,
                                 isMultipleLines: false,
                                 title: TextLiteral.writeShortcutViewLinkTitle,
                                 placeholder: TextLiteral.writeShortcutViewLinkPlaceholder,
                                 lengthLimit: nil,
                                 isDownloadLinkTextField: true,
                                 content: $viewModel.shortcut.downloadLink[0],
                                 isValid: $viewModel.isLinkValid
        )
    }
    
    //MARK: -단축어 이름
    private var shortcutTitleText: some View {
        VStack(alignment: .leading) {
            ValidationCheckTextField(textType: .mandatory,
                                     isMultipleLines: false,
                                     title: TextLiteral.writeShortcutViewNameTitle,
                                     placeholder: TextLiteral.writeShortcutViewNamePlaceholder,
                                     lengthLimit: 20,
                                     isDownloadLinkTextField: false,
                                     content: $viewModel.shortcut.title,
                                     isValid: $viewModel.isNameValid
            )
            .onAppear(perform : UIApplication.shared.hideKeyboard)
            if isFetchingMetadata {
                ProgressView()
                    .frame(width: 20, height: 20)
                    .padding(.horizontal, 16)
            }
        }

    }
    
    //MARK: -한줄 설명
    private var shortcutSubtitleText: some View {
        ValidationCheckTextField(textType: .mandatory,
                                 isMultipleLines: false,
                                 title: TextLiteral.writeShortcutViewOneLineTitle,
                                 placeholder: TextLiteral.writeShortcutViewOneLinePlaceholder,
                                 lengthLimit: 20,
                                 isDownloadLinkTextField: false,
                                 content: $viewModel.shortcut.subtitle,
                                 isValid: $viewModel.isOneLineValid
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
                                 content: $viewModel.shortcut.description,
                                 isValid: $viewModel.isMultiLineValid
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
            
            categoryList(isShowingCategoryModal: $viewModel.isShowingCategoryModal, selectedCategories: $viewModel.shortcut.category)
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
                            Text(selectedCategories.map { Category(rawValue: $0)!.translateName() }.joined(separator: ", "))
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
                .sheet(isPresented: $isShowingCategoryModal) {
                    CategoryModalView(
                        isShowingCategoryModal: $isShowingCategoryModal,
                        selectedCategories: $selectedCategories )
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
                    .shortcutsZipHeadline()
                    .foregroundColor(.gray5)
                Text(TextLiteral.writeShortcutViewRequiredAppDescription)
                    .shortcutsZipFootnote()
                    .foregroundColor(.gray3)
                Spacer()
                Image(systemName: "info.circle.fill")
                    .smallIcon()
                    .foregroundColor(.gray4)
                    .onTapGesture {
                        viewModel.isInfoButtonTouched.toggle()
                    }
            }
            .padding(.horizontal, 16)
            ZStack(alignment: .top) {
                relatedAppList(viewModel: viewModel)
                    .padding(.bottom, 44)
                if viewModel.isInfoButtonTouched {
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
                                .smallIcon()
                                .frame(width: 16, height: 16)
                                .foregroundColor(.gray1)
                                .onTapGesture {
                                    viewModel.isInfoButtonTouched = false
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
        
        @StateObject var viewModel: WriteShortcutViewModel
        
        var body: some View {
            ScrollView(.horizontal) {
                HStack(spacing: 8) {
                    ForEach(viewModel.shortcut.requiredApp, id:\.self) { item in
                        RelatedAppTag(viewModel: viewModel, item: item)
                    }
                    
                    if viewModel.isTextFieldShowing {
                        TextField("", text: $viewModel.relatedApp)
                            .modifier(ClearButton(text: $viewModel.relatedApp))
                            .focused($isFocused)
                            .onAppear {
                                isFocused = true
                            }
                            .onChange(of: isFocused) { _ in
                                if !isFocused {
                                    if !viewModel.relatedApp.isEmpty {
                                        viewModel.shortcut.requiredApp.append(viewModel.relatedApp)
                                        viewModel.relatedApp = ""
                                    }
                                    viewModel.isTextFieldShowing = false
                                }
                            }
                            .modifier(CellModifier(foregroundColor: Color.gray4, strokeColor: Color.shortcutsZipPrimary))
                    }
                    
                    Button(action: {
                        viewModel.isTextFieldShowing = true
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
        @StateObject var viewModel: WriteShortcutViewModel
        
        var item: String
        
        var body: some View {
            HStack {
                Text(item)
                
                Button(action: {
                    viewModel.shortcut.requiredApp.removeAll { $0 == item }
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
    private struct CellModifier: ViewModifier {
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

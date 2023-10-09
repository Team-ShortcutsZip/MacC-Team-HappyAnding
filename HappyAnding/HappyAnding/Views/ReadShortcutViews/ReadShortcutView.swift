//
//  ReadShortcutView.swift
//  HappyAnding
//
//  Created by 이지원 on 2022/10/19.
//

import SwiftUI

import WrappingHStack

struct ReadShortcutView: View {
    @Environment(\.presentationMode) var presentation: Binding<PresentationMode>
    @Environment(\.openURL) private var openURL
    @Environment(\.loginAlertKey) var loginAlerter
    
    @StateObject var viewModel: ReadShortcutViewModel
    @StateObject var writeNavigation = WriteShortcutNavigation()
    
    @AppStorage("useWithoutSignIn") var useWithoutSignIn: Bool = false
    @FocusState private var isFocused: Bool
    @Namespace var namespace
    @Namespace var bottomID
    
    private let tabItems = [TextLiteral.readShortcutViewBasicTabTitle, TextLiteral.readShortcutViewVersionTabTitle, TextLiteral.readShortcutViewCommentTabTitle]
    private let hapticManager = HapticManager.instance
    
    var body: some View {
        ZStack {
            ScrollViewReader { proxy in
                ScrollView {
                    VStack(spacing: 0) {
                        StickyHeader(height: 40)
                        
                        /// 단축어 타이틀
                        ReadShortcutViewHeader(viewModel: self.viewModel)
                        
                        /// 탭뷰 (기본 정보, 버전 정보, 댓글)
                        LazyVStack(pinnedViews: [.sectionHeaders]) {
                            Section(header: tabBarView) {
                                ZStack {
                                    TabView(selection: $viewModel.currentTab) {
                                        Color.clear
                                            .tag(0)
                                        Color.clear
                                            .tag(1)
                                        Color.clear
                                            .tag(2)
                                    }
                                    .tabViewStyle(.page(indexDisplayMode: .never))
                                    .frame(minHeight: UIScreen.screenHeight / 2)
                                    
                                    switch viewModel.currentTab {
                                    case 0:
                                        ReadShortcutContentView(viewModel: self.viewModel)
                                    case 1:
                                        ReadShortcutVersionView(viewModel: self.viewModel)
                                    case 2:
                                        ReadShortcutCommentView(viewModel: self.viewModel)
                                            .id(bottomID)
                                    default:
                                        EmptyView()
                                    }
                                }
                                .animation(.easeInOut, value: viewModel.currentTab)
                                .padding(.top, 4)
                                .padding(.horizontal, 16)
                            }
                        }
                    }
                }
                .onAppear {
                    NotificationCenter.default.addObserver(forName: UIResponder.keyboardDidShowNotification, object: nil, queue: .main) {
                        notification in
                        withAnimation {
                            if viewModel.currentTab == 2 && !viewModel.isEditingComment && viewModel.comment.depth == 0 {
                                proxy.scrollTo(bottomID, anchor: .bottom)
                            }
                        }
                    }
                }
            }
            .scrollDisabled(viewModel.isEditingComment)
            .background(Color.shortcutsZipBackground)
            .navigationBarBackground ({ Color.shortcutsZipWhite })
            .navigationBarTitleDisplayMode(NavigationBarItem.TitleDisplayMode.inline)
            .navigationBarItems(trailing: readShortcutViewNavigationBarItems())
            .toolbar(.hidden, for: .tabBar)
            .safeAreaInset(edge: .bottom, spacing: 0) {
                
                /// Safe Area에 고정된 댓글창, 다운로드 버튼
                VStack {
                    if !viewModel.isEditingComment {
                        if viewModel.currentTab == 2 {
                            commentTextField
                        }
                        if !isFocused {
                            Button {
                                if !useWithoutSignIn {
                                    if let url = URL(string: viewModel.shortcut.downloadLink[0]) {
                                        viewModel.checkIfDownloaded()
                                        viewModel.isDownloadingShortcut = true
                                        openURL(url)
                                    }
                                    hapticManager.notification(type: .success)
                                    viewModel.updateNumberOfDownload(index: 0)
                                } else {
                                    loginAlerter.isPresented = true
                                }
                            } label: {
                                Text("다운로드 | \(Image(systemName: "arrow.down.app.fill")) \(viewModel.shortcut.numberOfDownload)")
                                    .shortcutsZipBody1()
                                    .foregroundColor(Color.textIcon)
                                    .padding()
                                    .frame(maxWidth: .infinity)
                                    .background(Color.shortcutsZipPrimary)
                            }
                        }
                    }
                }
                .ignoresSafeArea(.keyboard)
            }
            .onAppear {
                UINavigationBar.appearance().standardAppearance.configureWithTransparentBackground()
            }
            .onDisappear {
                viewModel.onViewDisappear()
            }
            .alert(TextLiteral.readShortcutViewDeletionTitle, isPresented: $viewModel.isDeletingShortcut) {
                Button(role: .cancel) {
                } label: {
                    Text(TextLiteral.cancel)
                }
                
                Button(role: .destructive) {
                    viewModel.deleteShortcut()
                    self.presentation.wrappedValue.dismiss()
                } label: {
                    Text(TextLiteral.delete)
                }
            } message: {
                Text(viewModel.isDowngradingUserLevel ? TextLiteral.readShortcutViewDeletionMessageDowngrade : TextLiteral.readShortcutViewDeletionMessage)
            }
            .fullScreenCover(isPresented: $viewModel.isEditingShortcut) {
                NavigationRouter(content: writeShortcutView,
                                 path: $writeNavigation.navigationPath)
                .environmentObject(writeNavigation)
                .onDisappear {
                    viewModel.refreshShortcut()
                }
            }
            .fullScreenCover(isPresented: $viewModel.isUpdatingShortcut) {
                UpdateShortcutView(viewModel: self.viewModel)
            }
            
            /// 댓글 수정할 때 뒷 배경을 어둡게 만들기 위한 뷰
            if viewModel.isEditingComment {
                Color.black
                    .ignoresSafeArea()
                    .opacity(0.4)
                    .safeAreaInset(edge: .bottom, spacing: 0) {
                        commentTextField
                            .ignoresSafeArea(.keyboard)
                            .focused($isFocused, equals: true)
                            .task {
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                    isFocused = true
                                }
                            }
                    }
                    .onAppear {
                        viewModel.commentText = viewModel.comment.contents
                    }
                    .onTapGesture(count: 1) {
                        isFocused.toggle()
                        viewModel.isUndoingCommentEdit.toggle()
                    }
                    .alert(TextLiteral.readShortcutViewDeleteFixesTitle, isPresented: $viewModel.isUndoingCommentEdit) {
                        Button(role: .cancel) {
                            isFocused.toggle()
                        } label: {
                            Text(TextLiteral.readShortcutViewKeepFixes)
                        }
                        
                        Button(role: .destructive) {
                            withAnimation(.easeInOut) {
                                viewModel.cancelEditingComment()
                            }
                        } label: {
                            Text(TextLiteral.delete)
                        }
                    } message: {
                        Text(TextLiteral.readShortcutViewDeleteFixes)
                    }
            }
        }
    }
    
    @ViewBuilder
    private func writeShortcutView() -> some View {
        WriteShortcutView(viewModel: WriteShortcutViewModel(isEdit: true, shortcut: viewModel.shortcut))
    }
}

extension ReadShortcutView {
    
    // MARK: - 댓글창
    
    private var commentTextField: some View {
        
        VStack(spacing: 0) {
            if viewModel.comment.depth == 1 && !viewModel.isEditingComment {
                nestedCommentTargetView
            }
            HStack {
                if viewModel.comment.depth == 1 && !viewModel.isEditingComment {
                    Image(systemName: "arrow.turn.down.right")
                        .smallIcon()
                        .foregroundColor(.gray4)
                }
                TextField(useWithoutSignIn ? TextLiteral.readShortcutViewCommentDescriptionBeforeLogin : TextLiteral.readShortcutViewCommentDescription, text: $viewModel.commentText, axis: .vertical)
                    .keyboardType(.twitter)
                    .disabled(useWithoutSignIn)
                    .disableAutocorrection(true)
                    .textInputAutocapitalization(.never)
                    .shortcutsZipBody2()
                    .lineLimit(viewModel.comment.depth == 1 ? 2 : 4)
                    .focused($isFocused)
                    .onAppear {
                        UIApplication.shared.hideKeyboard()
                    }
                
                Button {
                    viewModel.postComment()
                    isFocused.toggle()
                } label: {
                    Image(systemName: "paperplane.fill")
                        .mediumIcon()
                        .foregroundColor(viewModel.commentText == "" ? Color.gray2 : Color.gray5)
                }
                .disabled(viewModel.commentText == "" ? true : false)
            }
            .padding(.vertical, 12)
            .padding(.horizontal, 16)
            .background(
                Rectangle()
                    .fill(Color.gray1)
                    .cornerRadius(12 ,corners: (viewModel.comment.depth == 1) && (!viewModel.isEditingComment) ? [.bottomLeft, .bottomRight] : .allCorners)
            )
            .padding(.horizontal, 16)
            .padding(.bottom, 20)
        }
    }
    
    private var nestedCommentTargetView: some View {
        
        HStack {
            Text("@ \(viewModel.nestedCommentTarget)")
                .shortcutsZipFootnote()
                .foregroundColor(.gray5)
            
            Spacer()
            
            Button {
                viewModel.cancelNestedComment()
            } label: {
                Image(systemName: "xmark")
                    .smallIcon()
                    .foregroundColor(.gray5)
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 11)
        .background(
            Rectangle()
                .fill(Color.gray2)
                .cornerRadius(12 ,corners: [.topLeft, .topRight])
        )
        .padding(.horizontal, 16)
    }
    
    // MARK: - 내비게이션바 아이템
    
    @ViewBuilder
    private func readShortcutViewNavigationBarItems() -> some View {
        if viewModel.checkAuthor() {
            Menu {
                Section {
                    editButton
                    updateButton
                    shareButton
                    deleteButton
                }
            } label: {
                Image(systemName: "ellipsis")
                    .mediumIcon()
                    .foregroundColor(.gray4)
            }
        } else {
            shareButton
        }
    }
    
    private var editButton: some View {
        Button {
            viewModel.isEditingShortcut.toggle()
        } label: {
            Label(TextLiteral.edit, systemImage: "square.and.pencil")
        }
    }
    
    private var updateButton: some View {
        Button {
            viewModel.isUpdatingShortcut.toggle()
        } label: {
            Label(TextLiteral.update, systemImage: "clock.arrow.circlepath")
        }
    }
    
    private var shareButton: some View {
        Button {
            viewModel.shareShortcut()
        } label: {
            Label(TextLiteral.share, systemImage: "square.and.arrow.up")
                .foregroundColor(.gray4)
                .fontWeight(.medium)
        }
    }
    
    private var deleteButton: some View {
        Button(role: .destructive) {
            viewModel.checkDowngrading()
        } label: {
            Label(TextLiteral.delete, systemImage: "trash.fill")
        }
    }
    
    // MARK: - 탭바
    
    private var tabBarView: some View {
        HStack(spacing: 20) {
            ForEach(Array(zip(self.tabItems.indices, self.tabItems)), id: \.0) { index, name in
                tabBarItem(title: name, tabID: index)
            }
        }
        .padding(.horizontal, 16)
        .frame(height: 36)
        .background(Color.shortcutsZipWhite)
    }
    
    private func tabBarItem(title: String, tabID: Int) -> some View {
        Button {
            viewModel.moveTab(to: tabID)
        } label: {
            VStack {
                if viewModel.currentTab == tabID {
                    Text(title)
                        .shortcutsZipHeadline()
                        .foregroundColor(.gray5)
                    Color.gray5
                        .frame(height: 2)
                        .matchedGeometryEffect(id: "underline", in: namespace, properties: .frame)
                    
                } else {
                    Text(title)
                        .shortcutsZipBody1()
                        .foregroundColor(.gray3)
                    Color.clear.frame(height: 2)
                }
            }
            .animation(.spring(), value: viewModel.currentTab)
        }
        .buttonStyle(.plain)
    }
}

extension ReadShortcutView {
    
    //MARK: - 단축어 타이틀
    
    struct ReadShortcutViewHeader: View {
        @Environment(\.loginAlertKey) var loginAlerter
        @EnvironmentObject var shortcutsZipViewModel: ShortcutsZipViewModel
        
        @StateObject var viewModel: ReadShortcutViewModel
        
        @AppStorage("useWithoutSignIn") var useWithoutSignIn: Bool = false
        
        private let hapticManager = HapticManager.instance
        
        var body: some View {
            VStack(alignment: .leading, spacing: 16) {
                HStack {
                    
                    /// 단축어 아이콘
                    VStack {
                        Image(systemName: viewModel.shortcut.sfSymbol)
                            .mediumShortcutIcon()
                            .foregroundColor(Color.textIcon)
                    }
                    .frame(width: 52, height: 52)
                    .background(Color.fetchGradient(color: viewModel.shortcut.color))
                    .cornerRadius(8)
                    
                    Spacer()
                    
                    /// 좋아요 버튼
                    Text("\(viewModel.isMyLike ? Image(systemName: "heart.fill") : Image(systemName: "heart")) \(viewModel.numberOfLike)")
                        .shortcutsZipBody2()
                        .padding(10)
                        .foregroundColor(viewModel.isMyLike ? Color.textIcon : Color.gray4)
                        .background(viewModel.isMyLike ? Color.shortcutsZipPrimary : Color.gray1)
                        .cornerRadius(12)
                        .onTapGesture {
                            if !useWithoutSignIn {
                                viewModel.isMyLike.toggle()
                                viewModel.numberOfLike += viewModel.isMyLike ? 1 : -1
                                hapticManager.impact(style: .rigid)
                            } else {
                                loginAlerter.isPresented = true
                            }
                        }
                }
                
                /// 단축어 이름, 한 줄 설명
                VStack(alignment: .leading, spacing: 4) {
                    Text("\(viewModel.shortcut.title)")
                        .shortcutsZipTitle1()
                        .foregroundColor(Color.gray5)
                        .fixedSize(horizontal: false, vertical: true)
                    
                    Text("\(viewModel.shortcut.subtitle)")
                        .shortcutsZipBody1()
                        .foregroundColor(Color.gray3)
                        .fixedSize(horizontal: false, vertical: true)
                }
                
                /// 단축어 작성자 닉네임
                UserNameCell(userInformation: viewModel.author, gradeImage: viewModel.userGrade)
            }
            .frame(maxWidth: .infinity, minHeight: 160, alignment: .leading)
            .padding(.bottom, 20)
            .padding(.horizontal, 16)
            .background(Color.shortcutsZipWhite)
        }
    }
    
    //MARK: - 기본 정보 탭
    
    struct ReadShortcutContentView: View {
        
        @StateObject var viewModel: ReadShortcutViewModel
        
        var body: some View {
            VStack(alignment: .leading, spacing: 24) {
                
                VStack(alignment: .leading) {
                    Text(TextLiteral.readShortcutContentViewDescription)
                        .shortcutsZipBody2()
                        .foregroundColor(Color.gray4)
                    Text(viewModel.shortcut.description)
                        .shortcutsZipBody2()
                        .foregroundColor(Color.gray5)
                        .lineLimit(nil)
                }
                
                splitList(title: TextLiteral.readShortcutContentViewCategory, content: viewModel.shortcut.category)
                
                if !viewModel.shortcut.requiredApp.isEmpty {
                    splitList(title: TextLiteral.readShortcutContentViewRequiredApps, content: viewModel.shortcut.requiredApp)
                }
                
                Spacer()
                    .frame(maxHeight: .infinity)
            }
            .padding(.top, 16)
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        
        private func splitList(title: String, content: [String]) -> some View {
            
            VStack(alignment: .leading) {
                
                Text(title)
                    .shortcutsZipBody2()
                    .foregroundColor(Color.gray4)
                
                WrappingHStack(content, id: \.self, alignment: .leading, spacing: .constant(8), lineSpacing: 8) { item in
                    if Category.allCases.contains(where: { $0.rawValue == item }) {
                        Text(Category(rawValue: item)?.translateName() ?? "")
                            .shortcutsZipBody2()
                            .padding(.trailing, 8)
                            .foregroundColor(Color.gray5)
                    } else {
                        Text(item)
                            .shortcutsZipBody2()
                            .padding(.trailing, 8)
                            .foregroundColor(Color.gray5)
                    }
                    if item != content.last {
                        Divider()
                    }
                }
            }
        }
    }
    
    //MARK: - 버전 정보 탭
    
    struct ReadShortcutVersionView: View {
        
        @Environment(\.openURL) var openURL
        @Environment(\.loginAlertKey) var loginAlerter
        @EnvironmentObject var shortcutsZipViewModel: ShortcutsZipViewModel
        
        @StateObject var viewModel: ReadShortcutViewModel
        
        @AppStorage("useWithoutSignIn") var useWithoutSignIn: Bool = false
        
        var body: some View {
            VStack(alignment: .leading, spacing: 16) {
                
                if viewModel.shortcut.updateDescription.count == 1 {
                    Text(TextLiteral.readShortcutVersionViewNoUpdates)
                        .shortcutsZipBody2()
                        .foregroundColor(.gray4)
                        .padding(.top, 16)
                } else {
                    Text(TextLiteral.readShortcutVersionViewUpdateContent)
                        .shortcutsZipBody2()
                        .foregroundColor(.gray4)
                    
                    versionView
                }
                
                Spacer()
                    .frame(maxHeight: .infinity)
            }
            .padding(.top, 16)
        }
        
        private var versionView: some View {
            
            ForEach(Array(zip(viewModel.shortcut.updateDescription, viewModel.shortcut.updateDescription.indices)), id: \.0) { data, index in
                VStack(alignment: .leading, spacing: 12) {
                    HStack {
                        Text("Ver \(viewModel.shortcut.updateDescription.count - index).0")
                            .shortcutsZipBody2()
                            .foregroundColor(.gray5)
                        
                        Spacer()
                        
                        Text(viewModel.shortcut.date[index].getVersionUpdateDateFormat())
                            .shortcutsZipBody2()
                            .foregroundColor(.gray3)
                    }
                    
                    if data.trimmingCharacters(in: .whitespacesAndNewlines) != "" {
                        Text(data)
                            .shortcutsZipBody2()
                            .foregroundColor(.gray5)
                    }
                    
                    if index != 0 {
                        Button {
                            if !useWithoutSignIn {
                                if let url = URL(string: viewModel.shortcut.downloadLink[index]) {
                                    viewModel.checkIfDownloaded()
                                    viewModel.updateNumberOfDownload(index: index)
                                    openURL(url)
                                }
                            } else {
                                loginAlerter.isPresented = true
                            }
                        } label: {
                            Text(TextLiteral.readShortcutVersionViewDownloadPreviousVersion)
                                .shortcutsZipBody2()
                                .foregroundColor(.shortcutsZipPrimary)
                        }
                    }
                    
                    Divider()
                        .foregroundColor(.gray1)
                }
            }
        }
    }
    
    //MARK: - 댓글 탭
    
    struct ReadShortcutCommentView: View {
        
        @EnvironmentObject var shortcutsZipViewModel: ShortcutsZipViewModel
        
        @StateObject var viewModel: ReadShortcutViewModel
        
        @AppStorage("useWithoutSignIn") var useWithoutSignIn: Bool = false
        
        @FocusState var isFocused: Bool
        
        var body: some View {
            VStack(alignment: .leading) {
                
                if viewModel.comments.comments.isEmpty {
                    Text(TextLiteral.readShortcutCommentViewNoComments)
                        .shortcutsZipBody2()
                        .foregroundColor(.gray4)
                        .padding(.top, 16)
                } else {
                    commentView
                }
                
                Spacer()
                    .frame(maxHeight: .infinity)
            }
            .padding(.top, 16)
            .alert(TextLiteral.readShortcutCommentViewDeletionTitle, isPresented: $viewModel.isDeletingComment) {
                Button(role: .cancel) {
                    
                } label: {
                    Text(TextLiteral.cancel)
                }
                
                Button(role: .destructive) {
                    viewModel.deleteComment()
                } label: {
                    Text(TextLiteral.delete)
                }
            } message: {
                Text(TextLiteral.readShortcutCommentViewDeletionMessage)
            }
        }
        
        private var commentView: some View {
            
            ForEach(viewModel.comments.comments, id: \.self) { comment in
                
                HStack(alignment: .top, spacing: 8) {
                    if comment.depth == 1 {
                        Image(systemName: "arrow.turn.down.right")
                            .smallIcon()
                            .foregroundColor(.gray4)
                    }
                    
                    VStack(alignment: .leading, spacing: 8) {
                        
                        /// 유저 정보
                        HStack(spacing: 8) {
                            
                            viewModel.fetchUserGrade(id: comment.user_id)
                                .font(.system(size: 24, weight: .medium))
                                .frame(width: 24, height: 24)
                                .foregroundColor(.gray3)
                            
                            Text(comment.user_nickname)
                                .shortcutsZipBody2()
                                .foregroundColor(.gray4)
                        }
                        .padding(.bottom, 4)
                        
                        /// 댓글 내용
                        Text(comment.contents)
                            .shortcutsZipBody2()
                            .foregroundColor(.gray5)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        /// 답글, 수정, 삭제 버튼
                        HStack(spacing: 0) {
                            if !useWithoutSignIn {
                                Button {
                                    viewModel.setReply(to: comment)
                                    isFocused = true
                                } label: {
                                    Text(TextLiteral.readShortcutCommentViewReply)
                                        .shortcutsZipFootnote()
                                        .foregroundColor(.gray4)
                                        .frame(width: 32, height: 24)
                                }
                            }
                            
                            if let user = shortcutsZipViewModel.userInfo {
                                if user.id == comment.user_id {
                                    Button {
                                        withAnimation(.easeInOut) {
                                            viewModel.isEditingComment.toggle()
                                            viewModel.comment = comment
                                        }
                                    } label: {
                                        Text(TextLiteral.readShortcutCommentViewEdit)
                                            .shortcutsZipFootnote()
                                            .foregroundColor(.gray4)
                                            .frame(width: 32, height: 24)
                                    }
                                    
                                    Button {
                                        viewModel.isDeletingComment.toggle()
                                        viewModel.deletedComment = comment
                                    } label: {
                                        Text(TextLiteral.delete)
                                            .shortcutsZipFootnote()
                                            .foregroundColor(.gray4)
                                            .frame(width: 32, height: 24)
                                    }
                                }
                            }
                        }
                        
                        Divider()
                            .background(Color.gray1)
                    }
                }
                .padding(.bottom, 16)
            }
        }
    }
}

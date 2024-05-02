//
//  ReadShortcutView.swift
//  HappyAnding
//
//  Created by 이지원 on 2022/10/19.
//

import SwiftUI

struct ReadShortcutView: View {
    @Environment(\.presentationMode) var presentation: Binding<PresentationMode>
    @Environment(\.openURL) private var openURL
    @Environment(\.loginAlertKey) var loginAlerter
    
    
    @AppStorage("useWithoutSignIn") var useWithoutSignIn: Bool = false
    
    @StateObject var viewModel: ReadShortcutViewModel
    @FocusState private var isFocused: Bool
    
    @State var isCommentSectionActivated = false
    
    
    var body: some View {
        ScrollViewReader { proxy in
            ScrollView {
                VStack(alignment: .leading, spacing: 12) {
                    //Header - 단축어 기본정보 (title, subtitle, author)
                    ReadShortcutHeader(viewModel: self.viewModel)
                        .padding(.top, 16)
                    
                    //TODO: 이미지 없는경우 예외처리
                    
                    //                Divider()
                    //                    .background(SCZColor.CharcoalGray.opacity08)
                    //                    .padding(.vertical, 8)
                    //
                    //이미지
                    //                ScrollView(.horizontal) {
                    //                }
                    //                .padding(.horizontal, 8)
                    
                    Divider()
                        .background(SCZColor.CharcoalGray.opacity08)
                        .padding(.vertical, 8)
                    
                    //description
                    Text(viewModel.shortcut.description.replacingOccurrences(of: "\\n", with: "\n"))
                        .descriptionReadable()
                        .foregroundStyle(SCZColor.CharcoalGray.color)
                        .padding(8)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    if !viewModel.shortcut.requiredApp.isEmpty {
                        Divider()
                            .background(SCZColor.CharcoalGray.opacity08)
                            .padding(.vertical, 8)
                        
                        //필요한 앱
                        VStack(alignment: .leading, spacing: 16) {
                            HStack(spacing: 6) {
                                SectionTitle(text: TextLiteral.readShortcutContentViewRequiredApps)
                                Image(systemName: "info.circle.fill")
                                    .customSF(size: 20)
                                    .foregroundStyle(SCZColor.CharcoalGray.opacity24)
                            }
                            VStack(alignment: .leading) {
                                ForEach(viewModel.shortcut.requiredApp, id: \.self) { requirement in
                                    Text(requirement)
                                        .medium16()
                                        .foregroundStyle(SCZColor.CharcoalGray.opacity88)
                                        .roundedBackground(background: SCZColor.CharcoalGray.opacity08)
                                }
                            }
                        }
                        .padding(.horizontal, 8)
                    }
                    
                    Divider()
                        .background(SCZColor.CharcoalGray.opacity08)
                        .padding(.vertical, 8)
                    
                    //버전 업데이트 정보
                    VStack(alignment: .leading, spacing: 6) {
                        HStack {
                            SectionTitle(text: TextLiteral.readShortcutViewVersionTitle)
                            Spacer()
                            Menu {
                                Button(TextLiteral.readShortcutViewFilterNew) {
                                    withAnimation {
                                        viewModel.isVersionFolded = true
                                    }
                                }
                                Button(TextLiteral.readShortcutViewFilterAll) {
                                    withAnimation {
                                        viewModel.isVersionFolded = false
                                    }
                                }
                            } label: {
                                HStack(spacing: 4) {
                                    Text(viewModel.isVersionFolded ? TextLiteral.readShortcutViewFilterNew : TextLiteral.readShortcutViewFilterAll)
                                        .body1()
                                    Image(systemName: "chevron.down")
                                        .customSF(size: 12)
                                }
                                .foregroundStyle(SCZColor.CharcoalGray.opacity64)
                                .roundedBackground(background: SCZColor.CharcoalGray.opacity04)
                            }
                        }
                        VStack(alignment: .leading, spacing: 8) {
                            UpdateListItem(
                                isLatest: true,
                                version: viewModel.shortcut.updateDescription.count - 0,
                                description: viewModel.shortcut.updateDescription[0],
                                date: viewModel.shortcut.date[0],
                                openDownloadURL: {
                                    if !useWithoutSignIn {
                                        if let url = URL(string: viewModel.shortcut.downloadLink[0]) {
                                            viewModel.checkIfDownloaded()
                                            viewModel.isDownloadingShortcut = true
                                            openURL(url)
                                        }
                                        viewModel.updateNumberOfDownload(index: 0)
                                    } else {
                                        loginAlerter.isPresented = true
                                    }
                                }
                            )
                            
                            if !viewModel.isVersionFolded {
                                ForEach(1..<viewModel.shortcut.downloadLink.count, id: \.self) { index in
                                    Divider()
                                        .background(SCZColor.CharcoalGray.opacity08)
                                        .padding(.vertical, 8)
                                    UpdateListItem(
                                        version: viewModel.shortcut.updateDescription.count - index,
                                        description: viewModel.shortcut.updateDescription[index],
                                        date: viewModel.shortcut.date[index],
                                        openDownloadURL: {
                                            if !useWithoutSignIn {
                                                if let url = URL(string: viewModel.shortcut.downloadLink[0]) {
                                                    viewModel.checkIfDownloaded()
                                                    viewModel.isDownloadingShortcut = true
                                                    openURL(url)
                                                }
                                                viewModel.updateNumberOfDownload(index: 0)
                                            } else {
                                                loginAlerter.isPresented = true
                                            }
                                        }
                                    )
                                }
                            }
                        }
                    }
                    .padding(8)
                    
                    Divider()
                        .background(SCZColor.CharcoalGray.opacity08)
                        .padding(.vertical, 8)
                    
                    VStack(alignment: .leading, spacing: 16){
                        SectionTitle(text: TextLiteral.readShortcutContentViewCategory)
                        HStack {
                            ForEach (0..<viewModel.shortcut.category.count, id: \.self) { index in
                                Text(Category(rawValue: viewModel.shortcut.category[index])?.translateName() ?? "")
                                    .regular16()
                                    .foregroundStyle(SCZColor.CharcoalGray.opacity64)
                                    .roundedBackground(background: SCZColor.CharcoalGray.opacity04)
                            }
                        }
                    }
                    .padding(.horizontal, 8)
                    
                    Rectangle()
                        .frame(height: 16)
                        .padding(.horizontal, -16)
                        .foregroundStyle(SCZColor.CharcoalGray.opacity08)
                        .padding(.vertical, 8)
                    
                    ReadShortcutCommentView(viewModel: self.viewModel, isFocused: _isFocused)
                }
                .padding(.horizontal, 16)
            }
            .navigationBarTitleDisplayMode(.inline)
            .safeAreaInset(edge: .bottom, spacing: 0) {
                
                if !isCommentSectionActivated {
                    /// Safe Area에 고정된 댓글창, 다운로드 버튼
                    ZStack (alignment: .center) {
                        LinearGradient(colors: [Color.clear, SCZColor.systemWhite], startPoint: .top, endPoint: .bottom)
                            .allowsHitTesting(false)
                        LinearGradient(colors: [Color.clear, SCZColor.CharcoalGray.opacity16], startPoint: .top, endPoint: .bottom)
                            .allowsHitTesting(false)
                        Button {
                            if !useWithoutSignIn {
                                if let url = URL(string: viewModel.shortcut.downloadLink[0]) {
                                    viewModel.checkIfDownloaded()
                                    viewModel.isDownloadingShortcut = true
                                    openURL(url)
                                }
                                viewModel.updateNumberOfDownload(index: 0)
                            } else {
                                loginAlerter.isPresented = true
                            }
                        } label: {
                            HStack(spacing: 8) {
                                Text("\(viewModel.shortcut.numberOfDownload)")
                                    .font(.system(size: 14))
                                    .foregroundStyle(SCZColor.systemWhite)
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 8)
                                    .background(SCZColor.systemWhite.opacity(0.12))
                                    .clipShape(RoundedRectangle(cornerRadius: 16))
                                Triangle()
                                    .fill(SCZColor.systemWhite.opacity(0.12))
                                    .frame(width: 6, height: 6)
                                    .rotationEffect(.degrees(90))
                                    .padding(.horizontal, -8)
                                Image(systemName: "arrow.down.to.line")
                                Text("받기")
                                    .medium16()
                            }
                            .foregroundStyle(SCZColor.systemWhite)
                            .frame(maxWidth: .infinity)
                            .frame(height: 54)
                            .background(SCZColor.SCZBlue.opacity88)
                            .roundedBorder(cornerRadius: 16, color: SCZColor.systemWhite.opacity(0.12))
                            .padding(.horizontal, 16)
                        }
                    }
                    .ignoresSafeArea()
                    .frame(height: isFocused ? 10.5 : 86)
                }
            }
            .onReceive(viewModel.commentText.publisher) { _ in
                DispatchQueue.main.async {
                    proxy.scrollTo("CommentTextField", anchor: .bottom)
                }
            }
            .onChange(of: self.isFocused) { _ in
                if isFocused {
                    DispatchQueue.main.async {
                        withAnimation {
                            proxy.scrollTo("CommentTextField", anchor: .bottom)
                        }
                    }
                }
            }
        }
        .toolbar(.hidden, for: .tabBar)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                HStack (spacing: 24) {
                    HStack (spacing: 4){
                        if viewModel.isMyLike {
                            HStack (spacing: 0) {
                                Text(TextLiteral.readShortcutViewShortcutHeart)
                                    .font(.system(size: 13, weight: .medium))
                                    .padding(8)
                                    .foregroundStyle(SCZColor.CharcoalGray.opacity64)
                                    .background(SCZColor.CharcoalGray.opacity08)
                                    .roundedBorder(cornerRadius: 16, color: Color.clear, isNormalBlend: true)
                                Triangle()
                                    .fill(SCZColor.CharcoalGray.opacity08)
                                    .frame(width: 6, height: 6)
                                    .rotationEffect(.degrees(90))
                            }
                        }
                        Button {
                            if !useWithoutSignIn {
                                viewModel.toggleIsMyLike()
                            } else {
                                loginAlerter.isPresented = true
                            }
                        } label: {
                            Image(systemName: viewModel.isMyLike ? "heart.fill" : "heart")
                                .customSF(size: 19)
                                .foregroundStyle(viewModel.isMyLike ? SCZColor.SCZBlue.strong : SCZColor.CharcoalGray.opacity48)
                        }
                    }
                    
                    Menu {
                        Button(TextLiteral.share) {
                            viewModel.shareShortcut()
                        }
                        if viewModel.checkAuthor() {
                            Button(TextLiteral.edit) {
                                //TODO: 수정 화면 연결
                                viewModel.isEditingShortcut.toggle()
                            }
                            Button(TextLiteral.delete) {
                                viewModel.checkDownGrading()
                            }
                        } else {
                            Button(TextLiteral.report) {
                            }
                        }
                    } label: {
                        Image(systemName: "ellipsis")
                            .customSF(size: 18)
                            .foregroundStyle(SCZColor.CharcoalGray.opacity48)
                    }
                }
            }
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
    }
}

struct UpdateListItem: View {
    var isLatest = false
    let version: Int
    let description: String
    let date: String
    
    var openDownloadURL: () -> ()
    
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Button {
                    openDownloadURL()
                } label: {
                    Text("Ver \(version).0")
                        .underline()
                        .medium16()
                        .foregroundStyle(SCZColor.CharcoalGray.opacity64)
                }
                if isLatest {
                    Image(systemName: "sparkles")
                        .customSF(size: 24)
                        .foregroundStyle(SCZColor.CharcoalGray.opacity88)
                }
            }
            if !description.isEmpty {
                Text(description)
                    .regular16()
                    .foregroundStyle(SCZColor.CharcoalGray.color)
            }
            Text(date.getVersionDateFormat() ?? "")
                .regular16()
                .foregroundStyle(SCZColor.CharcoalGray.opacity48)
        }
    }
}

private struct SectionTitle: View {
    let text: String
    var body: some View {
        Text(text)
            .medium16()
            .foregroundStyle(SCZColor.CharcoalGray.opacity48)
    }
}

struct ReadShortcutHeader: View {
    @StateObject var viewModel: ReadShortcutViewModel
    var body: some View {
        HStack(spacing: 8) {
            ShortcutIcon(sfSymbol: viewModel.shortcut.sfSymbol, color: viewModel.shortcut.color, size: 96)
                .padding(.horizontal, 8)
            
            VStack(alignment: .leading, spacing: 3) {
                Text(viewModel.shortcut.subtitle)
                    .body1()
                    .foregroundStyle(SCZColor.CharcoalGray.opacity48)
                Text(viewModel.shortcut.title)
                    .title1()
                    .foregroundStyle(SCZColor.Medium)
                
                Spacer()
                HStack(spacing: 4) {
                    //TODO: 프로필 이미지 적용 필요
                    viewModel.fetchUserGrade(id: viewModel.author.id)
                        .customSF(size: 32)
                        .foregroundStyle(SCZColor.CharcoalGray.opacity04)
                    Text(viewModel.author.nickname.isEmpty ? TextLiteral.withdrawnUser : viewModel.author.nickname)
                        .subTitle1()
                        .foregroundStyle(SCZColor.CharcoalGray.opacity88)
                }
            }
            .padding(.vertical, 5.5)
        }
    }
}

struct ReadShortcutCommentView: View {
    @EnvironmentObject var shortcutsZipViewModel: ShortcutsZipViewModel
    @StateObject var viewModel: ReadShortcutViewModel
    @AppStorage("useWithoutSignIn") var useWithoutSignIn: Bool = false
    
    @FocusState var isFocused: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            VStack(alignment: .leading, spacing: 8) {
                HStack(alignment: .center, spacing: 8) {
                    Image(systemName: "text.bubble.fill")
                        .foregroundStyle(SCZColor.CharcoalGray.opacity24)
                    Text(TextLiteral.readShortcutViewCommentTitle)
                        .foregroundStyle(SCZColor.CharcoalGray.opacity48)
                        .semiBold17()
                }
                Divider()
                    .background(SCZColor.CharcoalGray.opacity08)
                    .padding(.vertical, 8)
            }
            
            commentView
            
            commentTextField
        }
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
        
        ForEach(Array(viewModel.comments.comments.enumerated()), id: \.element) { index, comment in
            if comment.depth == 0 && index != 0 {
                Divider()
                    .background(SCZColor.CharcoalGray.opacity04)
            }
            HStack(alignment: .top, spacing: 8) {
                if comment.depth == 1 {
                    Image(systemName: "arrow.turn.down.right")
                        .customSF(size: 19)
                        .foregroundStyle(SCZColor.CharcoalGray.opacity24)
                }
                viewModel.fetchUserGrade(id: comment.user_id)
                    .customSF(size: 27)
                
                VStack(alignment: .leading, spacing: 12) {
                    /// 유저 정보
                    HStack(spacing: 8) {
                        Text(comment.user_nickname)
                            .medium16()
                            .foregroundStyle(SCZColor.CharcoalGray.color)
                        Text(comment.date.getCommentDateFormat())
                            .medium16()
                            .foregroundStyle(SCZColor.CharcoalGray.opacity48)
                        Spacer()
                        if let user = shortcutsZipViewModel.userInfo {
                            if user.id == comment.user_id {
                                Menu {
                                    //수정
                                    Button {
                                        withAnimation(.easeInOut) {
                                            viewModel.isEditingComment.toggle()
                                            viewModel.comment = comment
                                            viewModel.commentText = comment.contents
                                            isFocused  = true
                                        }
                                    } label: {
                                        Text(TextLiteral.readShortcutCommentViewEdit)
                                            .shortcutsZipFootnote()
                                            .foregroundStyle(Color.gray4)
                                            .frame(width: 32, height: 24)
                                    }
                                    //삭제
                                    Button {
                                        viewModel.isDeletingComment.toggle()
                                        viewModel.deletedComment = comment
                                    } label: {
                                        Text(TextLiteral.delete)
                                            .shortcutsZipFootnote()
                                            .foregroundStyle(Color.gray4)
                                            .frame(width: 32, height: 24)
                                    }
                                } label: {
                                    Image(systemName: "ellipsis")
                                        .customSF(size: 18)
                                        .foregroundStyle(SCZColor.CharcoalGray.opacity48)
                                }
                            }
                        }
                    }
                    .medium16()
                    
                    /// 댓글 내용
                    Text(.init(comment.contents))
                        .textSelection(.enabled)
                        .regular16()
                        .foregroundStyle(SCZColor.CharcoalGray.opacity88)
                        .tint(.shortcutsZipPrimary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    if comment.depth == 0 {
                        HStack(alignment: .center, spacing: 18) {
                            if !useWithoutSignIn {
                                HStack(spacing: 4) {
                                    //하트
                                    Button {
                                        
                                    } label: {
                                        Image(systemName: "heart.fill")
                                            .customSF(size: 17)
                                            .foregroundStyle(SCZColor.CharcoalGray.opacity16)
                                    }
                                }.frame(width: 64, alignment: .leading)
                                HStack(spacing: 4) {
                                    //대댓글
                                    Button {
                                        viewModel.setReply(to: comment)
                                        isFocused = true
                                        //스크롤?
                                    } label: {
                                        Image(systemName: "bubble.left.and.text.bubble.right.fill")
                                            .customSF(size: 22)
                                            .foregroundStyle(SCZColor.CharcoalGray.opacity24)
                                    }
                                    let num = viewModel.getReplyNumber(bundleId: comment.bundle_id)
                                    if num != 0 {
                                        Text(num.formatNumber())
                                            .numRegular16()
                                            .foregroundStyle(SCZColor.CharcoalGray.opacity64)
                                    }
                                }
                            }
                        }
                    }
                }
            }
            .padding(.top, comment.depth == 1 ? 8 : 0)
        }
    }
    
    private var commentTextField: some View {
        
        VStack(spacing: 0) {
            if viewModel.comment.depth == 1 && !viewModel.isEditingComment {
                nestedCommentTargetView
            }
            HStack(spacing: 8) {
                TextField(useWithoutSignIn ? TextLiteral.readShortcutViewCommentDescriptionBeforeLogin : TextLiteral.readShortcutViewCommentDescription, text: $viewModel.commentText, axis: .vertical)
                    .focused($isFocused)
                    .padding(.leading, 16)
                    .padding(.vertical, viewModel.commentText.isEmpty ? 10 : 12)
                    .textFieldStyle(CommentTextFieldStyle())
                    .disabled(useWithoutSignIn)
                
                VStack(alignment: .center, spacing: 6) {
                    Button {
                        viewModel.postComment()
                        isFocused.toggle()
                    } label: {
                        Image(systemName: viewModel.commentText.count > 512 ? "xmark.circle.fill" : "arrow.up.circle.fill")
                            .customSF(size: 32)
                            .foregroundStyle(
                                viewModel.commentText.isEmpty ? SCZColor.CharcoalGray.opacity24 : 
                                                                viewModel.commentText.count > 512 ? SCZColor.systemWhite : SCZColor.systemWhite,
                                viewModel.commentText.isEmpty ? SCZColor.CharcoalGray.opacity08 :
                                                                viewModel.commentText.count > 512 ? SCZColor.SCZRed.red : SCZColor.SCZBlue.strong
                            )
                    }
                    .disabled(viewModel.commentText == "" || viewModel.commentText.count > 512 ? true : false)
                    
                    if viewModel.commentText.count > 512 {
                        Text("-\(viewModel.commentText.count - 512)")
                            .body2()
                            .foregroundStyle(SCZColor.SCZRed.dangerouslyRed)
                    }
                }
                .padding(.trailing, 8)
            }
            .background(
                Rectangle()
                    .fill(SCZColor.CharcoalGray.opacity08)
                    .cornerRadius(16 ,corners: (viewModel.comment.depth == 1) && (!viewModel.isEditingComment) ? [.bottomLeft, .bottomRight] : .allCorners)
            )
        }
        .onAppear {
            UIApplication.shared.hideKeyboard()
        }
        .padding(.bottom, isFocused ? 7.5 : 70)
        .id("CommentTextField")
    }
    private var nestedCommentTargetView: some View {
        
        HStack {
            Text("@\(viewModel.nestedCommentTarget)")
                .lineLimit(1)
                .descriptionReadable()
                .foregroundStyle(SCZColor.CharcoalGray.opacity48)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            Button {
                viewModel.cancelReply()
            } label: {
                Image(systemName: "xmark")
                    .customSF(size: 15)
                    .foregroundStyle(SCZColor.CharcoalGray.opacity48)
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 16)
        .background(
            Rectangle()
                .fill(SCZColor.CharcoalGray.opacity16)
                .cornerRadius(16 ,corners: [.topLeft, .topRight])
        )
    }
}

private struct CommentTextFieldStyle: TextFieldStyle {
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .keyboardType(.default)
            .disableAutocorrection(true)
            .textInputAutocapitalization(.never)
            .descriptionReadable()
            .frame(maxWidth: .infinity, maxHeight: 271, alignment: .leading)
    }
}

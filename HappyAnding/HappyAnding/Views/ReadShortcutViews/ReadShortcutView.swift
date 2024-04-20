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
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                
                Text("\" \(viewModel.shortcut.subtitle) \"")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(SCZColor.Basic)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 10)
                    .background(SCZColor.CharcoalGray.opacity04)
                    .roundedBorder(cornerRadius: 16, color: Color.white.opacity(0.12), isNormalBlend: true)
                    .padding(.top, 8)
                
                Divider()
                    .padding(.vertical, 8)
                
                ReadShortcutHeader(viewModel: self.viewModel)
                
                Divider()
                    .padding(.vertical, 8)
                
                ScrollView(.horizontal) {
                    //TODO: 이미지 추가
                }
                .padding(.horizontal, 8)
                
                Divider()
                    .padding(.vertical, 8)
                Text(viewModel.shortcut.description.replacingOccurrences(of: "\\n", with: "\n"))
                    .font(.system(size: 14, weight: .regular))
                    .foregroundStyle(SCZColor.CharcoalGray.color)
                    .padding(8)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Divider()
                    .padding(.vertical, 8)
                
                VStack(alignment: .leading, spacing: 16) {
                    SectionTitle(text: "필요한 앱")
                    HStack {
                        ForEach(viewModel.shortcut.requiredApp, id: \.self) { requirement in
                            Text(requirement)
                                .roundedBackground()
                        }
                    }
                }
                .padding(.horizontal, 8)
                
                Divider()
                    .padding(.vertical, 8)
                
                VStack(alignment: .leading, spacing: 6) {
                    HStack {
                        SectionTitle(text: "버전 업데이트 정보")
                        Spacer()
                        Button {
                            
                        } label: {
                            HStack(spacing: 4) {
                                Text("최신")
                                Image(systemName: "chevron.down")
                            }
                            .roundedBackground()
                        }
                    }
                    ForEach(0..<viewModel.shortcut.downloadLink.count, id: \.self) { index in
                        UpdateListItem(
                            index: viewModel.shortcut.updateDescription.count - index,
                            description: viewModel.shortcut.updateDescription[index],
                            date: viewModel.shortcut.date[index]
                        )
                    }
                }
                .padding(8)
                
                ReadShortcutCommentView(viewModel: self.viewModel)
            }
            .padding(.horizontal, 16)
        }
    }
}

struct UpdateListItem: View {
    //"Ver \(viewModel.shortcut.updateDescription.count - index).0"
    let index: Int
    let description: String
    let date: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Text("Ver \(index).0")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundStyle(SCZColor.CharcoalGray.opacity64)
                Text("최신")
                    .roundedBackground()
            }
            Text(description)
            Text(date.getVersionDateFormat() ?? "")
                .foregroundStyle(SCZColor.CharcoalGray.opacity48)
        }.font(.system(size: 14, weight: .regular))
    }
}

private struct SectionTitle: View {
    let text: String
    var body: some View {
        Text(text)
            //Pretendard 14 medium
            .font(.system(size: 14, weight: .medium))
            .foregroundStyle(SCZColor.CharcoalGray.opacity48)
    }
}

struct ReadShortcutHeader: View {
    @StateObject var viewModel: ReadShortcutViewModel
    var body: some View {
        HStack(spacing: 12) {
            ShortcutIcon(sfSymbol: viewModel.shortcut.sfSymbol, color: viewModel.shortcut.color, size: 96)
                .padding(.horizontal, 8)
            
            VStack(alignment: .leading, spacing: 3) {
                Text(viewModel.shortcut.title)
                    .font(.system(size: 20, weight: .bold))
                    .foregroundStyle(SCZColor.CharcoalGray.color)
                    .frame(maxWidth: .infinity, alignment: .leading)
                HStack {
                    ForEach (0..<viewModel.shortcut.category.count, id: \.self) { index in
                        Text(viewModel.shortcut.category[index])
                            .font(.system(size: 14, weight: .medium))
                            .foregroundStyle(SCZColor.CharcoalGray.opacity48)
                            
                        
                        if index != viewModel.shortcut.category.count-1 {
                            RoundedRectangle(cornerRadius: 100)
                                .frame(width:2, height: 11)
                                .foregroundStyle(SCZColor.CharcoalGray.opacity08)
                        }
                    }
                }
                Spacer()
                HStack(spacing: 0) {
                    Image(systemName: "gearshape.circle.fill")// 프로필 이미지?
                        .padding(.trailing, 4)
                        .foregroundStyle(SCZColor.CharcoalGray.opacity04)
                    Text(viewModel.author.nickname.isEmpty ? TextLiteral.withdrawnUser : viewModel.author.nickname)
                        .foregroundStyle(SCZColor.CharcoalGray.opacity88)
                    Spacer()
                    Image(systemName:"gearshape.arrow.triangle.2.circlepath")
                        .foregroundStyle(SCZColor.CharcoalGray.opacity24)
                        .padding(.trailing, 2)
                    Text("\(viewModel.shortcut.downloadLink.count).0")
                        .foregroundStyle(SCZColor.CharcoalGray.opacity64)
                }
            }
            .padding(.vertical, 2)
        }
    }
}

#Preview{
    ReadShortcutView(
        viewModel: ReadShortcutViewModel(data: Shortcuts(
            sfSymbol: "alarm.fill",
            color: "Red",
            title: "title",
            subtitle: "subtitle",
            description: "가나다라마바사아자차카타파하가나다라마바사아자차카타파하가나다라마바사아자차카타파하가나다라마바사아자차카타파하가나다라마바사아자차카타파하가나다라마바사아자차카타파하가나다라마바사아자차카타파하가나다라마바사아자차카타파하가나다라마바사아자차카타파하가나다라마바사아자차카타파하가나다라마바사아자차카타파하가나다라마바사아자차카타파하가나다라마바사아자차카타파하가나다라마바사아자차카타파하가나다라마바사아자차카타파하",
            category: ["라이프스타일", "카테고리"],
            requiredApp: ["유튜브", "ShortcutsZip"],
            numberOfLike: 30,
            numberOfDownload: 3,
            author: "asdf",
            shortcutRequirements: "asdf",
            downloadLink: [""], curationIDs: [""])))
}


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
                    .foregroundStyle(Color.gray4)
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
                        .foregroundStyle(Color.gray4)
                }
                
                VStack(alignment: .leading, spacing: 8) {
                    
                    /// 유저 정보
                    HStack(spacing: 8) {
                        
                        viewModel.fetchUserGrade(id: comment.user_id)
                            .font(.system(size: 24, weight: .medium))
                            .frame(width: 24, height: 24)
                            .foregroundStyle(Color.gray3)
                        
                        Text(comment.user_nickname)
                            .shortcutsZipBody2()
                            .foregroundStyle(Color.gray4)
                        
                        Spacer()
                        
                        Text(comment.date.getVersionUpdateDateFormat())
                            .shortcutsZipFootnote()
                            .foregroundStyle(Color.gray4)
                    }
                    .padding(.bottom, 4)
                    
                    /// 댓글 내용
                    Text(.init(comment.contents))
                        .textSelection(.enabled)
                        .shortcutsZipBody2()
                        .foregroundStyle(Color.gray5)
                        .tint(.shortcutsZipPrimary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.leading, 4)
                    
                    /// 답글, 수정, 삭제 버튼
                    HStack(spacing: 0) {
                        if !useWithoutSignIn {
                            Button {
                                viewModel.setReply(to: comment)
                                isFocused = true
                            } label: {
                                Text(TextLiteral.readShortcutCommentViewReply)
                                    .shortcutsZipFootnote()
                                    .foregroundStyle(Color.gray4)
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
                                        .foregroundStyle(Color.gray4)
                                        .frame(width: 32, height: 24)
                                }
                                
                                Button {
                                    viewModel.isDeletingComment.toggle()
                                    viewModel.deletedComment = comment
                                } label: {
                                    Text(TextLiteral.delete)
                                        .shortcutsZipFootnote()
                                        .foregroundStyle(Color.gray4)
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

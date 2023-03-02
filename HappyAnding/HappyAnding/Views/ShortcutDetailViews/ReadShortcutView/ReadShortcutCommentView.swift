//
//  ReadShortcutCommentView.swift
//  HappyAnding
//
//  Created by 이지원 on 2022/11/21.
//

import SwiftUI

struct ReadShortcutCommentView: View {
    @EnvironmentObject var shortcutsZipViewModel: ShortcutsZipViewModel
    
    @AppStorage("useWithoutSignIn") var useWithoutSignIn: Bool = false
    
    @FocusState var isFocused: Bool
    
    @Binding var addedComment: Comment                  //추가되는 댓글
    @Binding var comments: Comments                     //화면에 그려지는 댓글들
    @Binding var nestedCommentInfoText: String          //대댓글 작성 시 텍스트필드 위에 뜨는 작성자 정보
    @Binding var isClickCorrenction: Bool
    
    @State var isTappedDeleteButton = false
    @State var deletedComment = Comment(user_nickname: "", user_id: "", date: "", depth: 0, contents: "")
    
    let shortcutID: String
    
    var body: some View {
        VStack(alignment: .leading) {
            if comments.comments.isEmpty {
                Text(TextLiteral.readShortcutCommentViewNoComments)
                    .Body2()
                    .foregroundColor(.gray4)
                    .padding(.top, 16)
                
                Spacer()
                    .frame(maxHeight: .infinity)
                
            } else {
                comment
                Spacer()
            }
        }
        .padding(.top, 16)
        .alert(TextLiteral.readShortcutCommentViewDeletionTitle, isPresented: $isTappedDeleteButton) {
            Button(role: .cancel) {
                
            } label: {
                Text(TextLiteral.cancel)
            }
            
            Button(role: .destructive) {
                if deletedComment.depth == 0 {
                    comments.comments.removeAll(where: { $0.bundle_id == deletedComment.bundle_id})
                } else {
                    comments.comments.removeAll(where: { $0.id == deletedComment.id})
                }
                
                shortcutsZipViewModel.setData(model: comments)
            } label: {
                Text(TextLiteral.delete)
            }
        } message: {
            Text(TextLiteral.readShortcutCommentViewDeletionMessage)
        }
    }
    
    var comment: some View {
        ForEach(comments.comments, id: \.self) { comment in
            
            HStack(alignment: .top, spacing: 8) {
                if comment.depth == 1 {
                    Image(systemName: "arrow.turn.down.right")
                        .smallIcon()
                        .foregroundColor(.gray4)
                }
                VStack(alignment: .leading, spacing: 8) {
                    
                    // MARK: 유저 정보
                    
                    HStack(spacing: 8) {
                        
                        Image(systemName: "person.crop.circle.fill")
                            .font(.system(size: 24, weight: .medium))
                            .frame(width: 24, height: 24)
                            .foregroundColor(.gray3)
                        
                        Text(comment.user_nickname)
                            .Body2()
                            .foregroundColor(.gray4)
                    }
                    .padding(.bottom, 4)
                    
                    
                    // MARK: 댓글 내용
                    
                    Text(comment.contents)
                        .Body2()
                        .foregroundColor(.gray5)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    // MARK: Button
                    HStack(spacing: 16) {
                        if !useWithoutSignIn {
                            Button {
                                nestedCommentInfoText = comment.user_nickname
                                addedComment.bundle_id = comment.bundle_id
                                addedComment.depth = 1
                                isFocused = true
                            } label: {
                                Text(TextLiteral.readShortcutCommentViewReply)
                                    .Footnote()
                                    .foregroundColor(.gray4)
                            }
                        }
                        
                        if let user = shortcutsZipViewModel.userInfo {
                            if user.id == comment.user_id {
                                Button {
                                    withAnimation(.easeInOut) {
                                        isClickCorrenction.toggle()
                                        addedComment = comment
                                    }
                                } label: {
                                    Text(TextLiteral.readShortcutCommentViewEdit)
                                        .Footnote()
                                        .foregroundColor(.gray4)
                                }
                                
                                
                                Button {
                                    isTappedDeleteButton.toggle()
                                    deletedComment = comment
                                } label: {
                                    Text(TextLiteral.delete)
                                        .Footnote()
                                        .foregroundColor(.gray4)
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

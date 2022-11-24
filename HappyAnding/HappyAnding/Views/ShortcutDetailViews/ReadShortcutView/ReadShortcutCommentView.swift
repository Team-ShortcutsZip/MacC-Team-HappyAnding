//
//  ReadShortcutCommentView.swift
//  HappyAnding
//
//  Created by 이지원 on 2022/11/21.
//

import SwiftUI

struct ReadShortcutCommentView: View {
    @EnvironmentObject var shortcutsZipViewModel: ShortcutsZipViewModel
    @Binding var addedComment: Comment
    @Binding var comments: Comments
    @Binding var nestedCommentInfoText: String
    @State var isTappedDeleteButton = false
    @State var deletedComment: Comment = Comment(user_nickname: "", user_id: "", date: "", depth: 0, contents: "")
    let shortcutID: String
    
    var body: some View {
        VStack(alignment: .leading) {
            if comments.comments.isEmpty {
                Text("등록된 댓글이 없습니다")
                    .Body2()
                    .foregroundColor(.Gray4)
            } else {
                comment
                Spacer()
            }
        }
        .padding(.top, 16)
        .alert("댓글 삭제", isPresented: $isTappedDeleteButton) {
            Button(role: .cancel) {
                
            } label: {
                Text("닫기")
            }
            
            Button(role: .destructive) {
                if deletedComment.depth == 0 {
                    comments.comments.removeAll(where: { $0.bundle_id == deletedComment.bundle_id})
                } else {
                    comments.comments.removeAll(where: { $0.id == deletedComment.id})
                }
                
                shortcutsZipViewModel.setData(model: comments)
            } label: {
                Text("삭제")
            }
        } message: {
            Text("답글도 함께 삭제됩니다. 댓글을 삭제하시겠습니까?")
        }
    }
    
    var comment: some View {
        ForEach(comments.comments, id: \.self) { comment in
            
            HStack(alignment: .top, spacing: 8) {
                if comment.depth == 1 {
                    Image(systemName: "arrow.turn.down.right")
                        .foregroundColor(.Gray4)
                }
                VStack(alignment: .leading, spacing: 8) {
                    
                    // MARK: 유저 정보
                    
                    HStack(spacing: 8) {
                        
                        Circle()
                            .frame(width: 24, height: 24)
                            .foregroundColor(.Gray4)
                        
                        Text(comment.user_nickname)
                            .Body2()
                            .foregroundColor(.Gray4)
                    }
                    .padding(.bottom, 4)
                    
                    
                    // MARK: 댓글 내용
                    
                    Text(comment.contents)
                        .Body2()
                        .foregroundColor(.Gray5)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    // MARK: Button
                    HStack(spacing: 16) {
                        Button {
                            nestedCommentInfoText = comment.user_nickname
                            addedComment.bundle_id = comment.bundle_id
                            addedComment.depth = 1
                        } label: {
                            Text("답글")
                                .Footnote()
                                .foregroundColor(.Gray4)
                        }
                        
                        Button {
                            print("수정")
                        } label: {
                            Text("수정")
                                .Footnote()
                                .foregroundColor(.Gray4)
                        }
                        
                        if let user = shortcutsZipViewModel.userInfo {
                            if user.id == comment.user_id {
                                Button {
                                    isTappedDeleteButton.toggle()
                                    deletedComment = comment
                                } label: {
                                    Text("삭제")
                                        .Footnote()
                                        .foregroundColor(.Gray4)
                                }
                            }
                        }
                    }
                    Divider()
                        .background(Color.Gray1)
                }
            }
            .padding(.bottom, 16)
        }
    }
}

//
//  ReadShortcutCommentView.swift
//  HappyAnding
//
//  Created by 이지원 on 2022/11/21.
//

import SwiftUI

struct ReadShortcutCommentView: View {
    @State var comments = [Comment]()
    @State var isReply = true
    
    var body: some View {
        VStack(alignment: .leading) {
            if comments.isEmpty {
                Text("등록된 댓글이 없습니다")
                    .Body2()
                    .foregroundColor(.Gray4)
                
            } else {
                comment
                Spacer()
            }
        }
        .onAppear {
            for _ in 0...10 {
                let comment = Comment(user_id: "1", date: "2022112211",
                                      depth: Int.random(in: 0...1),
                                      contents: "댓글을남겨요")
                comments.append(comment)
            }
        }
    }
    
    var comment: some View {
        ForEach(comments, id: \.self) { comment in
            
            HStack(alignment: .top, spacing: 8) {
                if comment.depth == 0 {
                    Image(systemName: "arrow.turn.down.right")
                        .foregroundColor(.Gray4)
                }
                VStack(alignment: .leading, spacing: 8) {
                    
                    // MARK: 유저 정보
                    
                    HStack(spacing: 8) {
                        
                        Circle()
                            .frame(width: 24, height: 24)
                            .foregroundColor(.Gray4)
                        
                        Text(comment.user_id)
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
                            print("답글")
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
                        
                        Button {
                            print("삭제")
                        } label: {
                            Text("삭제")
                                .Footnote()
                                .foregroundColor(.Gray4)
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

//
//  ReadShortcutCommentView.swift
//  HappyAnding
//
//  Created by 이지원 on 2022/11/21.
//

import SwiftUI

struct ReadShortcutCommentView: View {
    @State var isReply = true
    
    var body: some View {
        VStack {
            comment
            
            Spacer()
        }
    }
    
    var comment: some View {
        
        HStack(alignment: .top, spacing: 8) {
            if isReply {
                Image(systemName: "arrow.turn.down.right")
                    .foregroundColor(.Gray4)
            }
            VStack(alignment: .leading, spacing: 8) {
                
                // MARK: 유저 정보
                
                HStack(spacing: 8) {
                    
                    Circle()
                        .frame(width: 24, height: 24)
                        .foregroundColor(.Gray4)
                    
                    Text("로미")
                        .Body2()
                        .foregroundColor(.Gray4)
                }
                .padding(.bottom, 4)
                
                
                // MARK: 댓글 내용
                
                Text("카카오맵 / 네이버지도 선택 가능하도록 추가하였습니다.")
                    .Body2()
                    .foregroundColor(.Gray5)
                
                
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
            }
        }
    }
}

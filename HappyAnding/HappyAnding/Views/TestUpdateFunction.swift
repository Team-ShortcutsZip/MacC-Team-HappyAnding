//
//  TestUpdateFunction.swift
//  HappyAnding
//
//  Created by 전지민 on 2022/11/18.
//

import SwiftUI

struct TestUpdateFunction: View {
    
    @EnvironmentObject var shortcutsZipViewModel: ShortcutsZipViewModel
    @State var comments: Comments = Comments(id: UUID().uuidString, comments: [])
    @State var sortedComments: [Comment]?
    
    @State var reply: String = ""
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                HStack {
                    TextField("댓글을 입력하세요", text: $reply)
                    Button("입력") {
                        let reply = Comment(user_id: "userID", date: Date().getDate(), depth: 0, contents: reply)
                        comments.comments.append(reply)
                        shortcutsZipViewModel.setData(model: comments)
                    }
                }
                if let sortedComments {
                    ForEach(sortedComments, id: \.id) { comment in
                        Text(comment.contents)
                        Text(comment.date)
                        Text(comment.bundel_id)
                        Button("답글") {
                            let replyTOO = Comment(bundel_id: comment.bundel_id, user_id: "userID", date: Date().getDate(), depth: 1, contents: reply)
                            comments.comments.append(replyTOO)
                            shortcutsZipViewModel.setData(model: comments)
                        }
                        Divider()
                            .padding(.bottom, 10)
                    }
                }
            }
            .padding(20)
        }
        .onAppear() {
            shortcutsZipViewModel.fetchComment(shortcutID: "EC7185C0-1550-415F-BB76-FEF0FD5CA6E6", completionHandler: { comments in
                self.comments = comments
                
                sortedComments = comments.fetchSortedComment()
            })
            
        }
    }
}



//struct TestUpdateFunction_Previews: PreviewProvider {
//    static var previews: some View {
//        TestUpdateFunction()
//    }
//}

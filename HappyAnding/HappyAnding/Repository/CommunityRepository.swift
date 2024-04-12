//
//  File.swift
//  HappyAnding
//
//  Created by 임정욱 on 4/3/24.
//

import Foundation
import FirebaseCore
import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseAuth



class CommunityRepository {
    
    private let db = Firestore.firestore()
    
    private let postCollection: String = "Post"
    private let communityCommentCollection: String = "CommunityComment"
    private let answerCollection: String = "Answer"
    

    
    
//MARK: - 글 관련 함수
    
       
   // 모든 글 가져오기
   func getPosts(completion: @escaping ([Post]) -> Void) {
       db.collection(postCollection)
           .order(by: "createdAt", descending: true) // 최신 글부터 정렬
           .getDocuments { snapshot, error in
               if error != nil {
                   completion([])
                   return
               }
               let posts = snapshot?.documents.compactMap { document in
                   try? document.data(as: Post.self)
               } ?? []
               completion(posts)
           }
   }
    
    // 글 가져오기 무한스크롤
    func getPosts(limit: Int, lastCreatedAt: String? = nil, completion: @escaping ([Post]) -> Void) {
        var query: Query = db.collection(postCollection)
            .order(by: "createdAt", descending: true)
            .limit(to: limit)

        if let lastCreatedAt = lastCreatedAt {
            query = query.start(after: [lastCreatedAt])
        }

        query.getDocuments { snapshot, error in
            guard let snapshot = snapshot, error == nil else {
                completion([])
                return
            }
            
            let posts = snapshot.documents.compactMap { document -> Post? in
                try? document.data(as: Post.self)
            }
            
            completion(posts)
        }
    }
    
   
   // 글 생성
    func createPost(post: Post, completion: @escaping (Bool) -> Void) {
        let documentId = post.id
        do {
            try db.collection(postCollection).document(documentId).setData(from: post) { error in
                if error != nil {
                    completion(false)
                } else {
                    completion(true)
                }
            }
        } catch {
            completion(false)
        }
    }
   
   // 글 업데이트
    func updatePost(postid: String, content: String? = nil, shortcuts: [String]? = nil, images: [String]? = nil, completion: @escaping (Bool) -> Void) {
    
        var updateFields: [String: Any] = [:]
        
        if let content = content {
            updateFields["content"] = content
        }
        if let shortcuts = shortcuts {
            updateFields["shortcuts"] = shortcuts
        }
        if let images = images {
            updateFields["images"] = images
        }

        if !updateFields.isEmpty {
            db.collection(postCollection).document(postid).updateData(updateFields) { error in
                if error != nil {
                    completion(false)
                } else {
                    completion(true)
                }
            }
        } else {
            completion(true)
        }
    }
   
   // 글 삭제
    func deletePost(postId: String, completion: @escaping (Bool) -> Void) {
        let group = DispatchGroup()
        var overallSuccess = true
        
        // 게시물 삭제
        group.enter()
        db.collection(postCollection).document(postId).delete { error in
            if error != nil {
                overallSuccess = false
            }
            group.leave()
        }
        
        // 관련된 답변(Answer) 삭제
        group.enter()
        db.collection(answerCollection).whereField("postId", isEqualTo: postId).getDocuments { (snapshot, error) in
            guard let documents = snapshot?.documents else {
                overallSuccess = false
                group.leave()
                return
            }
            for document in documents {
                document.reference.delete()
            }
            group.leave()
        }
        
        // 관련된 댓글(CommunityComment) 삭제
        group.enter()
        db.collection(communityCommentCollection).whereField("postId", isEqualTo: postId).getDocuments { (snapshot, error) in
            guard let documents = snapshot?.documents else {
                overallSuccess = false
                group.leave()
                return
            }
            for document in documents {
                document.reference.delete()
            }
            group.leave()
        }
        
        // 모든 삭제 작업이 완료되었는지 확인
        group.notify(queue: .main) {
            completion(overallSuccess)
        }
    }
    
    
    // 글에 좋아요 추가
    func likePost(postId: String, userId: String, completion: @escaping (Bool) -> Void) {
        let postRef = db.collection(postCollection).document(postId)

        postRef.getDocument { (document, error) in
            if let document = document, let data = document.data(), error == nil {
                var likedBy = data["likedBy"] as? [String: Bool] ?? [:]
                
                if likedBy[userId] != true {
                    likedBy[userId] = true
                    let likeCount = (data["likeCount"] as? Int ?? 0) + 1

                    postRef.updateData([
                        "likedBy": likedBy,
                        "likeCount": likeCount
                    ]) { error in
                        if error != nil {
                            completion(false)
                        } else {
                            completion(true)
                        }
                    }
                } else {
                    completion(true)
                }
            } else {
                completion(false)
            }
        }
    }

    // 글에 좋아요 제거
    func unlikePost(postId: String, userId: String, completion: @escaping (Bool) -> Void) {
        let postRef = db.collection(postCollection).document(postId)
        
        postRef.getDocument { (document, error) in
            if let document = document, let data = document.data(), error == nil {
                var likedBy = data["likedBy"] as? [String: Bool] ?? [:]
                
                if likedBy[userId] == true {
                    likedBy.removeValue(forKey: userId)
                    let likeCount = max((data["likeCount"] as? Int ?? 0) - 1, 0)

                    postRef.updateData([
                        "likedBy": likedBy,
                        "likeCount": likeCount
                    ]) { error in
                        if error != nil {
                            completion(false)
                        } else {
                            completion(true)
                        }
                    }
                } else {
                    completion(true)
                }
            } else {
                completion(false)
            }
        }
    }
    

//MARK: - 답변 관련 함수
    
    func getAnswers(for postId: String, completion: @escaping ([Answer]) -> Void) {
        db.collection(answerCollection)
            .whereField("postId", isEqualTo: postId)
            .order(by: "createdAt", descending: true)
            .getDocuments { snapshot, error in
                
                if error != nil {
                    completion([])
                    return
                }
                
                let answers = snapshot?.documents.compactMap { document -> Answer? in
                    try? document.data(as: Answer.self)
                } ?? []
                completion(answers)
            }
    }
    
    func createAnswer(answer: Answer, completion: @escaping (Bool) -> Void) {
        let documentId = answer.id
        do {
            try db.collection(answerCollection).document(documentId).setData(from: answer) { error in
                if error != nil {
                    completion(false)
                } else {
                    completion(true)
                }
            }
        } catch {
            completion(false)
        }
    }
    
    func updateAnswer(answerId: String, content: String? = nil, images: [String]? = nil, completion: @escaping (Bool) -> Void) {
        
        var updateFields: [String: Any] = [:]
        
        if let newContent = content {
            updateFields["content"] = newContent
        }
        
        if let newImages = images {
            updateFields["images"] = newImages
        }

        if !updateFields.isEmpty {
            db.collection(answerCollection).document(answerId).updateData(updateFields) { error in
                if error != nil {
                    completion(false)
                } else {
                    completion(true)
                }
            }
        } else {
            completion(true)
        }
    }
    
    func acceptAnswer(answerId: String, completion: @escaping (Bool) -> Void) {
        let answerRef = db.collection(answerCollection).document(answerId)

        answerRef.updateData(["isAccepted": true]) { error in
            if error != nil {
                completion(false)
            } else {
                completion(true)
            }
        }
    }
    
    
    func deleteAnswer(answerId: String, completion: @escaping (Bool) -> Void) {
        db.collection(answerCollection).document(answerId)
            .delete() { error in
                if error != nil {
                    completion(false)
                } else {
                    completion(true)
                }
            }
    }
    
    func likeAnswer(answerId: String, userId: String, completion: @escaping (Bool) -> Void) {
        let answerRef = db.collection(answerCollection).document(answerId)
        
        answerRef.getDocument { (document, error) in
            if let document = document, let data = document.data(), error == nil {
                var likedBy = data["likedBy"] as? [String: Bool] ?? [:]
                
                if likedBy[userId] != true {
                    likedBy[userId] = true
                    
                    let likeCount = (data["likeCount"] as? Int ?? 0) + 1

                    answerRef.updateData([
                        "likedBy": likedBy,
                        "likeCount": likeCount
                    ]) { error in
                        if error != nil {
                            completion(false)
                        } else {
                            completion(true)
                        }
                    }
                } else {
                    completion(true)
                }
            } else {
                completion(false)
            }
        }
    }
    
    func unlikeAnswer(answerId: String, userId: String, completion: @escaping (Bool) -> Void) {
        let answerRef = db.collection(answerCollection).document(answerId)

        answerRef.getDocument { documentSnapshot, error in
            guard let document = documentSnapshot, let data = document.data(), error == nil else {
                completion(false)
                return
            }
            
            var likedBy = data["likedBy"] as? [String: Bool] ?? [:]
            
            if likedBy[userId] == true {
                likedBy.removeValue(forKey: userId)
                
                let likeCount = max((data["likeCount"] as? Int ?? 0) - 1, 0)

                answerRef.updateData([
                    "likedBy": likedBy,
                    "likeCount": likeCount
                ]) { error in
                    if error != nil {
                        completion(false)
                    } else {
                        completion(true)
                    }
                }
            } else {
                completion(true)
            }
        }
    }

//MARK: - 댓글 관련 함수
    
    // 특정 게시물의 댓글 가져오기
    func getComments(postId: String, completion: @escaping ([CommunityComment]) -> Void) {
        db.collection(communityCommentCollection)
            .whereField("postId", isEqualTo: postId)
            .order(by: "createdAt", descending: true)
            .getDocuments { (snapshot, error) in
                guard let documents = snapshot?.documents, error == nil else {
                    completion([])
                    return
                }
                let comments = documents.compactMap { document -> CommunityComment? in
                    try? document.data(as: CommunityComment.self)
                }
                completion(comments)
            }
    }
    
    // 댓글 생성
    func createComment(comment: CommunityComment, completion: @escaping (Bool) -> Void) {
        let documentId = comment.id
        let postId = comment.postId

  
        do {
            try db.collection(communityCommentCollection).document(documentId).setData(from: comment) { error in
                if error != nil {
                    completion(false)
                } else {
                    let postRef = self.db.collection(self.postCollection).document(postId)
                    postRef.updateData(["commentCount": FieldValue.increment(1.0)]) { error in
                        if error != nil {
                            completion(false)
                        } else {
     
                            completion(true)
                        }
                    }
                }
            }
        } catch {
            completion(false)
        }
    }
    
    // 댓글 수정
    func updateComment(commentId: String, content: String?, completion: @escaping (Bool) -> Void) {
        var updates: [String: Any] = [:]
        
        if let newContent = content {
            updates["content"] = newContent
        }

        if !updates.isEmpty {
            db.collection(communityCommentCollection).document(commentId).updateData(updates) { error in
                if let error = error {
                    print("안녕")
                    print(error)
                    completion(false)
                } else {
                    completion(true)
                }
            }
        } else {
            completion(true)
        }
    }
    
    // 댓글 삭제
    func deleteComment(commentId: String, completion: @escaping (Bool) -> Void) {
        let commentRef = db.collection(communityCommentCollection).document(commentId)
        
        commentRef.getDocument { (document, error) in
            guard let document = document, let commentData = document.data(), let postId = commentData["postId"] as? String else {
                completion(false)
                return
            }
            
            commentRef.delete() { error in
                if error != nil {
                    completion(false)
                } else {
                    let postRef = self.db.collection(self.postCollection).document(postId)
                    postRef.updateData(["commentCount": FieldValue.increment(-1.0)]) { error in
                        if error != nil {
                            completion(false)
                        } else {
                            completion(true)
                        }
                    }
                }
            }
        }
    }
    
    // 댓글에 좋아요 추가
    func likeComment(commentId: String, userId: String, completion: @escaping (Bool) -> Void) {
        let commentRef = db.collection(communityCommentCollection).document(commentId)
        
        commentRef.getDocument { (document, error) in
            if let document = document, let data = document.data(), error == nil {
                var likedBy = data["likedBy"] as? [String: Bool] ?? [:]
                
                if likedBy[userId] != true {
                    likedBy[userId] = true
                    
                    let likeCount = (data["likeCount"] as? Int ?? 0) + 1

                    commentRef.updateData([
                        "likedBy": likedBy,
                        "likeCount": likeCount
                    ]) { error in
                        if error != nil {
                            completion(false)
                        } else {
                            completion(true)
                        }
                    }
                } else {
                    completion(true)
                }
            } else {
                completion(false)
            }
        }
    }
    
    // 댓글에 좋아요 제거
    func unlikeComment(commentId: String, userId: String, completion: @escaping (Bool) -> Void) {
        let commentRef = db.collection(communityCommentCollection).document(commentId)
        
        commentRef.getDocument { documentSnapshot, error in
            guard let document = documentSnapshot, let data = document.data(), error == nil else {
                completion(false)
                return
            }
            
            var likedBy = data["likedBy"] as? [String: Bool] ?? [:]
            
            if likedBy[userId] == true {
                likedBy.removeValue(forKey: userId)
                
                let likeCount = max((data["likeCount"] as? Int ?? 0) - 1, 0)

                commentRef.updateData([
                    "likedBy": likedBy,
                    "likeCount": likeCount
                ]) { error in
                    if error != nil {
                        completion(false)
                    } else {
                        completion(true)
                    }
                }
            } else {
                completion(true)
            }
        }
    }
}

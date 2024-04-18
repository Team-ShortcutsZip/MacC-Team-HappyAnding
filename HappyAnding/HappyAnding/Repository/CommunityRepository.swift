//
//  File.swift
//  HappyAnding
//
//  Created by 임정욱 on 4/3/24.
//

import Foundation
import FirebaseCore
import FirebaseFirestore
import FirebaseStorage
import FirebaseFirestoreSwift
import FirebaseAuth
import SwiftUI


class CommunityRepository {
    
    private let db = Firestore.firestore()
    private let storage = Storage.storage().reference()
    
    private let postCollection: String = "Post"
    private let communityCommentCollection: String = "CommunityComment"
    private let answerCollection: String = "Answer"
    
    
    private func uploadImages(images: [UIImage], completion: @escaping ([String]?) -> Void) {
        var imageURLs = [String]()
        let imageUploadGroup = DispatchGroup()

        for image in images {
            imageUploadGroup.enter()
            let imageData = image.pngData()!
            let imageId = UUID().uuidString
            let imageRef = storage.child("community/\(imageId).png")

            imageRef.putData(imageData, metadata: nil) { metadata, error in
                if let error = error {
                    print(error.localizedDescription)
                    imageUploadGroup.leave()
                    return
                }

                imageRef.downloadURL { (url, error) in
                    if let error = error {
                        print(error.localizedDescription)
                        imageUploadGroup.leave()
                        return
                    }

                    if let downloadURL = url {
                        imageURLs.append(downloadURL.absoluteString)
                        imageUploadGroup.leave()
                    }
                }
            }
        }

        imageUploadGroup.notify(queue: .main) {
            if imageURLs.isEmpty {
                completion(nil)
            } else {
                completion(imageURLs)
            }
        }
    }
    
    
    private func deleteImages(with urls: [String], completion: @escaping (Bool) -> Void) {
        let storage = Storage.storage()
        
        // 카운터를 사용하여 모든 삭제 작업이 완료되었는지 추적합니다.
        var deleteCount = 0
        var deleteErrors = false

        for url in urls {
            // URL로부터 참조를 얻습니다.
            let ref = storage.reference(forURL: url)
            
            // 참조를 사용하여 이미지 삭제
            ref.delete { error in
                if let error = error {
                    deleteErrors = true
                }
                
                deleteCount += 1
                if deleteCount == urls.count {
                    completion(!deleteErrors)
                }
            }
        }
    }
    
    
    
    

    
    
//MARK: - 글 관련 함수
    
       
   // 모든 글 가져오기
   func getAllPosts(completion: @escaping ([Post]) -> Void) {
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
//    func createPost(post: Post, completion: @escaping (Bool) -> Void) {
//        let documentId = post.id
//        do {
//            try db.collection(postCollection).document(documentId).setData(from: post) { error in
//                if error != nil {
//                    completion(false)
//                } else {
//                    completion(true)
//                }
//            }
//        } catch {
//            completion(false)
//        }
//    }
//    
    
    // 글 생성 with images
    func createPost(post: Post, images: [UIImage]? = nil, thumbnailImages: [UIImage]? = nil, completion: @escaping (Bool) -> Void) {
        let documentId = post.id
        
        do {
            try db.collection(postCollection).document(documentId).setData(from: post) { error in
                if let error = error {
                    completion(false)
                    return
                }
                
                var imageURLs: [String] = []
                var thumbnailURLs: [String] = []
                let dispatchGroup = DispatchGroup()

                // 일반 이미지 업로드
                if let images = images, !images.isEmpty {
                    dispatchGroup.enter()
                    self.uploadImages(images: images) { urls in
                        if let urls = urls {
                            imageURLs = urls
                        }
                        dispatchGroup.leave()
                    }
                }

                // 썸네일 이미지 업로드
                if let thumbnails = thumbnailImages, !thumbnails.isEmpty {
                    dispatchGroup.enter()
                    self.uploadImages(images: thumbnails) { urls in
                        if let urls = urls {
                            thumbnailURLs = urls
                        }
                        dispatchGroup.leave()
                    }
                }

                // 모든 이미지 업로드가 완료된 후 Firestore 문서 업데이트
                dispatchGroup.notify(queue: .main) {
                    var updateData = [String: Any]()
                    if !imageURLs.isEmpty {
                        updateData["images"] = imageURLs
                    }
                    if !thumbnailURLs.isEmpty {
                        updateData["thumbnailImages"] = thumbnailURLs
                    }

                    if !updateData.isEmpty {
                        self.db.collection(self.postCollection).document(documentId).updateData(updateData) { error in
                            if let error = error {
                                completion(false)
                            } else {
                                completion(true)
                            }
                        }
                    } else {
                        // 업데이트할 데이터가 없으면 성공으로 처리
                        completion(true)
                    }
                }
            }
        } catch {
            completion(false)
        }
    }
    
   
//   // 글 업데이트
//    func updatePost(postid: String, content: String? = nil, shortcuts: [String]? = nil, images: [UIImage]? = nil, thumbnailImages: [UIImage]? = nil, completion: @escaping (Bool) -> Void) {
//    
//        var updateFields: [String: Any] = [:]
//        
//        if let content = content {
//            updateFields["content"] = content
//        }
//        if let shortcuts = shortcuts {
//            updateFields["shortcuts"] = shortcuts
//        }
//
//        if !updateFields.isEmpty {
//            db.collection(postCollection).document(postid).updateData(updateFields) { error in
//                if error != nil {
//                    completion(false)
//                } else {
//                    completion(true)
//                }
//            }
//        } else {
//            completion(true)
//        }
//    }
    
    func updatePost(postId: String, content: String? = nil, shortcuts: [String]? = nil, images: [UIImage]? = nil, thumbnailImages: [UIImage]? = nil, completion: @escaping (Bool) -> Void) {
        let db = Firestore.firestore()
        let documentRef = db.collection("posts").document(postId)

        var updateFields: [String: Any] = [:]
        if let content = content {
            updateFields["content"] = content
        }
        if let shortcuts = shortcuts {
            updateFields["shortcuts"] = shortcuts
        }

        documentRef.updateData(updateFields) { error in
            if let error = error {
                completion(false)
                return
            }

            // 이미지 업데이트 로직
            guard images != nil || thumbnailImages != nil else {
                completion(true)
                return
            }

            // 이미지 삭제 및 업로드
            documentRef.getDocument { document, error in
                if let document = document, document.exists {
                    let oldImageUrls = document.data()?["images"] as? [String] ?? []
                    let oldThumbnailUrls = document.data()?["thumbnailImages"] as? [String] ?? []

                    self.deleteImages(with: oldImageUrls + oldThumbnailUrls) { success in
                        if !success {
                            completion(false)
                            return
                        }

                        // 새 이미지와 썸네일 이미지 업로드
                        self.uploadImages(images: images ?? []) { newImageUrls in
                            self.uploadImages(images: thumbnailImages ?? []) { newThumbnailUrls in
                                var imageUpdateFields: [String: Any] = [:]
                                if let newImageUrls = newImageUrls {
                                    imageUpdateFields["images"] = newImageUrls
                                }
                                if let newThumbnailUrls = newThumbnailUrls {
                                    imageUpdateFields["thumbnailImages"] = newThumbnailUrls
                                }

                                if !imageUpdateFields.isEmpty {
                                    documentRef.updateData(imageUpdateFields) { error in
                                        completion(error == nil)
                                    }
                                } else {
                                    completion(true)
                                }
                            }
                        }
                    }
                } else {
                    completion(false)
                }
            }
        }
    }
    
    
    
   
   // 글 삭제
    func deletePost(postId: String, completion: @escaping (Bool) -> Void) {
        let group = DispatchGroup()
        var overallSuccess = true
        
        // 게시물의 이미지 URL을 가져오고 삭제
        group.enter()
        db.collection(postCollection).document(postId).getDocument { document, error in
            if let document = document, document.exists {
                let imageUrls = document.data()?["images"] as? [String] ?? []
                let thumbnailUrls = document.data()?["thumbnailImages"] as? [String] ?? []
                let allUrls = imageUrls + thumbnailUrls
                
                // 이미지 삭제 로직
                for url in allUrls {
                    let ref = Storage.storage().reference(forURL: url)
                    ref.delete { error in
                        if error != nil {
                            overallSuccess = false
                        }
                    }
                }
            }
            group.leave()
        }
        
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
    
//    func createAnswer(answer: Answer, completion: @escaping (Bool) -> Void) {
//        let documentId = answer.id
//        do {
//            try db.collection(answerCollection).document(documentId).setData(from: answer) { error in
//                if error != nil {
//                    completion(false)
//                } else {
//                    completion(true)
//                }
//            }
//        } catch {
//            completion(false)
//        }
//    }

    func createAnswer(answer: Answer, images: [UIImage]? = nil, thumbnailImages: [UIImage]? = nil, completion: @escaping (Bool) -> Void) {
        let documentId = answer.id  // Answer 객체의 ID를 사용

        do {
            try db.collection(answerCollection).document(documentId).setData(from: answer) { error in
                if let error = error {
                    completion(false)
                    return
                }

                var imageURLs: [String] = []
                var thumbnailURLs: [String] = []
                let dispatchGroup = DispatchGroup()

                // 일반 이미지 업로드
                if let images = images, !images.isEmpty {
                    dispatchGroup.enter()
                    self.uploadImages(images: images) { urls in
                        if let urls = urls {
                            imageURLs = urls
                        }
                        dispatchGroup.leave()
                    }
                }

                // 썸네일 이미지 업로드
                if let thumbnails = thumbnailImages, !thumbnails.isEmpty {
                    dispatchGroup.enter()
                    self.uploadImages(images: thumbnails) { urls in
                        if let urls = urls {
                            thumbnailURLs = urls
                        }
                        dispatchGroup.leave()
                    }
                }

                // 모든 이미지 업로드가 완료된 후 Firestore 문서 업데이트
                dispatchGroup.notify(queue: .main) {
                    var updateData = [String: Any]()
                    if !imageURLs.isEmpty {
                        updateData["images"] = imageURLs
                    }
                    if !thumbnailURLs.isEmpty {
                        updateData["thumbnailImages"] = thumbnailURLs
                    }

                    if !updateData.isEmpty {
                        self.db.collection(self.answerCollection).document(documentId).updateData(updateData) { error in
                            completion(error == nil)
                        }
                    } else {
                        // 업데이트할 데이터가 없으면 성공으로 처리
                        completion(true)
                    }
                }
            }
        } catch {
            completion(false)
        }
    }
    
//    func updateAnswer(answerId: String, content: String? = nil, images: [String]? = nil, completion: @escaping (Bool) -> Void) {
//        
//        var updateFields: [String: Any] = [:]
//        
//        if let newContent = content {
//            updateFields["content"] = newContent
//        }
//        
//        if let newImages = images {
//            updateFields["images"] = newImages
//        }
//
//        if !updateFields.isEmpty {
//            db.collection(answerCollection).document(answerId).updateData(updateFields) { error in
//                if error != nil {
//                    completion(false)
//                } else {
//                    completion(true)
//                }
//            }
//        } else {
//            completion(true)
//        }
//    }
    
    
    
    
    func updateAnswer(answerId: String, content: String? = nil, images: [UIImage]? = nil, thumbnailImages: [UIImage]? = nil, completion: @escaping (Bool) -> Void) {
        let db = Firestore.firestore()
        let documentRef = db.collection(answerCollection).document(answerId)

        var updateFields: [String: Any] = [:]
        if let content = content {
            updateFields["content"] = content
        }

        documentRef.updateData(updateFields) { error in
            if let error = error {
                completion(false)
                return
            }

            // 이미지 업데이트 로직
            guard images != nil || thumbnailImages != nil else {
                completion(true)
                return
            }

            // 이미지 삭제 및 업로드
            documentRef.getDocument { document, error in
                if let document = document, document.exists {
                    let oldImageUrls = document.data()?["images"] as? [String] ?? []
                    let oldThumbnailUrls = document.data()?["thumbnailImages"] as? [String] ?? []

                    self.deleteImages(with: oldImageUrls + oldThumbnailUrls) { success in
                        if !success {
                            completion(false)
                            return
                        }

                        // 새 이미지와 썸네일 이미지 업로드
                        self.uploadImages(images: images ?? []) { newImageUrls in
                            self.uploadImages(images: thumbnailImages ?? []) { newThumbnailUrls in
                                var imageUpdateFields: [String: Any] = [:]
                                if let newImageUrls = newImageUrls {
                                    imageUpdateFields["images"] = newImageUrls
                                }
                                if let newThumbnailUrls = newThumbnailUrls {
                                    imageUpdateFields["thumbnailImages"] = newThumbnailUrls
                                }

                                if !imageUpdateFields.isEmpty {
                                    documentRef.updateData(imageUpdateFields) { error in
                                        completion(error == nil)
                                    }
                                } else {
                                    completion(true)
                                }
                            }
                        }
                    }
                } else {
                    completion(false)
                }
            }
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
    
    
//    func deleteAnswer(answerId: String, completion: @escaping (Bool) -> Void) {
//        db.collection(answerCollection).document(answerId)
//            .delete() { error in
//                if error != nil {
//                    completion(false)
//                } else {
//                    completion(true)
//                }
//            }
//    }
    
    
    
    func deleteAnswer(answerId: String, completion: @escaping (Bool) -> Void) {
        let db = Firestore.firestore()
        let group = DispatchGroup()
        var overallSuccess = true
        
        // 답변의 이미지 URL을 가져오고 삭제
        group.enter()
        db.collection(answerCollection).document(answerId).getDocument { document, error in
            if let document = document, document.exists {
                let imageUrls = document.data()?["images"] as? [String] ?? []
                let thumbnailUrls = document.data()?["thumbnailImages"] as? [String] ?? []
                let allUrls = imageUrls + thumbnailUrls

                // 이미지 삭제 로직
                for url in allUrls {
                    let ref = Storage.storage().reference(forURL: url)
                    ref.delete { error in
                        if error != nil {
                            overallSuccess = false
                        }
                    }
                }
            }
            group.leave()
        }
        
        // 답변 삭제
        group.enter()
        db.collection(answerCollection).document(answerId).delete { error in
            if error != nil {
                overallSuccess = false
            }
            group.leave()
        }
        
        // 모든 삭제 작업이 완료되었는지 확인
        group.notify(queue: .main) {
            completion(overallSuccess)
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

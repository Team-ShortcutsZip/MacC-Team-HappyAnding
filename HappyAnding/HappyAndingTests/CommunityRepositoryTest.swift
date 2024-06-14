//
//  CommunityRepositoryTest.swift
//  HappyAndingTests
//
//  Created by 임정욱 on 4/4/24.
//

import XCTest
@testable import HappyAnding // YourAppName을 앱의 이름으로 변경

class FirestoreTests: XCTestCase {
    
    
    var repository: CommunityRepository!
    
    override func setUp() {
        super.setUp()
        repository = CommunityRepository()
    }
    
    override func tearDown() {
        repository = nil
        super.tearDown()
    }
    
    private let testPostId = "8F242D05-3FB4-4604-880A-93A99B3F77AF"
    private let testAnswerId = "CECD1EBA-2157-41ED-AA24-AEBD4D105272"
    private let testCommentId = "C644F4BF-5F32-4F67-B2D8-18F182A1FB2C"
    

//MARK: - 글 관련 테스트
    


    // 모든 글 가져오기 테스트
    func testGetAllPosts() {
        let expectation = self.expectation(description: "getPosts")
        
        repository.getAllPosts { posts in
            
            print("\n")
            
            for post in posts {
                print(post)
            }
            
            print("\n")
            
            XCTAssertNotNil(posts, "Should not return nil")
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 5, handler: nil)
    }

    // 무한스크롤 글 가져오기 함수 테스트
    func testGetPosts() {
        let expectation = self.expectation(description: "getPosts")
        let limit = 10
        let lastCreatedAt: String? = "20240411102228"

        repository.getPosts(limit: limit, lastCreatedAt: lastCreatedAt) { posts in
            
            print("\n")
            
            for post in posts {
                print(post)
            }
            
            print("\n")
            
            XCTAssertNotNil(posts, "Should not return nil")
            
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 5, handler: nil)
    }

    
    // 글 생성 테스트
    func testCreatePost() {
        let expectation = self.expectation(description: "createPost")
        
        let newPost = Post(type: PostType.General, content: "테스트용", author:"1")
        
        repository.createPost(post: newPost) { success in
            
            XCTAssertTrue(success, "Post Create should succed.")
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    // 글 생성 테스트 with Images
    func testCreatePostWithImages() {
        let expectation = self.expectation(description: "Completion handler invoked")
        
        let testPost = Post(type:PostType.General, content: "This is a test post", author:"1")
        let testImages = [UIImage(named: "updateAppIcon")!, UIImage(named: "updateAppIcon")!]
        let testthumbnailImages = [UIImage(named: "updateAppIcon")!, UIImage(named: "updateAppIcon")!]
        
        repository.createPost(post: testPost, images: testImages, thumbnailImages: testthumbnailImages) { success in
            
            XCTAssertTrue(success, "Post Create should succed.")
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 5, handler: nil)
    }
    
     // 글 업데이트 테스트
    func testUpdatePost() {
        let expectation = self.expectation(description: "updatePost")
        
        let testImages = [UIImage(named: "updateAppIcon")!, UIImage(named: "updateAppIcon")!]
        let testthumbnailImages = [UIImage(named: "updateAppIcon")!, UIImage(named: "updateAppIcon")!]
        
        let postId = testPostId
        repository.updatePost(postId: postId, content: "Updated Content", shortcuts: ["Shortcut1"], images:testImages, thumbnailImages: testthumbnailImages) { success in
            XCTAssertTrue(success, "Post update should succeed.")
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    // 글 삭제 테스트
    func testDeletePost() {
        let expectation = self.expectation(description: "deletePost")
        
        let postId = testPostId
        repository.deletePost(postId: postId) { success in
            XCTAssertTrue(success, "Post deletion should succeed.")
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 20, handler: nil)
    }
    
    
    // 글에 좋아요 추가 테스트
    func testLikePost() {
        let expectation = self.expectation(description: "likePost")

        let postId = testPostId
        let userId = "2"

        repository.likePost(postId: postId, userId: userId) { success in
            XCTAssertTrue(success, "Liking a post should succeed.")
            expectation.fulfill()
        }

        waitForExpectations(timeout: 5, handler: nil)
    }

    // 글에 좋아요 제거 테스트
    func testUnlikePost() {
        let expectation = self.expectation(description: "unlikePost")

        let postId = testPostId
        let userId = "2"

        repository.unlikePost(postId: postId, userId: userId) { success in
            XCTAssertTrue(success, "Unliking a post should succeed.")
            expectation.fulfill()
        }
        

        waitForExpectations(timeout: 5, handler: nil)
    }

//MARK: - 답변 관련 테스트
    
    // 특정 게시물의 모든 답변을 가져오는 함수 테스트
     func testGetAnswers() {
         let expectation = self.expectation(description: "getAnswers")
         let testPostId = testPostId
         
         repository.getAnswers(for: testPostId) { answers in
             
             print("\n")
             
             for answer in answers {
                 print(answer)
             }
             
             print("\n")
             
             XCTAssertNotNil(answers, "Should not return nil")
             expectation.fulfill()
         }
         
         waitForExpectations(timeout: 5, handler: nil)
     }
     
     // 새로운 답변을 생성하는 함수 테스트
     func testCreateAnswer() {
         let expectation = self.expectation(description: "createAnswer")
         let answer = Answer(content: "Test answer", author: "1", postId: testPostId)
         
         repository.createAnswer(answer: answer) { success in
             XCTAssertTrue(success, "Answer creation should succeed.")
             expectation.fulfill()
         }
         
         waitForExpectations(timeout: 5, handler: nil)
     }
    
    // 새로운 답변을 생성하는 함수 with Images 테스트
    func testCreateAnswerWithImages() {
        let expectation = self.expectation(description: "createAnswer")
        let answer = Answer(content: "Test answer", author: "1", postId: testPostId)
        
        let testImages = [UIImage(named: "updateAppIcon")!, UIImage(named: "updateAppIcon")!]
        let testthumbnailImages = [UIImage(named: "updateAppIcon")!, UIImage(named: "updateAppIcon")!]
        
        repository.createAnswer(answer: answer, images: testImages, thumbnailImages: testthumbnailImages) { success in
            XCTAssertTrue(success, "Answer creation should succeed.")
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    
     
     // 기존의 답변을 업데이트하는 함수 테스트
     func testUpdateAnswer() {
         let expectation = self.expectation(description: "updateAnswer")
         let answerId = testAnswerId
         
         let testImages = [UIImage(named: "updateAppIcon")!, UIImage(named: "updateAppIcon")!]
         let testthumbnailImages = [UIImage(named: "updateAppIcon")!, UIImage(named: "updateAppIcon")!]
         
         repository.updateAnswer(answerId: answerId, content: "Updated content", images: testImages, thumbnailImages: testthumbnailImages) { success in
             XCTAssertTrue(success, "Answer update should succeed.")
             expectation.fulfill()
         }
         
         waitForExpectations(timeout: 5, handler: nil)
     }
    
    
    // 답변을 채택하는 함수 테스트
    func testAcceptAnswer() {
        let expectation = self.expectation(description: "acceptAnswer")
        let answerId = testAnswerId
        
        repository.acceptAnswer(answerId: answerId) { success in
            XCTAssertTrue(success, "Answer acception should succeed.")
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 5, handler: nil)
    }
     
     // 특정 답변을 삭제하는 함수 테스트
     func testDeleteAnswer() {
         let expectation = self.expectation(description: "deleteAnswer")
         let answerId = testAnswerId
         
         repository.deleteAnswer(answerId: answerId) { success in
             XCTAssertTrue(success, "Answer deletion should succeed.")
             expectation.fulfill()
         }
         
         waitForExpectations(timeout: 5, handler: nil)
     }
    
    // 답변에 좋아요를 누르는 함수 테스트
    func testLikeAnswer() {
        let expectation = self.expectation(description: "likeAnswer")
        let answerId = testAnswerId
        let userId = "1"
        
        repository.likeAnswer(answerId: answerId, userId: userId) { success in
            XCTAssertTrue(success, "Liking an answer should succeed.")
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    // 답변에 좋아요를 제거하는 함수 테스트
    func testUnlikeAnswer() {
        let expectation = self.expectation(description: "unlikeAnswer")
        let answerId = testAnswerId
        let userId = "1"
        
        repository.unlikeAnswer(answerId: answerId, userId: userId) { success in
            XCTAssertTrue(success, "Unliking an answer should succeed.")
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 5, handler: nil)
    }
    
//MARK: - 댓글 관련 테스트
    
    // 특정 게시물의 모든 댓글을 가져오는 함수 테스트
     func testGetComments() {
         let expectation = self.expectation(description: "getComments")
         let testPostId = testPostId
         
         repository.getComments(postId: testPostId) { comments in
             
             print("\n")
             
             for comment in comments {
                 print(comment)
             }
             
             print("\n")
             
             XCTAssertNotNil(comments, "Should not return nil")
             expectation.fulfill()
         }
         
         waitForExpectations(timeout: 5, handler: nil)
     }
     
     // 새로운 댓글을 생성하는 함수 테스트
     func testCreateComment() {
         let expectation = self.expectation(description: "createComment")
         let comment = CommunityComment(content: "Test comment", author: "1", postId: testPostId)
         
         repository.createComment(comment: comment) { success in
             XCTAssertTrue(success, "Comment creation should succeed.")
             expectation.fulfill()
         }
         
         waitForExpectations(timeout: 5, handler: nil)
     }
     
     // 기존의 댓글을 업데이트하는 함수 테스트
     func testUpdateComment() {
         let expectation = self.expectation(description: "updateComment")
         let commentId = testCommentId
         let newContent = "Updated content"
         
         repository.updateComment(commentId: commentId, content: newContent) { success in
             XCTAssertTrue(success, "Comment update should succeed.")
             expectation.fulfill()
         }
         
         waitForExpectations(timeout: 5, handler: nil)
     }
     
     // 특정 댓글을 삭제하는 함수 테스트
     func testDeleteComment() {
         let expectation = self.expectation(description: "deleteComment")
         let commentId = testCommentId
         
         repository.deleteComment(commentId: commentId) { success in
             XCTAssertTrue(success, "Comment deletion should succeed.")
             expectation.fulfill()
         }
         
         waitForExpectations(timeout: 5, handler: nil)
     }
     
     // 댓글에 좋아요를 추가하는 함수 테스트
     func testLikeComment() {
         let expectation = self.expectation(description: "likeComment")
         let commentId = testCommentId
         let userId = "1"
         
         repository.likeComment(commentId: commentId, userId: userId) { success in
             XCTAssertTrue(success, "Liking a comment should succeed.")
             expectation.fulfill()
         }
         
         waitForExpectations(timeout: 5, handler: nil)
     }
     
     // 댓글에 추가된 좋아요를 제거하는 함수 테스트
     func testUnlikeComment() {
         let expectation = self.expectation(description: "unlikeComment")
         let commentId = testCommentId
         let userId = "1"
         
         repository.unlikeComment(commentId: commentId, userId: userId) { success in
             XCTAssertTrue(success, "Unliking a comment should succeed.")
             expectation.fulfill()
         }
         
         waitForExpectations(timeout: 5, handler: nil)
     }
    
    

}

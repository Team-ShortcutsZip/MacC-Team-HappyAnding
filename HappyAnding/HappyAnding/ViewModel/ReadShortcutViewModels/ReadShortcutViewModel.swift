//
//  ReadShortcutViewModel.swift
//  HappyAnding
//
//  Created by kimjimin on 2023/07/15.
//

import SwiftUI

final class ReadShortcutViewModel: ObservableObject {
    
    private let shortcutsZipViewModel = ShortcutsZipViewModel.share
    
    @Published private(set) var shortcut: Shortcuts
    
    // ReadShortcutView
    @Published var isDeletingShortcut = false
    @Published var isEditingShortcut = false
    @Published var isUpdatingShortcut = false
    
    @Published var isMyLike = false
    @Published private var isMyFirstLike = false
    @Published var isDownloadingShortcut = false
    @Published private(set) var isDowngradingUserLevel = false
    
    @Published var currentTab: Int = 0
    @Published private(set) var comments: Comments = Comments()
    @Published var comment: Comment = Comment()
    @Published var nestedCommentTarget: String = ""
    @Published var commentText = ""
    
    @Published var isEditingComment = false
    @Published var isUndoingCommentEdit = false
    
    // ReadShortcutViewHeader
    @Published private(set) var author: User
    @Published var numberOfLike = 0
    @Published private(set) var userGrade = Image(systemName: "person.crop.circle.fill")
    
    // ReadShortcutCommentView
    @Published var isDeletingComment = false
    @Published var deletedComment = Comment()
    
    // UpdateShortcutView
    @Published var updatedLink = ""
    @Published var updateDescription = ""
    @Published var isLinkValid = false
    @Published var isDescriptionValid = false
    
    var isUpdateValid: Bool {
        isLinkValid && isDescriptionValid
    }
    
    init(data: Shortcuts) {
        print("*****init")
        self.author = User()
        self.shortcut = shortcutsZipViewModel.fetchShortcutDetail(id: data.id) ?? data
        self.isMyLike = shortcutsZipViewModel.checkLikedShortrcut(shortcutID: data.id)
        self.isMyFirstLike = isMyLike
        self.comments = shortcutsZipViewModel.fetchComment(shortcutID: data.id)
        self.numberOfLike = data.numberOfLike
        fetchAuthor()
    }
    
    private func fetchAuthor() {
        shortcutsZipViewModel.fetchUser(userID: shortcut.author,
                                        isCurrentUser: false) { user in
            self.author = user
            let grade = self.shortcutsZipViewModel.checkShortcutGrade(userID: self.author.id)
            let image = self.shortcutsZipViewModel.fetchShortcutGradeImage(isBig: false, shortcutGrade: grade)
            self.userGrade = image
        }
    }
    
    func moveTab(to tab: Int) {
        self.currentTab = tab
    }
    
    func setReply(to comment: Comment) {
        self.nestedCommentTarget = comment.user_nickname
        self.comment.bundle_id = comment.bundle_id
        self.comment.depth = 1
    }
    
    func checkIfDownloaded() {
        if (shortcutsZipViewModel.userInfo?.downloadedShortcuts.firstIndex(where: { $0.id == shortcut.id })) == nil {
            shortcut.numberOfDownload += 1
        }
    }
    
    func updateNumberOfDownload(index: Int) {
        shortcutsZipViewModel.updateNumberOfDownload(shortcut: shortcut, downloadlinkIndex: index)
    }
    
    func onViewDisappear() {
        if isMyLike != isMyFirstLike {
            shortcutsZipViewModel.updateNumberOfLike(isMyLike: isMyLike, shortcut: shortcut)
        }
    }
    
    func deleteShortcut() {
        shortcutsZipViewModel.deleteShortcutIDInUser(shortcutID: shortcut.id)
        shortcutsZipViewModel.deleteShortcutInCuration(curationsIDs: shortcut.curationIDs, shortcutID: shortcut.id)
        shortcutsZipViewModel.deleteData(model: shortcut)
        shortcutsZipViewModel.shortcutsMadeByUser = shortcutsZipViewModel.shortcutsMadeByUser.filter { $0.id != shortcut.id }
        shortcutsZipViewModel.updateShortcutGrade()
    }
    
    func cancelEditingComment() {
        self.isEditingComment.toggle()
        self.comment = self.comment.resetComment()
        self.commentText = ""
    }
    
    func postComment() {
        if !isEditingComment {
            comment.contents = commentText
            comment.date = Date().getDate()
            comment.user_id = shortcutsZipViewModel.userInfo!.id
            comment.user_nickname = shortcutsZipViewModel.userInfo!.nickname
            comments.comments.append(comment)
        } else {
            if let index = comments.comments.firstIndex(where: { $0.id == comment.id }) {
                comments.comments[index].contents = commentText
            }
            isEditingComment = false
        }
        shortcutsZipViewModel.setData(model: comments)
        commentText = ""
        comment = comment.resetComment()
        self.comments.comments = comments.fetchSortedComment()
    }
    
    func cancelNestedComment() {
        comment.bundle_id = "\(Date().getDate())_\(UUID().uuidString)"
        comment.depth = 0
    }
    
    func checkAuthor() -> Bool {
        return self.shortcut.author == shortcutsZipViewModel.currentUser()
    }
    
    func shareShortcut() {
        guard let deepLink = URL(string: "ShortcutsZip://myPage/detailView?shortcutID=\(shortcut.id)") else { return }
        let activityVC = UIActivityViewController(activityItems: [deepLink], applicationActivities: nil)
        let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
        guard let window = windowScene?.windows.first else { return }
        window.rootViewController?.present(activityVC, animated: true, completion: nil)
    }
    
    func checkDowngrading() {
        isDeletingShortcut.toggle()
        isDowngradingUserLevel = shortcutsZipViewModel.isShortcutDowngrade()
    }
    
    func updateShortcut() {
        shortcutsZipViewModel.updateShortcutVersion(shortcut: shortcut,
                                                    updateDescription: updateDescription,
                                                    updateLink: updatedLink)
        self.shortcut = shortcutsZipViewModel.fetchShortcutDetail(id: shortcut.id) ?? shortcut
        isUpdatingShortcut.toggle()
    }
    
    func deleteComment() {
        if deletedComment.depth == 0 {
            comments.comments.removeAll(where: { $0.bundle_id == deletedComment.bundle_id})
        } else {
            comments.comments.removeAll(where: { $0.id == deletedComment.id})
        }
        
        shortcutsZipViewModel.setData(model: comments)
    }
    
    func fetchUserGrade(id: String) -> Image {
        shortcutsZipViewModel.fetchShortcutGradeImage(isBig: false, shortcutGrade: shortcutsZipViewModel.checkShortcutGrade(userID: id))
    }
    
    func refreshShortcut() {
        self.shortcut = shortcutsZipViewModel.fetchShortcutDetail(id: shortcut.id) ?? shortcut
    }
}

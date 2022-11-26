//
//  ReadShortcutView.swift
//  HappyAnding
//
//  Created by 이지원 on 2022/10/19.
//

import SwiftUI

struct ReadShortcutView: View {
    
    @EnvironmentObject var shortcutsZipViewModel: ShortcutsZipViewModel
    @EnvironmentObject var shortcutNavigation: ShortcutNavigation
    @EnvironmentObject var curationNavigation: CurationNavigation
    @EnvironmentObject var writeShortcutNavigation: WriteShortcutNavigation
    @EnvironmentObject var writeCurationNavigation: WriteCurationNavigation
    @EnvironmentObject var profileNavigation: ProfileNavigation
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @Environment(\.presentationMode) var presentation: Binding<PresentationMode>
    @Environment(\.openURL) private var openURL
    
    @StateObject var writeNavigation = WriteShortcutNavigation()
    @State var isTappedDeleteButton = false
    @State var isEdit = false
    @State var isUpdating = false
    
    @State var isMyLike: Bool = false
    @State var isFirstMyLike = false
    @State var isClickDownload = false
    
    @State var data: NavigationReadShortcutType
    @State var comments: Comments = Comments(id: "", comments: [])
    @State var comment: Comment = Comment(user_nickname: "", user_id: "", date: "", depth: 0, contents: "")
    @State var nestedCommentInfoText: String = ""
    
    @State var height: CGFloat = UIScreen.screenHeight / 2
    @State var currentTab: Int = 0
    @State var commentText = ""
    @FocusState private var isFocused: Bool
    @Namespace var namespace
    
    private let contentSize = UIScreen.screenHeight / 2
    private let tabItems = ["기본 정보", "버전 정보", "댓글"]
    
    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                if data.shortcut != nil {
                    
                    GeometryReader { geo in
                        let yOffset = geo.frame(in: .global).minY
                        
                        Color.White
                            .frame(width: geo.size.width, height: 40 + (yOffset > 0 ? yOffset : 0))
                            .offset(y: yOffset > 0 ? -yOffset : 0)
                    }
                    .frame(minHeight: 40)
                    
                    // MARK: - 단축어 타이틀
                    
                    ReadShortcutHeaderView(shortcut: $data.shortcut.unwrap()!, isMyLike: $isMyLike)
                        .frame(height: 160)
                        .padding(.bottom, 33)
                        .background(Color.White)
                    
                    
                    // MARK: - 탭뷰 (기본 정보, 버전 정보, 댓글)
                    
                    LazyVStack(pinnedViews: [.sectionHeaders]) {
                        Section(header: tabBarView
                            .background(Color.White)
                        ) {
                            detailInformationView
                                .padding(.top, 4)
                                .padding(.horizontal, 16)
                        }
                    }
                }
            }
        }
        .background(Color.Background)
        .safeAreaInset(edge: .bottom, spacing: 0) {
            
            VStack {
                if currentTab == 2 {
                    textField
                }
                if !isFocused {
                    if let shortcut = data.shortcut {
                        Button {
                            if let url = URL(string: shortcut.downloadLink[0]) {
                                if (shortcutsZipViewModel.userInfo?.downloadedShortcuts.firstIndex(where: { $0.id == data.shortcutID })) == nil {
                                    data.shortcut?.numberOfDownload += 1
                                }
                                isClickDownload = true
                                openURL(url)
                            }
                            
                        } label: {
                            Text("다운로드 | \(Image(systemName: "arrow.down.app.fill")) \(shortcut.numberOfDownload)")
                                .Body1()
                                .foregroundColor(Color.Text_icon)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color.Primary)
                        }
                    }
                }
            }
            .ignoresSafeArea(.keyboard)
        }
        .onAppear() {
            UINavigationBar.appearance().standardAppearance.configureWithTransparentBackground()
            data.shortcut = shortcutsZipViewModel.fetchShortcutDetail(id: data.shortcutID)
            isMyLike = shortcutsZipViewModel.checkLikedShortrcut(shortcutID: data.shortcutID)
            isFirstMyLike = isMyLike
            self.comments = shortcutsZipViewModel.fetchComment(shortcutID: data.shortcutID)
        }
        .onChange(of: isEdit || isUpdating) { _ in
            if !isEdit || !isUpdating {
                data.shortcut = shortcutsZipViewModel.fetchShortcutDetail(id: data.shortcutID)
            }
        }
        .onChange(of: shortcutsZipViewModel.allComments) { _ in
            self.comments = shortcutsZipViewModel.fetchComment(shortcutID: data.shortcutID)
        }
        .onDisappear() {
            if let shortcut = data.shortcut {
                let isAlreadyContained = shortcutsZipViewModel.userInfo?.downloadedShortcuts.firstIndex(where: { $0.id == self.data.shortcutID}) == nil
                if isClickDownload && isAlreadyContained {
                    shortcutsZipViewModel.updateNumberOfDownload(shortcut: shortcut)
                    shortcutsZipViewModel.shortcutsUserDownloaded.insert(shortcut, at: 0)
                    
                    let downloadedShortcut = DownloadedShortcut(id: shortcut.id, downloadLink: shortcut.downloadLink[0])
                    shortcutsZipViewModel.userInfo?.downloadedShortcuts.insert(downloadedShortcut, at: 0)
                }
                if isMyLike != isFirstMyLike {
                    shortcutsZipViewModel.updateNumberOfLike(isMyLike: isMyLike, shortcut: shortcut)
                }
            }
        }
        .navigationBarTitleDisplayMode(NavigationBarItem.TitleDisplayMode.inline)
        .navigationBarItems(trailing: readShortcutViewButtonByUser())
        .alert("글 삭제", isPresented: $isTappedDeleteButton) {
            Button(role: .cancel) {
                
            } label: {
                Text("닫기")
            }
            
            Button(role: .destructive) {
                if let shortcut = data.shortcut {
                    shortcutsZipViewModel.deleteShortcutIDInUser(shortcutID: shortcut.id)
                    shortcutsZipViewModel.deleteShortcutInCuration(curationsIDs: shortcut.curationIDs, shortcutID: shortcut.id)
                    shortcutsZipViewModel.deleteData(model: shortcut)
                    shortcutsZipViewModel.shortcutsMadeByUser = shortcutsZipViewModel.shortcutsMadeByUser.filter { $0.id != shortcut.id }
                    self.presentation.wrappedValue.dismiss()
                }
            } label: {
                Text("삭제")
            }
        } message: {
            Text("글을 삭제하시겠습니까?")
        }
        .fullScreenCover(isPresented: $isEdit) {
            NavigationStack(path: $writeNavigation.navigationPath) {
                if let shortcut = data.shortcut {
                    WriteShortcutTitleView(isWriting: $isEdit,
                                           shortcut: shortcut,
                                           isEdit: true)
                }
            }
            .environmentObject(writeNavigation)
        }
        .fullScreenCover(isPresented: $isUpdating) {
            UpdateShortcutView(isUpdating: $isUpdating, shortcut: $data.shortcut)
        }
        .toolbar(.hidden, for: .tabBar)
        .toolbarBackground(
                        Color.White,
                        for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: btnBack.padding(.horizontal, -8))
    }
    
    var btnBack : some View {
        Button(action: {
            self.presentationMode.wrappedValue.dismiss()
        }) {
            HStack {
                Image(systemName: "chevron.backward") // set image here
                    .foregroundColor(.Gray4)
                    .font(Font(UIFont.systemFont(ofSize: 18, weight: .medium)))
            }
        }
    }
    
    var textField: some View {
        
        VStack(spacing: 0) {
            if comment.depth == 1 {
                nestedCommentInfo
            }
            HStack {
                if comment.depth == 1 {
                    Image(systemName: "arrow.turn.down.right")
                        .foregroundColor(.Gray4)
                }
                TextField("댓글을 입력하세요", text: $commentText, axis: .vertical)
                    .Body2()
                    .focused($isFocused)
                
                Button {
                    comment.contents = commentText
                    comment.date = Date().getDate()
                    comment.user_id = shortcutsZipViewModel.userInfo!.id
                    comment.user_nickname = shortcutsZipViewModel.userInfo!.nickname
                    comments.comments.append(comment)
                    shortcutsZipViewModel.setData(model: comments)
                    commentText = ""
                    comment = comment.resetComment()
                } label: {
                    Image(systemName: "paperplane.fill")
                        .foregroundColor(commentText == "" ? Color.Gray2 : Color.Gray5)
                }
                .disabled(commentText == "" ? true : false)
            }
            .padding(.vertical, 12)
            .padding(.horizontal, 16)
            .background(
                Rectangle()
                    .fill(Color.Gray1)
                    .cornerRadius(12 ,corners: comment.depth == 0 ? .allCorners : [.bottomLeft, .bottomRight])
            )
            .padding(.horizontal, 16)
            .padding(.bottom, 20)
        }
    }
    var nestedCommentInfo: some View {
        HStack {
            Text("@ \(nestedCommentInfoText)")
                .Footnote()
                .foregroundColor(.Gray5)
            Spacer()
            Button {
                comment.bundle_id = "\(Date().getDate())_\(UUID().uuidString)"
                comment.depth = 0
            } label: {
                Image(systemName: "xmark")
                    .font(Font(UIFont.systemFont(ofSize: 17, weight: .medium)))
                    .foregroundColor(.Gray5)
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 11)
        .background(
            Rectangle()
                .fill(Color.Gray2)
                .cornerRadius(12 ,corners: [.topLeft, .topRight])
        )
        .padding(.horizontal, 16)
    }
}

extension ReadShortcutView {
    
    @ViewBuilder
    private func readShortcutViewButtonByUser() -> some View {
        if self.data.shortcut?.author == shortcutsZipViewModel.currentUser() {
            myShortcutMenu
        } else {
            shareButton
        }
    }
    
    private var myShortcutMenu: some View {
        Menu(content: {
            Section {
                editButton
                updateButton
                shareButton
                deleteButton
            }
        }, label: {
            Image(systemName: "ellipsis")
                .foregroundColor(.Gray4)
        })
    }
    
    private var editButton: some View {
        Button {
            isEdit.toggle()
        } label: {
            Label("편집", systemImage: "square.and.pencil")
        }
    }
    
    private var updateButton: some View {
        Button {
            isUpdating.toggle()
        } label: {
            Label("업데이트", systemImage: "clock.arrow.circlepath")
        }
    }
    
    private var shareButton: some View {
        Button(action: {
            shareShortcut()
        }) {
            Label("공유", systemImage: "square.and.arrow.up")
        }
    }
    
    private var deleteButton: some View {
        Button(role: .destructive, action: {
            isTappedDeleteButton.toggle()
            // TODO: firebase delete function
            
        }) {
            Label("삭제", systemImage: "trash.fill")
        }
    }
    
    private func shareShortcut() {
        if let shortcut = data.shortcut {
            guard let deepLink = URL(string: "ShortcutsZip://myPage/detailView?shortcutID=\(shortcut.id)") else { return }
            let activityVC = UIActivityViewController(activityItems: [deepLink], applicationActivities: nil)
            let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
            guard let window = windowScene?.windows.first else { return }
            window.rootViewController?.present(activityVC, animated: true, completion: nil)
        }
    }
}

// MARK: - 단축어 상세 정보 (기본 정보, 버전 정보, 댓글)

extension ReadShortcutView {
    
    var detailInformationView: some View {
        VStack {
            ZStack {
                TabView(selection: self.$currentTab) {
                    Color.clear.tag(0)
                    Color.clear.tag(1)
                    Color.clear.tag(2)
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
                .frame(height: height)
                
                switch(currentTab) {
                case 0:
                    ReadShortcutContentView(shortcut: $data.shortcut.unwrap()!)
                        .background(
                            GeometryReader { geometryProxy in
                                Color.clear
                                    .preference(key: SizePreferenceKey.self,
                                                value: geometryProxy.size)
                            })
                case 1:
                    ReadShortcutVersionView(shortcut: $data.shortcut.unwrap()!, isUpdating: $isUpdating)
                        .background(
                            GeometryReader { geometryProxy in
                                Color.clear
                                    .preference(key: SizePreferenceKey.self, value:
                                                    geometryProxy.size)
                            })
                case 2:
                    ReadShortcutCommentView(addedComment: $comment, comments: $comments, nestedCommentInfoText: $nestedCommentInfoText, shortcutID: data.shortcutID)
                        .background(
                            GeometryReader { geometryProxy in
                                Color.clear
                                    .preference(key: SizePreferenceKey.self,
                                                value: geometryProxy.size)
                            })
                default:
                    EmptyView()
                }
            }
            
            .animation(.easeInOut, value: currentTab)
            .onPreferenceChange(SizePreferenceKey.self) { newSize in
                height = contentSize > newSize.height ? contentSize : newSize.height
            }
            .gesture(DragGesture(minimumDistance: 20, coordinateSpace: .global)
                .onEnded { value in
                    let horizontalAmount = value.translation.width
                    let verticalAmount = value.translation.height
                    
                    if abs(horizontalAmount) > abs(verticalAmount) {
                        if horizontalAmount < 0 {
                            if currentTab < 2 {
                                currentTab += 1
                            }
                        } else {
                            if currentTab > 0 {
                                currentTab -= 1
                            } else {
                                
                                // MARK: Navigation pop 코드
//                                    print("swipe back")
//                                    switch data.navigationParentView {
//                                    case .shortcuts:
//                                        shortcutNavigation.shortcutPath.removeLast()
//                                    case .curations:
//                                        curationNavigation.navigationPath.removeLast()
//                                    case .myPage:
//                                        profileNavigation.navigationPath.removeLast()
//                                    case .writeCuration:
//                                        writeCurationNavigation.navigationPath.removeLast()
//                                    case .writeShortcut:
//                                        writeShortcutNavigation.navigationPath.removeLast()
//                                    }
                            }
                        }
                    }
                })
        }
    }
    
    
    var tabBarView: some View {
        HStack(spacing: 20) {
            ForEach(Array(zip(self.tabItems.indices, self.tabItems)), id: \.0) { index, name in
                tabBarItem(string: name, tab: index)
            }
        }
        .padding(.horizontal, 16)
        .frame(height: 36)
    }
    
    private func tabBarItem(string: String, tab: Int) -> some View {
        Button {
            self.currentTab = tab
        } label: {
            VStack {
                Spacer()
                
                if self.currentTab == tab {
                    Text(string)
                        .Headline()
                        .foregroundColor(.Gray5)
                    Color.Gray5
                        .frame(height: 2)
                        .matchedGeometryEffect(id: "underline", in: namespace, properties: .frame)
                    
                } else {
                    Text(string)
                        .Body1()
                        .foregroundColor(.Gray3)
                    Color.clear.frame(height: 2)
                }
            }
            .animation(.spring(), value: currentTab)
        }
        .buttonStyle(.plain)
    }
}


struct SizePreferenceKey: PreferenceKey {
    typealias Value = CGSize
    static var defaultValue: Value = .zero
    
    static func reduce(value _: inout Value, nextValue: () -> Value) {
        _ = nextValue()
    }
}

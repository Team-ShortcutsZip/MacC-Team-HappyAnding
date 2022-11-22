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
    @State var comment: Comment = Comment(user_id: "", date: "", depth: 0, contents: "")
    
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
                if shortcut != nil {
                    
                    // MARK: - 단축어 타이틀
                    
                    ReadShortcutHeaderView(shortcut: $data.shortcut.unwrap()!, isMyLike: $isMyLike)
                        .frame(height: 160)
                        .padding(.bottom, 33)
                        .padding(.top, 40)
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
        .onAppear() {
            data.shortcut = shortcutsZipViewModel.fetchShortcutDetail(id: data.shortcutID)
            isMyLike = shortcutsZipViewModel.checkLikedShortrcut(shortcutID: data.shortcutID)
            isFirstMyLike = isMyLike
        }
        .onAppear(perform: {UINavigationBar.appearance().standardAppearance.configureWithTransparentBackground() })
        .onChange(of: isEdit) { _ in
            if !isEdit {
                data.shortcut = shortcutsZipViewModel.fetchShortcutDetail(id: data.shortcutID)
            }
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
                    if isMyLike {
                        shortcutsZipViewModel.userInfo?.likedShortcuts.insert(self.data.shortcutID, at: 0)
                        shortcutsZipViewModel.shortcutsUserLiked.insert(shortcut, at: 0)
                    } else {
                        shortcutsZipViewModel.userInfo?.likedShortcuts.removeAll(where: { $0 == self.data.shortcutID })
                        shortcutsZipViewModel.shortcutsUserLiked.removeAll(where: { $0.id == self.data.shortcutID })
                    }
                }
            }
        }
        .safeAreaInset(edge: .bottom, spacing: 0) {
           
            VStack {
                if currentTab == 2 {
                    textField
                }
                if !isFocused {
                    if let shortcut {
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
        .padding(.vertical, 20)
        .background(Color.Background)
        .onAppear() {
            data.shortcut = shortcutsZipViewModel.fetchShortcutDetail(id: data.shortcutID)
            isMyLike = shortcutsZipViewModel.checkLikedShortrcut(shortcutID: data.shortcutID)
            isFirstMyLike = isMyLike
        }
        .onChange(of: isEdit) { _ in
            if !isEdit {
                data.shortcut = shortcutsZipViewModel.fetchShortcutDetail(id: data.shortcutID)
            }
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
                    if isMyLike {
                        shortcutsZipViewModel.userInfo?.likedShortcuts.insert(self.data.shortcutID, at: 0)
                        shortcutsZipViewModel.shortcutsUserLiked.insert(shortcut, at: 0)
                    } else {
                        shortcutsZipViewModel.userInfo?.likedShortcuts.removeAll(where: { $0 == self.data.shortcutID })
                        shortcutsZipViewModel.shortcutsUserLiked.removeAll(where: { $0.id == self.data.shortcutID })
                    }
                }
            }
        }
        .navigationBarTitleDisplayMode(NavigationBarItem.TitleDisplayMode.inline)
        .navigationBarItems(trailing: Menu(content: {
            if self.data.shortcut?.author == shortcutsZipViewModel.currentUser() {
                myShortcutMenuSection
            } else {
                otherShortcutMenuSection
            }
        }, label: {
            Image(systemName: "ellipsis")
                .foregroundColor(.Gray4)
        }))
        .alert("글 삭제", isPresented: $isTappedDeleteButton) {
            Button(role: .cancel) {
                
            } label: {
                Text("닫기")
            }
            
            Button(role: .destructive) {
                if let shortcut {
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
            UpdateShortcutView(isUpdating: $isUpdating, shortcut: $shortcut)
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
        HStack {
            if comment.depth == 1 {
                Image(systemName: "arrow.turn.down.right")
                    .foregroundColor(.Gray4)
            }
            TextField("댓글을 입력하세요", text: $commentText, axis: .vertical)
                .Body2()
                .focused($isFocused)
            
            Button {
                //TODO: 서버에 데이터 전송
                print("click")
            } label: {
                Image(systemName: "paperplane.fill")
                    .foregroundColor(.Gray5)
            }
        }
        .padding(.vertical, 12)
        .padding(.horizontal, 16)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.Gray1)
        )
        .padding(.horizontal, 16)
        .padding(.bottom, 20)
    }
}

extension ReadShortcutView {
    
    var myShortcutMenuSection: some View {
        
        Section {
            
            Button {
                isEdit.toggle()
            } label: {
                Label("편집", systemImage: "square.and.pencil")
            }
            
            Button {
                isUpdating.toggle()
            } label: {
                Label("업데이트", systemImage: "clock.arrow.circlepath")
            }
            
            Button(action: {
                share()
            }) {
                Label("공유", systemImage: "square.and.arrow.up")
            }
            
            Button(role: .destructive, action: {
                isTappedDeleteButton.toggle()
            }) {
                Label("삭제", systemImage: "trash.fill")
            }
        }
        
    }
    
    var otherShortcutMenuSection: some View {
        Section {
            Button(action: {
                share()
            }) {
                Label("공유", systemImage: "square.and.arrow.up")
            }
            
            //TODO: 2차 스프린트 이후 신고 기능 추가 시 사용할 코드
//            Button(action: {
//                //Place something action here
//            }) {
//                Label("신고", systemImage: "light.beacon.max.fill")
//            }
        }
    }
    
    func share() {
        if let shortcut {
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
            if let shortcut {
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
                        ReadShortcutContentView(shortcut: self.$shortcut.unwrap()!)
                            .background(
                                GeometryReader { geometryProxy in
                                    Color.clear
                                        .preference(key: SizePreferenceKey.self,
                                                    value: geometryProxy.size)
                                })
                    case 1:
                        ReadShortcutVersionView(shortcut: shortcut)
                            .background(
                                GeometryReader { geometryProxy in
                                    Color.clear
                                        .preference(key: SizePreferenceKey.self, value:
                                                        geometryProxy.size)
                                })
                    case 2:
                        ReadShortcutCommentView(addedComment: $comment)
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

//
//  ReadShortcutHeaderView.swift
//  HappyAnding
//
//  Created by KiWoong Hong on 2022/10/24.
//

import SwiftUI

struct ReadShortcutHeaderView: View {
    @Environment(\.loginAlertKey) var loginAlerter
    @EnvironmentObject var shortcutsZipViewModel: ShortcutsZipViewModel
    
    @AppStorage("useWithoutSignIn") var useWithoutSignIn: Bool = false
    
    @Binding var shortcut: Shortcuts
    @Binding var isMyLike: Bool
    
    @State var userInformation: User? = nil
    @State var numberOfLike = 0
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                
                icon
                
                Spacer()
                
                likeButton
                
            }
            VStack(alignment: .leading, spacing: 4) {
                Text("\(shortcut.title)")
                    .Title1()
                    .foregroundColor(Color.gray5)
                    .fixedSize(horizontal: false, vertical: true)
                
                Text("\(shortcut.subtitle)")
                    .Body1()
                    .foregroundColor(Color.gray3)
                    .fixedSize(horizontal: false, vertical: true)
            }
            userInfo
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 16)
        .onAppear() {
            shortcutsZipViewModel.fetchUser(userID: shortcut.author,
                                            isCurrentUser: false) { user in
                userInformation = user
            }
            numberOfLike = shortcut.numberOfLike
        }
        .onDisappear { self.shortcut.numberOfLike = numberOfLike }
    }
    
    // MARK: 단축어 아이콘
    var icon: some View {
        VStack {
            Image(systemName: shortcut.sfSymbol)
                .mediumShortcutIcon()
                .foregroundColor(Color.textIcon)
        }
        .frame(width: 52, height: 52)
        .background(Color.fetchGradient(color: shortcut.color))
        .cornerRadius(8)
    }
    
    // MARK: 좋아요 버튼
    var likeButton: some View {
        Text("\(isMyLike ? Image(systemName: "heart.fill") : Image(systemName: "heart")) \(numberOfLike)")
            .Body2()
            .padding(10)
            .foregroundColor(isMyLike ? Color.textIcon : Color.gray4)
            .background(isMyLike ? Color.shortcutsZipPrimary : Color.gray1)
            .cornerRadius(12)
            .onTapGesture {
                if !useWithoutSignIn {
                    isMyLike.toggle()
                    //화면 상의 좋아요 추가, 취소 기능 동작
                    numberOfLike += isMyLike ? 1 : -1
                } else {
                    loginAlerter.isPresented = true
                }
            }
    }
    
    // MARK: - 유저 정보
    var userInfo: some View {
        ZStack {
            if let data = NavigationProfile(userInfo: self.userInformation) {
                HStack(spacing: 8) {
                    
                    Image(systemName: "person.crop.circle.fill")
                        .font(.system(size: 24, weight: .medium))
                        .frame(width: 24, height: 24)
                        .foregroundColor(.gray3)
                        .padding(.leading, 16)
                    
                    Text(userInformation?.nickname ?? TextLiteral.withdrawnUser)
                        .Body2()
                        .foregroundColor(.gray4)
                    
                    Spacer()
                        .frame(maxWidth: .infinity)
                    
                    
                    // TODO: 신고기능
                    
                    /*
                     Image(systemName: "light.beacon.max.fill")
                     .Headline()
                     .foregroundColor(.gray5)
                     .padding(.trailing, 16)
                     .onTapGesture {
                     print("Tapped!")
                     }
                     */
                    
                }
                .navigationLinkRouter(data: data)
                .disabled(userInformation == nil)
                .padding(.vertical, 10)
                .frame(maxWidth: .infinity, maxHeight: 44)
                .overlay {
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.gray1, lineWidth: 1)
                }
            }
        }
    }
}

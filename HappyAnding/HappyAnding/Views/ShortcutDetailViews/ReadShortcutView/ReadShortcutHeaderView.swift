//
//  ReadShortcutHeaderView.swift
//  HappyAnding
//
//  Created by KiWoong Hong on 2022/10/24.
//

import SwiftUI

struct ReadShortcutHeaderView: View {
    
    @EnvironmentObject var shortcutsZipViewModel: ShortcutsZipViewModel
    
    @Binding var shortcut: Shortcuts
    @Binding var isMyLike: Bool
    @State var userInformation: User? = nil
    
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
                    .foregroundColor(Color.Gray5)
                    .fixedSize(horizontal: false, vertical: true)
                
                Text("\(shortcut.subtitle)")
                    .Body1()
                    .foregroundColor(Color.Gray3)
                    .fixedSize(horizontal: false, vertical: true)
            }
            userInfo
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 16)
        .onAppear() {
            shortcutsZipViewModel.fetchUser(userID: shortcut.author) { user in
                userInformation = user
            }
            
        }
    }
    
    // MARK: 단축어 아이콘
    var icon: some View {
        VStack {
            Image(systemName: shortcut.sfSymbol)
                .Title2()
                .foregroundColor(Color.Text_icon)
        }
        .frame(width: 52, height: 52)
        .background(Color.fetchGradient(color: shortcut.color))
        .cornerRadius(8)
    }
    
    // MARK: 좋아요 버튼
    var likeButton: some View {
        Text("\(isMyLike ? Image(systemName: "heart.fill") : Image(systemName: "heart")) \(shortcut.numberOfLike)")
            .Body2()
            .padding(10)
            .foregroundColor(isMyLike ? Color.Text_icon : Color.Gray4)
            .background(isMyLike ? Color.Primary : Color.Gray1)
            .cornerRadius(12)
            .onTapGesture(perform: {
                isMyLike.toggle()
                //화면 상의 좋아요 추가, 취소 기능 동작
                if isMyLike {
                    self.shortcut.numberOfLike += 1
                } else {
                    self.shortcut.numberOfLike -= 1
                }
            })
    }
    
    // MARK: - 유저 정보
    var userInfo: some View {
        ZStack {
            if let data = NavigationProfile(userInfo: self.userInformation) {
                NavigationLink(value: data) {
                    HStack(spacing: 8) {
                        
                        Circle()
                            .frame(width: 24, height: 24)
                            .foregroundColor(.Gray4)
                            .padding(.leading, 16)
                        
                        Text(userInformation?.nickname ?? "탈퇴한 사용자")
                            .Body2()
                            .foregroundColor(.Gray4)
                        
                        Spacer()
                            .frame(maxWidth: .infinity)
                        
                        
                        // TODO: 신고기능
                        
                        /*
                         Image(systemName: "light.beacon.max.fill")
                         .Headline()
                         .foregroundColor(.Gray5)
                         .padding(.trailing, 16)
                         .onTapGesture {
                         print("Tapped!")
                         }
                         */
                        
                    }
                }
                .disabled(userInformation == nil)
                .padding(.vertical, 10)
                .frame(maxWidth: .infinity, maxHeight: 44)
                .overlay {
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.Gray1, lineWidth: 1)
                }
            }
        }
    }
}

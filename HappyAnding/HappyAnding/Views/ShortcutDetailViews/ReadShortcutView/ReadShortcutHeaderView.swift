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
    
    @AppStorage("useWithoutSignIn") var useWithoutSignIn: Bool = false
    @State private var tryActionWithoutSignIn: Bool = false
    
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
        .alert("로그인을 진행해주세요", isPresented: $tryActionWithoutSignIn) {
            Button(role: .cancel) {
                tryActionWithoutSignIn = false
            } label: {
                Text("취소")
            }
            Button {
                useWithoutSignIn = false
                tryActionWithoutSignIn = false
            } label: {
                Text("로그인하기")
            }
        } message: {
            Text("이 기능은 로그인 후 사용할 수 있어요")
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 16)
        .onAppear() {
            shortcutsZipViewModel.fetchUser(userID: shortcut.author,
                                            isCurrentUser: false) { user in
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
            .onTapGesture {
                if !useWithoutSignIn {
                    isMyLike.toggle()
                    //화면 상의 좋아요 추가, 취소 기능 동작
                    if isMyLike {
                        self.shortcut.numberOfLike += 1
                    } else {
                        self.shortcut.numberOfLike -= 1
                    }
                } else {
                    tryActionWithoutSignIn = true
                }
            }
    }
    
    // MARK: - 유저 정보
    var userInfo: some View {
        ZStack {
            if let data = NavigationProfile(userInfo: self.userInformation) {
                NavigationLink(value: data) {
                    HStack(spacing: 8) {
                        
                        Image(systemName: "person.crop.circle.fill")
                            .font(.system(size: 24, weight: .medium))
                            .frame(width: 24, height: 24)
                            .foregroundColor(.Gray3)
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

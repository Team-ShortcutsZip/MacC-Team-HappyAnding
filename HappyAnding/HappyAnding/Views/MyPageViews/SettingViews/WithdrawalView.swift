//
//  WithdrawalView.swift
//  HappyAnding
//
//  Created by HanGyeongjun on 2022/11/09.
//

import SwiftUI

import FirebaseAuth

struct WithdrawalView: View {
    @Environment(\.window) var window: UIWindow?
    @EnvironmentObject var userAuth: UserAuth
    @EnvironmentObject var shortcutsZipViewModel: ShortcutsZipViewModel
    
    @State private var appleLoginCoordinator: AppleAuthCoordinator?
    @State var isTappedCheckToggle = false
    
    @AppStorage("signInStatus") var signInStatus = false
    @AppStorage("isReauthenticated") var isReauthenticated = false
    @AppStorage("isTappedSignOutButton") var isTappedSignOutButton = false
    
    private let signOutTitle = ["탈퇴 시 삭제되는 항목",
                                "탈퇴 시 삭제되지 않는 항목"]
    private let signOutDescription = ["로그인 정보 / 닉네임 / 좋아요한 단축어 목록 /\n 다운로드 한 단축어 목록",
                                      "작성한 단축어 / 작성한 추천 모음집"]
    
    var body: some View {
        VStack(alignment: .leading) {
            
            Text("ShortcutsZip에서 탈퇴 시 다음과 같이 사용자 데이터가 처리됩니다.")
                .Title2()
                .foregroundColor(.Gray5)
                .multilineTextAlignment(.leading)
                .padding(.vertical, 32)
            
            ForEach(0..<signOutTitle.count, id: \.self) { index in
                Text(signOutTitle[index])
                    .Body2()
                    .foregroundColor(.Gray5)
                    .padding(.bottom, 8)
                
                Text(signOutDescription[index])
                    .Body2()
                    .foregroundColor(.Gray3)
                    .padding(.bottom, 16)
            }
            
            Spacer()
            
            HStack(spacing: 8) {
                Image(systemName: isTappedCheckToggle ? "checkmark.square.fill" : "square")
                    .Title2()
                    .foregroundColor(isTappedCheckToggle ? .Primary : .Gray4)
                    .onTapGesture {
                        isTappedCheckToggle.toggle()
                    }
                Text("위 내용을 확인했으며 데이터 처리방법에 동의합니다.")
                    .Body2()
                    .foregroundColor(.Gray4)
                    .multilineTextAlignment(.leading)
                    .onTapGesture {
                        self.isTappedCheckToggle.toggle()
                    }
            }
            .frame(maxWidth: .infinity)
            .padding(.bottom, 12)
            
            Button {
                isTappedSignOutButton = true
                reauthenticateUser()
            } label: {
                ZStack {
                    RoundedRectangle(cornerRadius: 12)
                        .foregroundColor(isTappedCheckToggle ? .Primary : .Primary .opacity(0.13))
                        .frame(maxWidth: .infinity, maxHeight: 52)
                    
                    Text("사용자 재인증 후 탈퇴하기")
                        .foregroundColor(isTappedCheckToggle ? .Text_Button : .Text_Button_Disable )
                        .Body1()
                }
            }
            .disabled(!isTappedCheckToggle)
            .padding(.bottom, 44)
            .alert("탈퇴하기", isPresented: $isReauthenticated) {
                Button(role: .cancel) {
                    isReauthenticated = false
                } label: {
                    Text("닫기")
                }
                
                Button(role: .destructive) {
                    signOut()
                } label: {
                    Text("탈퇴")
                }
            } message: {
                Text("ShortcutsZip에서 탈퇴하시겠습니까?")
            }
        }
        .padding(.horizontal, 16)
        .background(Color.Background)
        .navigationTitle("탈퇴하기")
    }
    
    private func signOut() {
        if let user = shortcutsZipViewModel.userInfo {
            shortcutsZipViewModel.deleteUserData(userID: user.id)
        }
    }
    
    private func reauthenticateUser() {
        appleLoginCoordinator = AppleAuthCoordinator(window: window, isTappedSignInButton: false)
        appleLoginCoordinator?.startSignInWithAppleFlow()
    }
}

struct WithdrawalView_Previews: PreviewProvider {
    static var previews: some View {
        WithdrawalView()
    }
}

//
//  WithdrawalView.swift
//  HappyAnding
//
//  Created by HanGyeongjun on 2022/11/09.
//

import SwiftUI

import FirebaseAuth

struct WithdrawalView: View {
    
    @AppStorage("signInStatus") var signInStatus = false
    @StateObject var userAuth = UserAuth.shared
    @EnvironmentObject var shortcutsZipViewModel: ShortcutsZipViewModel
    
    @State var isTappedCheckToggle = false
    @State var isTappedSignOutButton = false
    
    private let signOutTitle = ["탈퇴 시 삭제되는 항목",
                                "탈퇴 시 삭제되지 않는 항목"]
    private let signOutDescription = ["로그인 정보 / 닉네임 / 좋아요한 단축어 목록 /\n 다운로드 한 단축어 목록",
                                      "작성한 단축어 / 작성한 큐레이션"]
    
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
                self.isTappedSignOutButton = true
            } label: {
                ZStack {
                    RoundedRectangle(cornerRadius: 12)
                        .foregroundColor(isTappedCheckToggle ? .Primary : .Primary .opacity(0.13))
                        .frame(maxWidth: .infinity, maxHeight: 52)
                    
                    Text("탈퇴하기")
                        .foregroundColor(isTappedCheckToggle ? .Text_Button : .Text_Button_Disable )
                        .Body1()
                }
            }
            .disabled(!isTappedCheckToggle)
            .padding(.bottom, 44)
            .alert(isPresented: $isTappedSignOutButton) {
                Alert(title: Text("탈퇴하기"),
                      message: Text("ShortcutsZip에서 탈퇴하시겠습니까?"),
                      primaryButton: .default(Text("취소")
                                              ,action: { self.isTappedSignOutButton = false }),
                      secondaryButton: .destructive(Text("탈퇴"), action: { signOut() }))
            }
        }
        .padding(.horizontal, 16)
        .background(Color.Background)
        .navigationTitle("탈퇴하기")
    }
    
    private func signOut() {
        let firebaseAuth = Auth.auth()
        let currentUser = firebaseAuth.currentUser
        currentUser?.delete { error in
            if let error {
                print(error.localizedDescription)
            } else {
                if let user = shortcutsZipViewModel.userInfo {
                    shortcutsZipViewModel.deleteData(model: user)
                    withAnimation(.easeInOut) {
                        self.signInStatus = false
                        userAuth.signOut()
                    }
                }
            }
        }
    }
    
}

struct WithdrawalView_Previews: PreviewProvider {
    static var previews: some View {
        WithdrawalView()
    }
}

//
//  WriteNicknameView.swift
//  HappyAnding
//
//  Created by 이지원 on 2022/11/01.
//

import SwiftUI

import FirebaseAuth

/**
 닉네임 작성 뷰
 
 parameters
 - nickname : 닉네임 정보, 스트링
 - checkNicknameDuplicate : 중복확인 alert을 띄우는 Bool값. 기본값은 false고 true로 바뀌면 alert이 뜸
 - isDuplicatedNickname : 중복확인 후 중복되는 닉네임이 있으면 true로 변경, alert의 메시지를 바꾸는 데 사용함
 - isNicknameChecked : 중복확인 후 닉네임이 사용 가능한 것이 확인되면 true로 변경. 시작하기 버튼 활성화하는 데 사용함
 
 TODO: 텍스트필드의 8자 제한 로직을 추가해야 함
 */

struct WriteNicknameView: View {
    @EnvironmentObject var userAuth: UserAuth
    @EnvironmentObject var shortcutszipViewModel: ShortcutsZipViewModel
    
    @ObservedObject var webViewModel = WebViewModel()
    
    @AppStorage("signInStatus") var signInStatus = false
    
    @State var nickname: String = ""
    @State private var isTappedPrivacyButton = false
    @State var isValid = false
    
    let user = Auth.auth().currentUser
    
    var body: some View {
        VStack(alignment: .leading) {
            
            Text(TextLiteral.writeNicknameViewHeadline)
                .shortcutsZipTitle1()
                .foregroundStyle(Color.gray5)
                .padding(.top, 40)
            
            NicknameTextField(nickname: $nickname, isValid: $isValid)

            Spacer()
            
            Text(TextLiteral.settingViewPrivacyPolicy)
                .shortcutsZipBody2()
                .foregroundStyle(Color.gray3)
                .padding(.bottom, 12)
                .frame(maxWidth: .infinity)
                .onTapGesture {
                    self.isTappedPrivacyButton = true
                }
            
            startButton
        }
        .padding(.horizontal, 16)
        .padding(.bottom, 44)
        .background(Color.shortcutsZipBackground)
        .sheet(isPresented: self.$isTappedPrivacyButton) {
            ZStack {
                PrivacyPolicyView(viewModel: webViewModel,
                         isTappedPrivacyButton: $isTappedPrivacyButton,
                                  url: TextLiteral.settingViewPrivacyPolicyURL)
                    .presentationDetents([.large])
                    .presentationDragIndicator(.visible)
                if webViewModel.isLoading {
                    ProgressView()
                }
            }
        }
    }
    
    ///시작하기 버튼
    var startButton: some View {
        Button(action: {
            
            withAnimation(.easeInOut) {
                self.signInStatus = true
            }
            
            shortcutszipViewModel.setData(model: User(id: user?.uid ?? "", nickname: nickname, likedShortcuts: [String](), downloadedShortcuts: [DownloadedShortcut]()))
        }, label: {
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(isValid ? Color.shortcutsZipPrimary : Color.shortcutsZipPrimary.opacity(0.13))
                    .frame(height: 52)
                Text(TextLiteral.writeNicknameViewStart)
                    .foregroundStyle(isValid ? Color.textIcon : Color.textButtonDisable)
                    .shortcutsZipBody1()
            }
        })
        .disabled(!isValid)
    }
}

struct WriteNicknameView_Previews: PreviewProvider {
    static var previews: some View {
        WriteNicknameView()
    }
}

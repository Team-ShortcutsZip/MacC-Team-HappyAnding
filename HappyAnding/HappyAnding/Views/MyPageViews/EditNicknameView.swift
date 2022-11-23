//
//  EditNicknameView.swift
//  HappyAnding
//
//  Created by kimjimin on 2022/11/23.
//

import SwiftUI

struct EditNicknameView: View {
    @EnvironmentObject var shortcutszipViewModel: ShortcutsZipViewModel
    @EnvironmentObject var profileNavigation: ProfileNavigation
    
    @State var nickname: String = ""
    @State var checkNicknameDuplicate: Bool = false
    @State var isDuplicatedNickname: Bool = false
    @State var isNicknameChecked: Bool = false
    @State var isValidLength = false
    @State private var isTappedPrivacyButton = false
    @State var isNormalString = true
    @State var user: User?
    
    @FocusState private var isFocused: Bool
        
    var body: some View {
        VStack(alignment: .leading) {
            Text("닉네임을 수정해주세요")
                .Title1()
                .foregroundColor(.Gray5)
                .padding(.top, 40)
            
            HStack(spacing: 14) {
                textField
                nicknameCheckButton
            }
            .padding(.top, 16)
            
            if nickname.count > 8 {
                Text("*닉네임은 최대 8글자까지 입력가능합니다.")
                    .Body2()
                    .foregroundColor(.red)
                    .padding(.top, 4)
            }
            
            if isNormalString {
                Text("*공백 없이 한글, 숫자, 영문만 입력 가능")
                    .Body2()
                    .foregroundColor(nickname.isEmpty ? .Gray2 : .Gray4)
                    .padding(.top, 4)
            } else {
                Text("*공백 없이 한글, 숫자, 영문만 입력 가능")
                    .Body2()
                    .foregroundColor(.Error)
                    .padding(.top, 4)
            }
            
            Spacer()
            
            doneButton
        }
        .onAppear {
            nickname = shortcutszipViewModel.userInfo?.nickname ?? ""
            shortcutszipViewModel.fetchUser(userID: shortcutszipViewModel.currentUser(), completionHandler: { user in
                self.user = user
            })
        }
        .onDisappear {
            shortcutszipViewModel.fetchUser(userID: shortcutszipViewModel.currentUser()) { user in
                shortcutszipViewModel.userInfo = user
            }
        }
        .padding(.horizontal, 16)
        .padding(.bottom, 44)
        .background(Color.Background)
        .navigationTitle("닉네임 수정")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    
    ///닉네임 입력 텍스트필드
    var textField: some View {
        HStack {
            TextField("닉네임 (최대 8글자)", text: $nickname)
                .Body2()
                .focused($isFocused)
                .foregroundColor(.Gray5)
                .frame(height: 20)
                .padding(.leading, 16)
                .padding(.vertical, 12)
                .onAppear(perform : UIApplication.shared.hideKeyboard)
                .onChange(of: nickname) {_ in
                    isValidLength = nickname.count <= 8 && !nickname.isEmpty
                    isNicknameChecked = false
                    isNormalString = nickname.checkCorrectNickname()
                }
            if !nickname.isEmpty {
                textFieldSFSymbol
            }
        }
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .strokeBorder(lineWidth: 1)
                .foregroundColor(isNicknameChecked ? .Success : (isValidLength && isNormalString ? .Gray3 : (nickname.isEmpty ? .Gray3 : .red)))
        )
    }
    
    ///텍스트필드 SFsymbol 및 버튼
    ///중복확인이 되지 않았을 때는 x버튼을 표시하고, 눌렀을 때 nickname을 지웁니다.
    ///중복확인이 되었을 때는 check 이미지를 표시합니다.
    var textFieldSFSymbol: some View {
        ZStack {
            if isNicknameChecked {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundColor(.Success)
                    .frame(height: 20)
                    .padding(.leading, 8)
                    .padding(.trailing, 16)
            }
            else {
                Button(action: {
                    nickname.removeAll()
                }, label: {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.Gray4)
                        .frame(height: 20)
                })
                .padding(.leading, 8)
                .padding(.trailing, 16)
                .disabled(nickname.isEmpty)
                
            }
        }
    }
    
    ///닉네임 중복확인 버튼
    var nicknameCheckButton: some View {
        Button(action: {
            checkNicknameDuplicate = true
            
            shortcutszipViewModel.checkNickNameDuplication(name: nickname) { result in
                isDuplicatedNickname = result
                isNicknameChecked = !result
            }
            
            isFocused = false
        }, label: {
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .foregroundColor(isValidLength && isNormalString ? .Gray5 : .Gray1)
                    .frame(width: 80, height: 44)
                Text("중복확인")
                    .foregroundColor(isValidLength && isNormalString ? .Text_icon : .Gray3)
            }
        })
        .disabled(!isValidLength || !isNormalString)
        ///alert 띄우는 코드
        .alert("닉네임 중복 확인", isPresented: $checkNicknameDuplicate) {
            Button(role: .cancel) {
                
            } label: {
                Text(isDuplicatedNickname ? "다시 입력하기" : "확인")
            }
        } message: {
            Text(isDuplicatedNickname ? "중복된 닉네임이 있습니다" : "중복된 닉네임이 없습니다")
        }
    }
    
    ///완료 버튼
    var doneButton: some View {
        Button(action: {
            user?.nickname = self.nickname
            shortcutszipViewModel.setData(model: user!)
            
            profileNavigation.navigationPath.removeLast()
        }, label: {
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .foregroundColor(isNicknameChecked && isNormalString ? .Primary : .Primary .opacity(0.13))
                    .frame(height: 52)
                Text("완료")
                    .foregroundColor(.Text_icon)
            }
        })
        .disabled(!isNicknameChecked || !isNormalString)
    }
}

struct EditNicknameView_Previews: PreviewProvider {
    static var previews: some View {
        EditNicknameView()
    }
}

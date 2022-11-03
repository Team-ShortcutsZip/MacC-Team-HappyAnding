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
    
    @AppStorage("signInStatus") var signInStatus = false
    @EnvironmentObject var userAuth: UserAuth
    
    @State var nickname: String = ""
    @State var checkNicknameDuplicate: Bool = false
    @State var isDuplicatedNickname: Bool = false
    @State var isNicknameChecked: Bool = false
    
    let user = Auth.auth().currentUser
    let firebase = FirebaseService()
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("닉네임을 입력해주세요")
                .Title1()
                .foregroundColor(.Gray5)
                .padding(.top, 40)
            
            HStack(spacing: 14) {
                textField
                nicknameCheckButton
            }
            .padding(.top, 16)
            
            Text("*공백 없이 한글, 숫자, 영문만 입력 가능")
                .Body2()
                .foregroundColor(nickname.isEmpty ? .Gray2 : .Gray4)
                .padding(.top, 4)
            
            Spacer()
            
            startButton
        }
        .padding(.horizontal, 16)
        .padding(.bottom, 44)
        .background(.background)
    }
    
    ///닉네임 입력 텍스트필드
    var textField: some View {
        ZStack(alignment: .leading) {
            HStack {
                TextField("닉네임 (최대 8글자)", text: $nickname)
                    .Body2()
                    .foregroundColor(.Gray5)
                    .frame(height: 20)
                    .padding(.leading, 16)
                    .padding(.vertical, 12)
                
                if !nickname.isEmpty {
                    textFieldSFSymbol
                }
            }
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(lineWidth: 1)
                    .foregroundColor(isNicknameChecked ? .Success : .Gray3)
            )
        }
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
                    nickname = ""
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
            //이거 바꿔서 alert 띄움
            checkNicknameDuplicate = true
            
            firebase.checkNickNameDuplication(name: nickname) { result in
                isDuplicatedNickname = result
                isNicknameChecked = !result
            }
        }, label: {
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .foregroundColor(.Gray5)
                    .frame(width: 80, height: 44)
                Text("중복확인")
                    .foregroundColor(.Background)
            }
        })
        .disabled(nickname.isEmpty)
        ///alert 띄우는 코드
        .alert(isPresented: $checkNicknameDuplicate){
            Alert(title: Text("닉네임 중복 확인"),
                  message: Text(isDuplicatedNickname ? "중복된 닉네임이 있습니다" : "중복된 닉네임이 없습니다"),
                  dismissButton: .default(Text(isDuplicatedNickname ? "다시 입력하기" : "확인")))
        }
    }
    
    ///시작하기 버튼
    var startButton: some View {
        Button(action: {
            userAuth.signUp()
            
            withAnimation(.easeInOut) {
                self.signInStatus = true
            }
            
            firebase.setData(model: User(id: user?.uid ?? "", nickname: nickname, likedShortcuts: [String](), downloadedShortcuts: [String]()))
        }, label: {
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .foregroundColor(isNicknameChecked ? .Primary : .Gray1)
                    .frame(height: 52)
                Text("시작하기")
                    .foregroundColor(isNicknameChecked ? .Background : .Gray3)
            }
        })
        .disabled(!isNicknameChecked)
    }
}

struct WriteNicknameView_Previews: PreviewProvider {
    static var previews: some View {
        WriteNicknameView()
    }
}

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
    @State var user: User?
    @State var isValid = false
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("닉네임을 수정해주세요")
                .Title1()
                .foregroundColor(.Gray5)
                .padding(.top, 40)
            
            NicknameTextField(nickname: $nickname, isValid: $isValid, initName: self.user?.nickname ?? "")
            .padding(.top, 16)

            Spacer()
            
            doneButton
        }
        .onAppear {
            nickname = shortcutszipViewModel.userInfo?.nickname ?? ""
//<<<<<<< HEAD
            shortcutszipViewModel.fetchUser(userID: shortcutszipViewModel.currentUser(),
                                            isCurrentUser: true) { user in
//=======
//            shortcutszipViewModel.fetchUser(userID: shortcutszipViewModel.currentUser()) { user in
//>>>>>>> develop
                self.user = user
            }
        }
        .onDisappear {
            shortcutszipViewModel.fetchUser(userID: shortcutszipViewModel.currentUser(),
                                            isCurrentUser: true) { user in
                shortcutszipViewModel.userInfo = user
            }
        }
        .padding(.horizontal, 16)
        .padding(.bottom, 44)
        .background(Color.Background)
        .navigationTitle("닉네임 수정")
        .navigationBarTitleDisplayMode(.inline)
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
                    .foregroundColor(isValid ? .Primary : .Primary .opacity(0.13))
                    .frame(height: 52)
                Text("완료")
                    .foregroundColor(isValid ? .Text_icon : .Text_Button_Disable)
                    .Body1()
            }
        })
        .disabled(!isValid)
    }
}

struct EditNicknameView_Previews: PreviewProvider {
    static var previews: some View {
        EditNicknameView()
    }
}

//
//  WriteNicknameView.swift
//  HappyAnding
//
//  Created by 이지원 on 2022/11/01.
//

import SwiftUI

import FirebaseAuth

struct WriteNicknameView: View {
    
    @AppStorage("signInStatus") var signInStatus = false
    @EnvironmentObject var userAuth: UserAuth
    
    let user = Auth.auth().currentUser
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
            .onTapGesture {
                userAuth.signUp()
                
                // TODO: SignOut 할 때 SignInStatus false로 설정 필요
                
                withAnimation(.easeInOut) {
                    self.signInStatus = true
                }
            }
            .onAppear {
                if let user {
                    print("Current User ID = \(user.uid)")
                }
            }
    }
}

struct WriteNicknameView_Previews: PreviewProvider {
    static var previews: some View {
        WriteNicknameView()
    }
}

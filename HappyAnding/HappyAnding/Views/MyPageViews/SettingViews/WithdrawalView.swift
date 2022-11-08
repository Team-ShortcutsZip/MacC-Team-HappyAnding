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
    
    @State var isTappedCheckToggle = true
    @State var isTappedSignOutButton = false
    
    var body: some View {
        VStack {
            
            
            Spacer()
            
            Button(action: {
                self.isTappedSignOutButton = true
            }) {
                ZStack {
                    RoundedRectangle(cornerRadius: 12)
                        .foregroundColor(isTappedCheckToggle ? .Primary : .Gray1)
                        .frame(maxWidth: .infinity, maxHeight: 52)
                    
                    Text("탈퇴하기")
                        .foregroundColor(isTappedCheckToggle ? .Text_Button : .Text_Button_Disable )
                        .Body1()
                }
            }
            .padding(.bottom, 44)
            .alert(isPresented: $isTappedSignOutButton) {
                Alert(title: Text("탈퇴하기"),
                      message: Text("ShortcutsZip에서 탈퇴하시겠습니까?"),
                      primaryButton: .default(Text("취소")
                                              ,action: { self.isTappedSignOutButton = false }),
                      secondaryButton: .destructive( Text("탈퇴"), action: { signOut() }))
            }
        }
        .padding(.horizontal, 16)
        .navigationTitle("탈퇴하기")
    }
    
    private func signOut() {
        let firebaseAuth = Auth.auth()
        do {
            let currentUser = firebaseAuth.currentUser
            if let user = shortcutsZipViewModel.userInfo {
                shortcutsZipViewModel.deleteData(model: user)
                userAuth.signOut()
                
                currentUser?.delete { error in
                    if let error {
                        print(error.localizedDescription)
                    } else {
                        print("success delete user auth")
                    }
                }
            }
//            try firebaseAuth.signOut( )
            self.signInStatus = false
        } catch {
            print(error.localizedDescription)
        }
    }
    
}

struct WithdrawalView_Previews: PreviewProvider {
    static var previews: some View {
        WithdrawalView()
    }
}

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
    
    @AppStorage("signInStatus") var signInStatus = false
    @AppStorage("isReauthenticated") var isReauthenticated = false
    @AppStorage("isTappedSignOutButton") var isTappedSignOutButton = false
    
    @State private var appleLoginCoordinator: AppleAuthCoordinator?
    @State var isTappedCheckToggle = false
    
    private let signOutTitle = [TextLiteral.withdrawalViewDeleteTitle,
                                TextLiteral.withdrawalViewNoDeleteTitle]
    private let signOutDescription = [TextLiteral.withdrawalViewDeleteContent, TextLiteral.withdrawalViewNoDeleteContent]
    
    var body: some View {
        VStack(alignment: .leading) {
            
            Text(TextLiteral.withdrawalViewHeadline)
                .Title2()
                .foregroundColor(.gray5)
                .multilineTextAlignment(.leading)
                .padding(.vertical, 32)
            
            ForEach(0..<signOutTitle.count, id: \.self) { index in
                Text(signOutTitle[index])
                    .Body2()
                    .foregroundColor(.gray5)
                    .padding(.bottom, 8)
                
                Text(signOutDescription[index])
                    .Body2()
                    .foregroundColor(.gray3)
                    .padding(.bottom, 16)
            }
            
            Spacer()
            
            HStack(spacing: 8) {
                Image(systemName: isTappedCheckToggle ? "checkmark.square.fill" : "square")
                    .mediumIcon()
                    .foregroundColor(isTappedCheckToggle ? .shortcutsZipPrimary : .gray4)
                    .onTapGesture {
                        isTappedCheckToggle.toggle()
                    }
                Text(TextLiteral.withdrawalViewAgree)
                    .Body2()
                    .foregroundColor(.gray4)
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
                        .foregroundColor(isTappedCheckToggle ? .shortcutsZipPrimary : .shortcutsZipPrimary .opacity(0.13))
                        .frame(maxWidth: .infinity, maxHeight: 52)
                    
                    Text(TextLiteral.withdrawalViewButton)
                        .foregroundColor(isTappedCheckToggle ? .textButton : .textButtonDisable )
                        .Body1()
                }
            }
            .disabled(!isTappedCheckToggle)
            .padding(.bottom, 44)
            .alert(TextLiteral.withdrawalViewAlertTitle, isPresented: $isReauthenticated) {
                Button(role: .cancel) {
                    isReauthenticated = false
                } label: {
                    Text(TextLiteral.cancel)
                }
                
                Button(role: .destructive) {
                    signOut()
                } label: {
                    Text(TextLiteral.withdrawalViewAlertAction)
                }
            } message: {
                Text(TextLiteral.withdrawalViewAlertMessage)
            }
        }
        .padding(.horizontal, 16)
        .background(Color.shortcutsZipBackground)
        .navigationTitle(TextLiteral.withdrawalViewTitle)
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

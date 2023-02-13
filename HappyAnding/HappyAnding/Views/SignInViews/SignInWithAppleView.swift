//
//  SignUpView.swift
//  HappyAnding
//
//  Created by 이지원 on 2022/11/01.
//

import SwiftUI
import FirebaseAuth

struct SignInWithAppleView: View {
    
    @EnvironmentObject var shortcutsZipViewModel: ShortcutsZipViewModel
    
    @Environment(\.window) var window: UIWindow?
    @EnvironmentObject var userAuth: UserAuth
    
    @AppStorage("useWithoutSignIn") var useWithoutSignIn = false
    
    @State private var appleLoginCoordinator: AppleAuthCoordinator?
    
    var body: some View {
        
        VStack {
            
            Spacer()
            
            Image("logo")
                .padding(.bottom, 28)
            
            Text(TextLiteral.SignInWithAppleViewTitle)
                .LargeTitle()
                .foregroundColor(.shortcutsZipPrimary)
            
            Text(TextLiteral.SignInWithAppleViewSubTitle)
                .Body2()
                .foregroundColor(.gray3)
            
            Spacer()
            
            Button(action: {
                appleLogin()
            }, label: {
                ZStack {
                    RoundedRectangle(cornerRadius: 12)
                        .padding(.horizontal, 16)
                        .frame(height: 52)
                        .foregroundColor(.gray5)
                    
                    Label(TextLiteral.SignInWithAppleViewSignInWithApple, systemImage: "applelogo")
                        .foregroundColor(.shortcutsZipWhite)
                }
                .padding(.bottom, 8)
            })
            
            Button(action: {
                setDefaultUserSetting()
                useWithoutSignIn = true
            }, label: {
                Text(TextLiteral.SignInWithAppleViewUseWithoutSignIn)
                    .Body2()
                    .foregroundColor(.gray5)
            })
            .padding(.bottom, 12)
        }
        .background(Color.shortcutsZipBackground)
    }
    
    func appleLogin() {
        appleLoginCoordinator = AppleAuthCoordinator(window: window, isTappedSignInButton: true)
        appleLoginCoordinator?.startSignInWithAppleFlow()
            UserDefaults.shared.set(true, forKey: "isSignInForShareExtension")
    }
    
    private func setDefaultUserSetting() {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            shortcutsZipViewModel.resetUser()
            UserDefaults.shared.set(false, forKey: "isFirstLaunch")
        } catch {
            print(error.localizedDescription)
        }
    }

}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignInWithAppleView()
    }
}


/// SwiftUI에 없는 window를 처리하는 구조체
struct WindowKey: EnvironmentKey {
    struct Value {
        weak var value: UIWindow?
    }
    
    static let defaultValue: Value = .init(value: nil)
}

/// UIWindow를 파악하여 넣어줄 수 있도록 설정
extension EnvironmentValues {
    var window: UIWindow? {
        get {
            return self[WindowKey.self].value
        }
        set {
            self[WindowKey.self] = .init(value: newValue)
        }
    }
}

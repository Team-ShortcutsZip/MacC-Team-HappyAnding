//
//  SignUpView.swift
//  HappyAnding
//
//  Created by 이지원 on 2022/11/01.
//

import SwiftUI

struct SignInWithAppleView: View {
    
    @Environment(\.window) var window: UIWindow?
    @EnvironmentObject var userAuth: UserAuth
        
    @State private var appleLoginCoordinator: AppleAuthCoordinator?
    
    var body: some View {
        
        VStack {
            
            Spacer()
            
            Image("logo")
                .padding(.bottom, 28)
            
            Text("ShortcutsZip")
                .LargeTitle()
                .foregroundColor(.Primary)
            
            Text("단축어 생활의 시작")
                .Body2()
                .foregroundColor(.Gray3)
            
            Spacer()
            
            Button(action: {
                appleLogin()
            }, label: {
                ZStack {
                    RoundedRectangle(cornerRadius: 12)
                        .padding(.horizontal, 16)
                        .frame(height: 52)
                        .foregroundColor(.Gray5)
                    
                    Text("\(Image(systemName: "applelogo")) Apple로 로그인")
                        .foregroundColor(.White)
                }
                .padding(.bottom, 37)
            })
        }
        .background(Color.Background)
    }
    
    func appleLogin() {
        appleLoginCoordinator = AppleAuthCoordinator(window: window)
        appleLoginCoordinator?.startSignInWithAppleFlow()
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

//
//  SignUpView.swift
//  HappyAnding
//
//  Created by 이지원 on 2022/11/01.
//

import SwiftUI

struct SignUpView: View {
    
    @Environment(\.window) var window: UIWindow?
    @State private var appleLoginCoordinator: AppleAuthCoordinator?
    
    var body: some View {
        
        VStack {
            
            Spacer()
            
            Image("AppIcon")
                .padding(.bottom, 28)
                .frame(width: 128, height: 128)
            
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
                    
                    Text("\(Image(systemName: "applelogo")) 애플로 로그인")
                        .foregroundColor(.White)
                }
                .padding(.bottom, 88)
            })
            
        }
    }
    
    func appleLogin() {
        appleLoginCoordinator = AppleAuthCoordinator(window: window)
        appleLoginCoordinator?.startAppleLogin()
    }
}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView()
    }
}



struct WindowKey: EnvironmentKey {
    struct Value {
        weak var value: UIWindow?
    }
    
    static let defaultValue: Value = .init(value: nil)
}

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

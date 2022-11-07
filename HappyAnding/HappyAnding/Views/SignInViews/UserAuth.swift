//
//  UserAuth.swift
//  HappyAnding
//
//  Created by 이지원 on 2022/11/01.
//

import Foundation

class UserAuth: ObservableObject {
    
    @Published var isLoggedIn = false
    
    static let shared = UserAuth()
    
    func signIn() {
        self.isLoggedIn = true
    }
}

//
//  UserAuth.swift
//  HappyAnding
//
//  Created by 이지원 on 2022/11/01.
//

import Foundation

class UserAuth: ObservableObject {
    
    @Published var isLoggedIn = false
    @Published var isUser = false
    
    static let shared = UserAuth()
    
    func login() {
        self.isLoggedIn = true
    }
    
    
    // TODO: Firebase로 user가 닉네임이 존재하는지 확인?
    
    func verifyUser() {
        self.isUser = true
    }
}

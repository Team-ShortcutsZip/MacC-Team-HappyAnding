//
//  SwiftUIView.swift
//  HappyAnding
//
//  Created by 전지민 on 2023/02/12.
//

import SwiftUI

class Alerter: ObservableObject {
    @Published var isPresented = false
}

struct LoginAlertKey: EnvironmentKey {
    static let defaultValue = Alerter()
}

struct GradeAlertKey: EnvironmentKey {
    static let defaultValue = Alerter()
}

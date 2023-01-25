//
//  Alert+Extension.swift
//  HappyAnding
//
//  Created by 전지민 on 2023/01/25.
//

import Foundation
import SwiftUI

struct LoginAlertKey: EnvironmentKey {
    static let defaultValue = Alerter()
}

extension EnvironmentValues {
    var loginAlertKey: Alerter {
        get { return self[LoginAlertKey] }
        set { self[LoginAlertKey] = newValue }
    }
}

class Alerter: ObservableObject {
    @Published var showAlert = false
}

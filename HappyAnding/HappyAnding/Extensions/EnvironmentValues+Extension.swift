//
//  Alert+Extension.swift
//  HappyAnding
//
//  Created by 전지민 on 2023/01/25.
//

import SwiftUI

extension EnvironmentValues {
    var loginAlertKey: Alerter {
        get { return self[LoginAlertKey.self] }
        set { self[LoginAlertKey.self] = newValue }
    }
}

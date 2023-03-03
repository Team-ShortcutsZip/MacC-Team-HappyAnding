//
//  URL+Extension.swift
//  HappyAnding
//
//  Created by KiWoong Hong on 2022/11/18.
//

import SwiftUI

extension URL {
    
    /// info 에서 추가한 딥링크가 들어왔는지 여부
    var isDeeplink: Bool {
        return scheme == "shortcutsZip"
    }
}


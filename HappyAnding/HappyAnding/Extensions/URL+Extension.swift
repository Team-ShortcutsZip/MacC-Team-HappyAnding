//
//  URL+Extension.swift
//  HappyAnding
//
//  Created by KiWoong Hong on 2022/11/18.
//

import SwiftUI

extension URL {
    
    // info 에서 추가한 딥링크가 들어왔는지 여부
    var isDeeplink: Bool {
        return scheme == "shortcutsZip"
    }
    
    // url 들어오는 것으로 어떤 타입의 탭을 보여줘야 하는지 가져오기
    // TabIdentifier 필요
    var tabIdentifier: Tab? {
        guard isDeeplink else { return nil }
        
        // shortcutsZip://host
        switch host {
        case "collect ": return .collect
        case "exploreShortcut": return .exploreShortcut
        case "myPage": return .myPage
        default: return nil
        }
    }
    
    // pageIdentifier 필요할 듯?
  //  var detailPage:
}


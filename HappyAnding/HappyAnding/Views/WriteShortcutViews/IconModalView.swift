//
//  IconModalView.swift
//  HappyAnding
//
//  Created by 이지원 on 2022/10/19.
//

import SwiftUI

struct IconModalView: View {
    
    // MARK: WriteShortcutTitleView에서의 확인을 위해 임시로 작성한 코드입니다.
    
    @Binding var isShowing: Bool
    @Binding var iconColor: String
    @Binding var iconSymbol: String
    
    var body: some View {
        TextField("컬러", text: $iconColor)
        TextField("심볼", text: $iconSymbol)
        Button(action: {
            isShowing = false
        }, label: {
            Text("완료")
        })
        .disabled(iconColor.isEmpty || iconSymbol.isEmpty)
    }
}

struct IconModalView_Previews: PreviewProvider {
    static var previews: some View {
        IconModalView(isShowing: .constant(true), iconColor: .constant("LightPurple"), iconSymbol: .constant("bus.fill"))
    }
}

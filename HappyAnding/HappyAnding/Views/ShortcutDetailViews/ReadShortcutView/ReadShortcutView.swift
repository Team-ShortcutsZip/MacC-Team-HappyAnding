//
//  ReadShortcutView.swift
//  HappyAnding
//
//  Created by 이지원 on 2022/10/19.
//

import SwiftUI

struct ReadShortcutView: View {
    var body: some View {
        VStack {
            ReadShortcutHeaderView()
            
            ZStack(alignment: .bottom) {
                ReadShortcutContentView()
                Button(action: {
                    //Place something action here
                }) {
                    //Button label
                    Text("button")
                }
            }
        }.navigationBarItems(trailing: Text("trailing"))
    }
}

struct ReadShortcutView_Previews: PreviewProvider {
    static var previews: some View {
        ReadShortcutView()
    }
}

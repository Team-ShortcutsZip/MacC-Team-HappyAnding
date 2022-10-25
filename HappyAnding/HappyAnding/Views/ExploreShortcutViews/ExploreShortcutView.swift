//
//  ExploreShortcutView.swift
//  HappyAnding
//
//  Created by 이지원 on 2022/10/19.
//

import SwiftUI

struct ExploreShortcutView: View {
    
    let firebase = FirebaseService()
    let testData = Shortcuts(sfSymbol: "bag", color: "Red", title: "titld", subtitle: "1", description: "2", category: ["3"], requiredApp: ["4"], date: Date(), numberOfLike: 1, numberOfDownload: 1, author: "dd", downloadLink: ["https://www.icloud.com/shortcuts/fef3df84c4ae4bea8a411c8566efe280"])
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
            .onAppear {
                firebase.fetchShortcut(model: "Shortcut")
            }
            .onTapGesture {
//                firebase.createShortcut(shortcut: testData)
                firebase.createData(model: testData)
            }
    }
}

struct ExploreShortcutView_Previews: PreviewProvider {
    static var previews: some View {
        ExploreShortcutView()
    }
}

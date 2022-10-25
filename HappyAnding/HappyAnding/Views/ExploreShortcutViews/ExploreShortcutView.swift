//
//  ExploreShortcutView.swift
//  HappyAnding
//
//  Created by 이지원 on 2022/10/19.
//

import SwiftUI

struct ExploreShortcutView: View {
    
    let firebase = FirebaseService()
    let testData = Shortcuts(sfSymbol: "books", color: "Red", title: "titld", subtitle: "1", description: "2", category: ["3"], requiredApp: ["4"], date: Date(), numberOfLike: 1, numberOfDownload: 1, author: "dd")
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
            .onAppear {
                firebase.fetchShortcut()
            }
            .onTapGesture {
                firebase.createShortcut(shortcut: testData)
            }
    }
}

struct ExploreShortcutView_Previews: PreviewProvider {
    static var previews: some View {
        ExploreShortcutView()
    }
}

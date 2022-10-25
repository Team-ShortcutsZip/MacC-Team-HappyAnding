//
//  ExploreShortcutView.swift
//  HappyAnding
//
//  Created by 이지원 on 2022/10/19.
//

import SwiftUI

struct ExploreShortcutView: View {
    
    let firebase = FirebaseService()
    @State var shortcutsArray: [Shortcuts] = []
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
            .onAppear {
                firebase.fetchShortcut(model: "Shortcut") { shortcuts in
                    shortcutsArray = shortcuts
                }
            }
            .onTapGesture {
                firebase.fetchCategoryLikedList(category: "education") { shortcuts in
                    shortcutsArray = shortcuts
                    print(shortcutsArray)
                }
            }
    }
}

struct ExploreShortcutView_Previews: PreviewProvider {
    static var previews: some View {
        ExploreShortcutView()
    }
}

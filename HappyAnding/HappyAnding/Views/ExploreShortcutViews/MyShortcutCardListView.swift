//
//  MyShortcutCardListView.swift
//  HappyAnding
//
//  Created by KiWoong Hong on 2022/10/22.
//

import SwiftUI

struct MyShortcutCardListView: View {
    var body: some View {
        VStack {
            Text("내 단축어")
                .Title2()
                .padding(.leading, 16)
                .foregroundColor(Color.Gray5)
                .frame(maxWidth: .infinity,alignment: .leading)
            
            ScrollView(.horizontal) {
                HStack {
                    AddMyShortcutCardView()
                    MyShortcutCardView(myShortcutIcon: "book.fill", myShortcutName: "노는게 제일조아", mySHortcutColor: "Coral")
                    MyShortcutCardView(myShortcutIcon: "book.fill", myShortcutName: "노는게 제일조아", mySHortcutColor: "Coral")
                    MyShortcutCardView(myShortcutIcon: "book.fill", myShortcutName: "노는게 제일조아", mySHortcutColor: "Coral")
                    MyShortcutCardView(myShortcutIcon: "book.fill", myShortcutName: "노는게 제일조아", mySHortcutColor: "Coral")
                    MyShortcutCardView(myShortcutIcon: "book.fill", myShortcutName: "노는게 제일조아", mySHortcutColor: "Coral")
                }
                .padding(.leading, 16)
            }
        }
    }
}

struct MyShortcutCardListView_Previews: PreviewProvider {
    static var previews: some View {
        MyShortcutCardListView()
    }
}

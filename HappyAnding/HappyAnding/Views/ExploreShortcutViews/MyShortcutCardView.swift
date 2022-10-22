//
//  MyShortcutCardView.swift
//  HappyAnding
//
//  Created by KiWoong Hong on 2022/10/22.
//

import SwiftUI

struct MyShortcutCardView: View {
    
    let myShortcutIcon: String
    let myShortcutName: String
    let mySHortcutColor: String
    
    var body: some View {
        VStack(alignment: .trailing) {
            Spacer()
            HStack {
                Image(systemName: myShortcutIcon)
                    .frame(alignment: .leading)
                    .font(.title2)
                    .foregroundColor(Color.Gray1)
                    Spacer()
            }.padding(.bottom, 3)
            HStack {
                Text(myShortcutName)
                    .Subtitle()
                    .frame(alignment: .leading)
                    .foregroundColor(Color.Gray1)
                Spacer()
            }
        }
        .padding()
        .frame(width: 107, height: 144, alignment: .leading)
        .background(Color.fetchGradient(color: mySHortcutColor))
        .cornerRadius(15)
    }
}

struct MyShortcutCardView_Previews: PreviewProvider {
    static var previews: some View {
        MyShortcutCardView(myShortcutIcon: "book.fill", myShortcutName: "노는게 제일조아", mySHortcutColor: "Coral")
    }
}

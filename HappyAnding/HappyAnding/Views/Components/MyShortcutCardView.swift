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
    let myShortcutColor: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Image(systemName: myShortcutIcon)
                .frame(width: 30.0, height: 30.0)
                .font(.title2)
                .foregroundColor(Color.Text_icon)
            Text(myShortcutName)
                .Subtitle()
                .multilineTextAlignment(.leading)
                .foregroundColor(Color.Text_icon)
                .lineLimit(3)
            Spacer()
        }
        .padding(.all, 12)
        .frame(width: 107, height: 144, alignment: .leading)
        .background(Color.fetchGradient(color: myShortcutColor))
        .cornerRadius(12)
    }
}

struct AddMyShortcutCardView: View {
    
    var body: some View {
        VStack {
            Image(systemName: "plus")
                .font(.title2)
                .foregroundColor(Color.Gray4)
        }
        .padding()
        .frame(width: 107, height: 144)
        .background(Color.Background_plus)
        .cornerRadius(12)
    }
}

struct MyShortcutCardView_Previews: PreviewProvider {
    static var previews: some View {
        MyShortcutCardView(myShortcutIcon: "book.fill", myShortcutName: "택배     조회하기", myShortcutColor: "Coral")
        AddMyShortcutCardView()
    }
}

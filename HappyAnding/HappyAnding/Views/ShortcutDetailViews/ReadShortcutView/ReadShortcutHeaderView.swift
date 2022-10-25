//
//  ReadShortcutHeaderView.swift
//  HappyAnding
//
//  Created by KiWoong Hong on 2022/10/24.
//

import SwiftUI

struct ReadShortcutHeaderView: View {
    //icon
    //numberOfLike
    //name
    //한줄설명
    
    let icon: String
    let color: String
    let numberOfLike: Int
    let name: String
    let oneline: String
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                VStack {
                    Image(systemName: icon)
                        .foregroundColor(Color.White)
                }
                .frame(width: 52, height: 52)
                .background(Color.fetchGradient(color: color))
                .cornerRadius(8)
                
                Spacer()
                
                HStack {
                    Image(systemName: "hand.thumbsup")
                    Text("\(numberOfLike)")
                }
                .Body2()
                .padding(10)
                .foregroundColor(Color.Gray4)
                .background(Color.Gray1)
                .cornerRadius(12)
            }
            Text("\(name)")
                .Title1()
                .foregroundColor(Color.Gray5)
            Text("\(oneline)")
                .Body1()
                .foregroundColor(Color.Gray3)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 16)
    }
}

struct ReadShortcutHeaderView_Previews: PreviewProvider {
    static var previews: some View {
        ReadShortcutHeaderView(icon: "book", color: "Coral", numberOfLike: 99, name: "주변 커피집 걸어가기", oneline: "걸어가보자!!!")
    }
}

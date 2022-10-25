//
//  ReadShortcutHeaderView.swift
//  HappyAnding
//
//  Created by KiWoong Hong on 2022/10/24.
//

import SwiftUI

struct ReadShortcutHeaderView: View {
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                VStack {
                    Image(systemName: "leaf")
                        .foregroundColor(Color.White)
                }
                .frame(width: 52, height: 52)
                .background(Color.fetchGradient(color: "Coral"))
                .cornerRadius(8)
                
                Spacer()
                
                HStack {
                    Image(systemName: "hand.thumbsup")
                    Text("132")
                }
                .Body2()
                .padding(10)
                .foregroundColor(Color.Gray4)
                .background(Color.Gray1)
                .cornerRadius(12)
            }
            Text("Title")
                .Title1()
                .foregroundColor(Color.Gray5)
            Text("simple descriasdfsafsafsafption")
                .Body1()
                .foregroundColor(Color.Gray3)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 16)
    }
}

struct ReadShortcutHeaderView_Previews: PreviewProvider {
    static var previews: some View {
        ReadShortcutHeaderView()
    }
}

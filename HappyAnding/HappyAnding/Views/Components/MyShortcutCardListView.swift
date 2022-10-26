//
//  MyShortcutCardListView.swift
//  HappyAnding
//
//  Created by KiWoong Hong on 2022/10/22.
//

import SwiftUI

struct MyShortcutCardListView: View {
    
    let shortcuts = Shortcut.fetchData(number: 15)
    
    var body: some View {
        VStack {
            HStack {
                Text("내 단축어")
                    .Title2()
                    .foregroundColor(Color.Gray5)
                .frame(maxWidth: .infinity, alignment: .leading)
                
                Spacer()
                
                NavigationLink(destination: {
                    Text("임시")
                }, label: {
                    Text("더보기")
                        .Footnote()
                        .foregroundColor(Color.Gray4)
                        .padding(.trailing, 16)
                })
            }
            .padding(.leading, 16)
            
            ScrollView(.horizontal) {
                HStack {
                    NavigationLink(destination: {
                        Text("임시")
                    }, label: {
                        AddMyShortcutCardView()
                    })
                    
                    ForEach(shortcuts) { shortcut in
                        NavigationLink(destination: {
                            Text("임시")
                        }, label: {
                            MyShortcutCardView(myShortcutIcon: shortcut.sfSymbol, myShortcutName: shortcut.name, mySHortcutColor: shortcut.color)
                        })
                    }
                }
                .padding(.leading, 16)
            }
        }
    }
}

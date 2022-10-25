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
            ReadShortcutContentView()
            Button(action: {
        
            }) {
                RoundedRectangle(cornerRadius: 12)
                    .foregroundColor(Color.Primary)
                    .frame(height: 52)
                    .padding(.horizontal, 16)
                    .overlay {
                        HStack {
                            Text("다운로드 |")
                            Image(systemName: "arrow.down.app")
                            Text("45")
                        }
                        .Body1()
                        .foregroundColor(Color.Background)
                    }
            }
        }
        .padding(.vertical, 20)
        .background(Color.Background)
        .navigationBarItems(trailing: Menu(content: {
        }, label: {
            Image(systemName: "ellipsis")
        }))
    }
}

struct ReadShortcutView_Previews: PreviewProvider {
    static var previews: some View {
        ReadShortcutView()
    }
}

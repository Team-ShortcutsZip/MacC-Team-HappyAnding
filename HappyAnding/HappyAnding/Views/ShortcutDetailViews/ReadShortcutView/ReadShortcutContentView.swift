//
//  ReadShortcutContentView.swift
//  HappyAnding
//
//  Created by KiWoong Hong on 2022/10/24.
//

import SwiftUI

struct ReadShortcutContentView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                Text("작성자")
                    .Body2()
                    .foregroundColor(Color.Gray4)
                HStack {
                    Image(systemName: "leaf")
                    Text("로미")
                }
                
                Text("단축어 설명")
                    .Body2()
                    .foregroundColor(Color.Gray4)
                Text("bu\naa\nkfj\nsaa\nu\naa\nkfj\nsaa\nu\naa\nkfj\nsaa\nu\naa\nkfj\nsaa\nbula")
                    .padding(.bottom, 20)
                
                Text("카테고리")
                    .Body2()
                    .foregroundColor(Color.Gray4)
                Text("bulabulabulabula")
                    .padding(.bottom, 20)
                
                Text("단축어 사용에 필요한 앱")
                    .Body2()
                    .foregroundColor(Color.Gray4)
                Text("bulabulabulabula")
                    .padding(.bottom, 20)
                
                Text("단축어 사용을 위한 요구사항")
                    .Body2()
                    .foregroundColor(Color.Gray4)
                Text("bulabulabulabula")
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(20)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .overlay {
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.Gray2,lineWidth: 1)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 20)
    }
}

struct ReadShortcutContentView_Previews: PreviewProvider {
    static var previews: some View {
        ReadShortcutContentView()
    }
}

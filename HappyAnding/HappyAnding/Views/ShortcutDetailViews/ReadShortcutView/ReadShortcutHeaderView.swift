//
//  ReadShortcutHeaderView.swift
//  HappyAnding
//
//  Created by KiWoong Hong on 2022/10/24.
//

import SwiftUI

struct ReadShortcutHeaderView: View {
    
    let icon: String
    let color: String
    let name: String
    let oneline: String
    
    @State var numberOfLike: Int
    @State var isMyLike: Bool = false
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                VStack {
                    Image(systemName: icon)
                        .Title2()
                        .foregroundColor(Color.White)
                }
                .frame(width: 52, height: 52)
                .background(Color.fetchGradient(color: color))
                .cornerRadius(8)
                
                Spacer()
                
                Text("\(isMyLike ? Image(systemName: "hand.thumbsup.fill") : Image(systemName: "hand.thumbsup")) \(numberOfLike)")
                .Body2()
                .padding(10)
                .foregroundColor(isMyLike ? Color.White : Color.Gray4)
                .background(isMyLike ? Color.Primary : Color.Gray1)
                .cornerRadius(12)
                .onTapGesture(perform: {
                    isMyLike.toggle()
                    if isMyLike {
                        self.numberOfLike += 1
                    } else {
                        self.numberOfLike -= 1
                    }
                    // TODO: 추후 좋아요 데이터구조에 목록(?) 추가, 취소 기능 추가할 곳
                })
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
        ReadShortcutHeaderView(icon: "book", color: "Coral", name: "주변 커피집 걸어가기", oneline: "걸어가보자!!!", numberOfLike: 99)
    }
}

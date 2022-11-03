//
//  ReadShortcutHeaderView.swift
//  HappyAnding
//
//  Created by KiWoong Hong on 2022/10/24.
//

import SwiftUI

struct ReadShortcutHeaderView: View {
    
    @State var shortcut: Shortcuts
    @State var isMyLike: Bool = false
    let firebase = FirebaseService()
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                VStack {
                    Image(systemName: shortcut.sfSymbol)
                        .Title2()
                        .foregroundColor(Color.White)
                }
                .frame(width: 52, height: 52)
                .background(Color.fetchGradient(color: shortcut.color))
                .cornerRadius(8)
                
                Spacer()
                
                Text("\(isMyLike ? Image(systemName: "heart.fill") : Image(systemName: "heart")) \(shortcut.numberOfLike)")

                .Body2()
                .padding(10)
                .foregroundColor(isMyLike ? Color.White : Color.Gray4)
                .background(isMyLike ? Color.Primary : Color.Gray1)
                .cornerRadius(12)
                .onTapGesture(perform: {
                    isMyLike.toggle()
                    if isMyLike {
                        self.shortcut.numberOfLike += 1
                    } else {
                        self.shortcut.numberOfLike -= 1
                    }
                    // TODO: 추후 좋아요 데이터구조에 목록(?) 추가, 취소 기능 추가할 곳
                    firebase.updateNumberOfLike(isMyLike: isMyLike, shortcut: shortcut)
                })
            }
            Text("\(shortcut.title)")
                .Title1()
                .foregroundColor(Color.Gray5)
            Text("\(shortcut.subtitle)")
                .Body1()
                .foregroundColor(Color.Gray3)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 16)
        .onAppear() {
            firebase.checkLikedShortrcut(shortcutID: shortcut.id) { result in
                isMyLike = result
            }
            print("**\(isMyLike)")
        }
    }
}


//struct ReadShortcutHeaderView_Previews: PreviewProvider {
//    static var previews: some View {
//        ReadShortcutHeaderView(icon: "book", color: "Coral", numberOfLike: 99, name: "주변 커피집 걸어가기", oneline: "걸어가보자!!!")
//    }
//}

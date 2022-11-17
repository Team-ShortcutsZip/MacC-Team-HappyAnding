//
//  ReadShortcutHeaderView.swift
//  HappyAnding
//
//  Created by KiWoong Hong on 2022/10/24.
//

import SwiftUI

struct ReadShortcutHeaderView: View {
    
    @EnvironmentObject var shortcutsZipViewModel: ShortcutsZipViewModel
    
    @Binding var shortcut: Shortcuts
    @State var isMyLike: Bool = false
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                VStack {
                    Image(systemName: shortcut.sfSymbol)
                        .Title2()
                        .foregroundColor(Color.Text_icon)
                }
                .frame(width: 52, height: 52)
                .background(Color.fetchGradient(color: shortcut.color))
                .cornerRadius(8)
                
                Spacer()
                
                Text("\(isMyLike ? Image(systemName: "heart.fill") : Image(systemName: "heart")) \(shortcut.numberOfLike)")

                .Body2()
                .padding(10)
                .foregroundColor(isMyLike ? Color.Text_icon : Color.Gray4)
                .background(isMyLike ? Color.Primary : Color.Gray1)
                .cornerRadius(12)
                .onTapGesture(perform: {
                    isMyLike.toggle()
                    //화면 상의 좋아요 추가, 취소 기능 동작
                    if isMyLike {
                        self.shortcut.numberOfLike += 1
                    } else {
                        self.shortcut.numberOfLike -= 1
                    }
                    //데이터 상의 좋아요 추가, 취소 기능 동작
                    shortcutsZipViewModel.updateNumberOfLike(isMyLike: isMyLike, shortcut: shortcut)
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
            shortcutsZipViewModel.checkLikedShortrcut(shortcutID: shortcut.id) { result in
                isMyLike = result
            }
        }
    }
}


//struct ReadShortcutHeaderView_Previews: PreviewProvider {
//    static var previews: some View {
//        ReadShortcutHeaderView(icon: "book", color: "Coral", numberOfLike: 99, name: "주변 커피집 걸어가기", oneline: "걸어가보자!!!")
//    }
//}

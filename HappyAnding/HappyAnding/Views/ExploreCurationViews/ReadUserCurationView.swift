//
//  ReadUserCurationView.swift
//  HappyAnding
//
//  Created by HanGyeongjun on 2022/10/22.
//

import SwiftUI

struct ReadUserCurationView: View {
    var userCuration: UserCuration
    let nickName: String
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            ZStack(alignment: .bottom) {
                Color.White
                    .ignoresSafeArea(.all, edges: .all)
                    .frame(height: 371)
                
                VStack{
                    userInformation
                        .padding(.bottom, 22)
                    UserCurationCell(title: userCuration.title, subtitle: userCuration.subtitle, shortcuts: userCuration.shortcuts)
                        .padding(.bottom, 12)
                }
            }
            ForEach(Array(userCuration.shortcuts.enumerated()), id: \.offset) { index, shortcut in
                NavigationLink(destination: ReadShortcutView()) {
                    ShortcutCell(
                        color: shortcut.color,
                        sfSymbol: shortcut.sfSymbol,
                        name: shortcut.name,
                        description: shortcut.description,
                        numberOfDownload: shortcut.numberOfDownload,
                        downloadLink: shortcut.downloadLink
                    )
                    .padding(.bottom, index == userCuration.shortcuts.count - 1 ? 44 : 0)
                }
            }
        }
        .background(Color.Background.ignoresSafeArea(.all, edges: .all))
        .scrollContentBackground(.hidden)
        .edgesIgnoringSafeArea([.top])
    }
    
    var userInformation: some View {
        ZStack {
            HStack {
                Image(systemName: "person.fill")
                    .frame(width: 28, height: 28)
                    .foregroundColor(.White)
                    .background(Color.Gray3)
                    .clipShape(Circle())
                
                Text(nickName)
                    .Headline()
                    .foregroundColor(.Gray4)
                
                Spacer()
                //TODO: 스프린트 1에서 배제 , 추후 주석 삭제 필요
                /*
                Image(systemName: "light.beacon.max.fill")
                    .Headline()
                    .foregroundColor(.Gray5)
                    .onTapGesture {
                        
                        // TODO: 신고기능 연결
                        
                        print("Tapped!")
                    }
                 */
            }
            .padding(.horizontal, 30)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .frame(height: 48)
                    .foregroundColor(.Gray1)
                    .padding(.horizontal, 16)
            )
        }
    }
}

struct ReadUserCurationView_Previews: PreviewProvider {
    static var previews: some View {
        ReadUserCurationView(userCuration: UserCuration.fetchData(number: 1)[0], nickName: "test")
    }
}

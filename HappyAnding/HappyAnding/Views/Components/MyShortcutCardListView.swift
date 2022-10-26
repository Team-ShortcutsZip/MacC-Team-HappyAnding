//
//  MyShortcutCardListView.swift
//  HappyAnding
//
//  Created by KiWoong Hong on 2022/10/22.
//

import SwiftUI

// TODO: 더미데이터를 위한 임시 구조체. 더미데이터 머지 후 삭제 필요
// PR날리고 머지되면 나중에 컴파일 에러날까봐 Shortcut에서 MyShortcut으로 이름 바꿈


struct MyShortcut: Identifiable {
    ///cell에 필요한 정보들
    var id: UUID = UUID()
    var name: String
    var description: String
    var sfSymbol: String
    var color: String
    var numberOfDownload: Int
    var downloadLink: String

    ///detail
}

extension MyShortcut {
    ///리스트를 구성하기 위해 임의의 배열값을 불러오고 싶을 경우
    ///해당 뷰에서 let shortcuts = Shortcut.fetchData(number: 10) 처럼 호출해서 사용해주세요
    static func fetchData(number: Int) -> [MyShortcut] {

        var data = [MyShortcut]()
        let name = ["빠른길 찾기", "카카오톡 결제하기", "테스트 이름", "테스트 테스트 이름"]
        let description = ["이럴때 사용하면 더 좋아요", "이땐 이런건 어때요", "이것도 해보세요"]
        let sfSymbol = [
            "graduationcap.fill",
            "books.vertical.fill",
            "creditcard.fill",
            "creditcard.fill",
            "phone.fill",
            "cross.fill",
            "newspaper.fill",
            "newspaper.fill",
            "alarm.fill",
            "calendar",
            "cloud.sun.fill",
            "camera.fill",
            "paintpalette.fill",
            "paintbrush.fill",
            "hammer.fill",
            "tray.fill",
            "speaker.wave.2.fill",
            "gearshape.fill",
            "command.square.fill",
            "bubble.left.fill",
            "headphones",
            "gamecontroller.fill",
            "tram.fill",
            "bag.fill",
            "music.note",
            "hourglass.bottomhalf.filled"
        ]

        let colors = [
            "Red",
            "Coral",
            "Orange",
            "Yellow",
            "Green",
            "Mint",
            "Teal",
            "Cyan",
            "Blue",
            "Purple",
            "LightPurple",
            "Pink",
            "Gray",
            "Khaki",
            "Brown"
        ]

        let downloadLink = [
            "https://www.icloud.com/shortcuts/fef3df84c4ae4bea8a411c8566efe280",
            "https://www.icloud.com/shortcuts/54a5568f06ef44aabee61260298d088c",
            "https://www.icloud.com/shortcuts/09721945787b44e3a7d41d14af3d99c9",
            "https://www.icloud.com/shortcuts/22ba767a852a4d71a90e7e8d334a314a",
            "https://www.icloud.com/shortcuts/56b0933241ab47b8ac6cb3a6b1e43c47",
            "https://www.icloud.com/shortcuts/70581f62029b49048aec006eb8713ded"
        ]

        for _ in 0..<number {
            data.append(
                MyShortcut(
                    name: name.randomElement() ?? "name",
                    description: description.randomElement() ?? "desc",
                    sfSymbol: sfSymbol.randomElement() ?? "tram.fill",
                    color: colors.randomElement() ?? "Blue",
                    numberOfDownload: Int.random(in: 0..<9999),
                    downloadLink: downloadLink.randomElement() ?? "nil"
                )
            )
        }
        return data
    }
}

// MARK: MyshortcutCardListView

struct MyShortcutCardListView: View {
    
    let shortcuts = MyShortcut.fetchData(number: 15)
    
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
                    AddMyShortcutCardView()
                    
                    ForEach(shortcuts) { shortcut in
                        MyShortcutCardView(myShortcutIcon: shortcut.sfSymbol, myShortcutName: shortcut.name, mySHortcutColor: shortcut.color)
                    }
                }
                .padding(.leading, 16)
            }
        }
    }
}

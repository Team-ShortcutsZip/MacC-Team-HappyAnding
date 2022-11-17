//
//  ShortcutTestModel.swift
//  HappyAnding
//
//  Created by 이지원 on 2022/10/22.
//

import Foundation

/*
// TODO: 테스트 모델, 추후 삭제 예정

struct Shortcut: Identifiable {
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

extension Shortcut {
    
    ///리스트를 구성하기 위해 임의의 배열값을 불러오고 싶을 경우
    ///해당 뷰에서 let shortcuts = Shortcut.fetchData(number: 10) 처럼 호출해서 사용해주세요
    static func fetchData(number: Int) -> [Shortcut] {
        
        var data = [Shortcut]()
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
                Shortcut(
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

class fetchShortcuts: ObservableObject {
    
    @Published var data = [Shortcut]()
    @Published var count = 1
    
    init() {
        updateData()
    }
    
    func updateData() {
        self.data += Shortcut.fetchData(number: 10)
    }
}

struct UserCuration: Identifiable {
    var id: UUID = UUID()
    var title: String
    var subtitle: String
    var shortcuts: [Shortcut]
}

extension UserCuration {
    
    ///리스트를 구성하기 위해 임의의 배열값을 불러오고 싶을 경우
    ///해당 뷰에서 let userCurations = UserCuration.fetchData(number: 10) 처럼 호출해서 사용해주세요
    static func fetchData(number: Int) -> [UserCuration] {
        
        var data = [UserCuration]()
        let title = [
            "워라벨 지키기. 단축어와 함께",
            "가나다라마바사아자차카타파하",
            "안녕하세요 이 단축어 한번 써볼래요?",
            "이걸 하고싶다면 여기를 주목!"
        ]
        let subtitle = [
            "워라벨을 알차게 지키고 있는 에디터도 애용하고 있는 단축어 모음.",
            "가나다라마바사아자차카타파하가나다라마바사아자차카타파하가나다라마바사아자차카타파하",
            "요즘 뜨는 트렌드 이런거 해보는건 어때요?",
            "이거 시도했는데 실패하셨다구요? 이걸로 다시 도전하면 성공 각~!"
        ]
        for _ in 0..<number {
            data.append(
                UserCuration(
                    title: title.randomElement() ?? "title",
                    subtitle: subtitle.randomElement() ?? "subtitle",
                    shortcuts: fetchShortcuts().data
                )
            )
        }
        return data
        
    }
}
*/

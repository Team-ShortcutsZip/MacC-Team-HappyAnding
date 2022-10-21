//
//  ListShortcutView.swift
//  HappyAnding
//
//  Created by 이지원 on 2022/10/20.
//

import SwiftUI

struct ListShortcutView: View {
    
    @ObservedObject var shortcutData = fetchData()
    
    let title: String
    
    var body: some View {
        
        List {
            
            header
                .listRowBackground(Color.Background)
                .listRowSeparator(.hidden)
                .listRowInsets(EdgeInsets())
            
            ForEach(0..<shortcutData.data.count, id: \.self) { index in
                ShortcutCell(color: self.shortcutData.data[index].color,
                             sfSymbol: self.shortcutData.data[index].sfSymbol,
                             name: self.shortcutData.data[index].name,
                             description: self.shortcutData.data[index].description,
                             numberOfDownload: self.shortcutData.data[index].numberOfDownload,
                             downloadLink: self.shortcutData.data[index].downloadLink)
                .listRowInsets(EdgeInsets())
                .listRowSeparator(.hidden)
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        if index == shortcutData.data.count - 1 && index < 99 {
                            self.shortcutData.updateData()
                        }
                    }
                }
                
            }
        }
        .listRowBackground(Color.Background)
        .listStyle(.plain)
        .background(Color.Background.ignoresSafeArea(.all, edges: .all))
        .scrollContentBackground(.hidden)
        .navigationBarTitle("다운로드 순위")
    }
    
    var header: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 12)
                .frame(height: 40)
                .padding(.horizontal, 16)
                .foregroundColor(.Gray1)
            
            Text(title)
                .Body2()
                .foregroundColor(.Gray5)
        }
    }
}

struct ListShortcutView_Previews: PreviewProvider {
    static var previews: some View {
        ListShortcutView(title: "1위 ~ 100위")
    }
}


// TODO: 테스트 모델, 추후 삭제 예정

struct ShortcutTestSoiModel {
    var name: String
    var description: String
    var sfSymbol: String
    var color: String
    var numberOfDownload: Int
    var downloadLink: String
}

extension ShortcutTestSoiModel {
    
    static func fetchData(number: Int) -> [ShortcutTestSoiModel] {
        
        var data = [ShortcutTestSoiModel]()
        let name = ["빠른길 찾기", "카카오톡 결제하기", "수면 모드로 설정", "공부하러 가야돼"]
        let description = ["이럴때 사용하면 더 좋아요", "이땐 이런건 어때요", "이것도 해보세요"]
        let sfSymbol = ["graduationcap.fill", "books.vertical.fill", "creditcard.fill",
                        "creditcard.fill", "phone.fill", "cross.fill", "newspaper.fill",
                        "newspaper.fill", "alarm.fill", "calendar", "cloud.sun.fill",
                        "camera.fill", "paintpalette.fill", "paintbrush.fill", "hammer.fill",
                        "tray.fill", "tray.fill", "speaker.wave.2.fill", "gearshape.fill",
                        "command.square.fill", "bubble.left.fill", "headphones",
                        "gamecontroller.fill", "tram.fill", "bag.fill", "music.note",
                        "hourglass.bottomhalf.filled"]
        
        let color = ["Blue", "Brown", "Coral", "Cyan", "Gray", "Green",
                     "Khaki", "LightPurple", "Mint", "Orange", "Pink",
                     "Purple", "Red", "Teal", "Yellow"]
        
        let downloadLink = ["https://www.icloud.com/shortcuts/fef3df84c4ae4bea8a411c8566efe280",
                            "https://www.icloud.com/shortcuts/54a5568f06ef44aabee61260298d088c",
                            "https://www.icloud.com/shortcuts/09721945787b44e3a7d41d14af3d99c9",
                            "https://www.icloud.com/shortcuts/22ba767a852a4d71a90e7e8d334a314a",
                            "https://www.icloud.com/shortcuts/56b0933241ab47b8ac6cb3a6b1e43c47",
                            "https://www.icloud.com/shortcuts/70581f62029b49048aec006eb8713ded"]
        
        for _ in 0..<number {
            data.append(ShortcutTestSoiModel(name: name.randomElement() ?? "name",
                                             description: description.randomElement() ?? "desc",
                                             sfSymbol: sfSymbol.randomElement() ?? "tram.fill",
                                             color: color.randomElement() ?? "Blue",
                                             numberOfDownload: Int.random(in: 0..<9999),
                                             downloadLink: downloadLink.randomElement() ?? "nil"))
        }
        
        return data
    }
}

class fetchData: ObservableObject {
    
    @Published var data = [ShortcutTestSoiModel]()
    @Published var count = 1
    
    init() {
        updateData()
    }
    
    func updateData() {
        self.data += ShortcutTestSoiModel.fetchData(number: 10)
    }
}

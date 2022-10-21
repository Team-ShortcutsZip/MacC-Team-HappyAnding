//
//  EShortcutModel.swift
//  HappyAnding
//
//  Created by 전지민 on 2022/10/21.
//

import Foundation

struct EShortcut {
    var name: String
    var subtitle: String
    var downloadsNum: Int
    var link: [String]
    var symbol: String
    var color: String
    
    let symbols = [
        "graduationcap.fill",
        "books.vertical.fill",
        "creditcard.fill",
        "printer.fill",
        "phone.fill",
        "cross.fill",
        "newspaper.fill",
        "bus.fill",
        "alarm.fill",
        "calendar",
        "cloud.sun.fill",
        "camera.fill",
        "paintpalette.fill",
        "paintbrush.fill",
        "hammer.fill",
        "tray.fill",
        "house.fill",
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
}

struct EUserCuration {
    var title: String
    var subtitle: String?
    var shortcuts: [EShortcut]
}

extension EShortcut {
    static var shortcuts = [
        EShortcut(
            name: "R⤓Download",
            subtitle: "",
            downloadsNum: 10,
            link: ["https://www.icloud.com/shortcuts/fef3df84c4ae4bea8a411c8566efe280"],
            symbol: "hourglass.bottomhalf.filled",
            color: "Red"
        )
    ]
}
extension EUserCuration {
    static var shortcuts = [
        EUserCuration(title: <#String#>, shortcuts: <#[EShortcut]#>),
    ]
}

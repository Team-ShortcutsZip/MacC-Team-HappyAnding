//
//  UserCurationCell.swift
//  HappyAnding
//
//  Created by 이지원 on 2022/10/20.
//

import SwiftUI

//MARK: - 테스트를 위한 모델 구현 (추후 삭제 필요)

struct EShortCurtaionModel {
    var title: String
    var subtitle: String
    var shortcuts: [EShortcutModel]
}
extension EShortCurtaionModel {
    static var userCurations = [
        EShortCurtaionModel(
            title: "워라벨 지키기. 단축어와 함께",
            subtitle: "워라벨을 알차게 지키고 있는 에디터도 애용하고 있는 단축어 모음.",
            shortcuts: EShortcutModel.shortcuts
        ),
        EShortCurtaionModel(
            title: "시간 지키기. 단축어와 함께",
            subtitle: "가나다라마바사아자차카타파하",
            shortcuts: EShortcutModel.shortcuts
        ),
        EShortCurtaionModel(
            title: "어쩌고 저쩌고. 단축어와 함께",
            subtitle: "가나다라마바사아자차카타파하가나다라마바사아자차카타파하가나다라마바사아자차카타파하",
            shortcuts: EShortcutModel.shortcuts
        )
    ]
}
struct EShortcutModel: Identifiable {
    var id: UUID = UUID()
    
    var color: String
    var symbol: String
}
extension EShortcutModel {
    #if DEBUG
    static var shortcuts = [
        EShortcutModel(color: "Red", symbol: "books.vertical.fill"),
        EShortcutModel(color: "Coral", symbol: "newspaper.fill"),
        EShortcutModel(color: "Orange", symbol: "bus.fill"),
        EShortcutModel(color: "Green", symbol: "alarm.fill"),
        EShortcutModel(color: "Mint", symbol: "cloud.sun.fill"),
        EShortcutModel(color: "Blue", symbol: "cloud.sun.fill"),
    ]
    #endif
}

//MARK: - UserCurationCell 구현 시작

struct UserCurationCell: View {
    //title, subtitle, [단축어모델]을 가지는 객체를 받아옴
    let title: String
    let subtitle: String?
    let shortcuts: [EShortcutModel]
    
    var body: some View {
        ZStack {
            NavigationLink(destination: ReadCurationView()) {
                EmptyView()
            }.opacity(0)
            VStack (alignment: .leading, spacing: 0) {
                
                //MARK: - 단축어 아이콘 배열
                
                HStack {
                    ForEach(shortcuts.indices, id: \.self) {index in
                        if index < 4 {
                            ZStack {
                                Rectangle()
                                    .fill(Color.fetchGradient(
                                        color: shortcuts[index].color)
                                    )
                                    .cornerRadius(8)
                                    .frame(width: 36, height: 36)
                                Image(systemName: shortcuts[index].symbol)
                                    .foregroundColor(Color.White)
                                    .Footnote()
                            }
                        }
                    }
                    
                    //단축어가 4개 이상인 경우에만 그리는 아이콘
                    if shortcuts.count > 4 {
                        ZStack(alignment: .center){
                            Rectangle()
                                .fill(Color.Gray2)
                                .cornerRadius(8)
                                .frame(width: 36, height: 36)
                            HStack(spacing: 0) {
                                Image(systemName: "plus")
                                Text("\(shortcuts.count-4)")
                            }
                            .foregroundColor(.Gray5)
                            .Subtitle()
                        }
                    }
                }
                .padding(.bottom, 12)
                .padding(.top, 52)
                
                //MARK: - curation title, subtitle
                
                Text(title)
                    .Headline()
                    .foregroundColor(Color.Gray5)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.bottom, subtitle == nil ? 20 : 0)
                if let subtitle{
                    Text(subtitle)
                        .Body2()
                        .foregroundColor(Color.Gray5)
                        .padding(.bottom, 20)
                }
            }
            .padding(.horizontal, 24)
            .background(Color.White)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.Gray1, lineWidth: 1)
            )
            .frame(maxWidth: .infinity)
            .cornerRadius(12)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 6)
    }
}

struct UserCurationCell_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            UserCurationCell(
                title: "워라벨 지키기. 단축어와 함께",
                subtitle: nil,
                shortcuts: EShortcutModel.shortcuts
            )
        }
    }
}

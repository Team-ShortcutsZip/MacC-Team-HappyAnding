//
//  ExploreShortcutView.swift
//  HappyAnding
//
//  Created by 이지원 on 2022/10/19.
//

import SwiftUI

struct ExploreShortcutView: View {
    
    @StateObject var viewModel: ExploreShortcutViewModel
    
    let sectionType: [ExploreShortcutSectionType] = [.new, .mostDownloaded, .mostLoved]
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            LazyVStack(spacing: 12, pinnedViews:[.sectionHeaders]) {
                Section {
                    PromoteSection(items: viewModel.fetchAdminCuration())
                    ForEach (sectionType, id: \.self) { type in
                        CardSection(type: type, shortcuts: viewModel.fetchShortcuts(by: type))
                    }
                } header: {
                    SearchBar()
                }
            }
            .padding(.bottom, 40)
        }
        .toolbar{
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    //TODO: 알림창 연결
                    print("알림창 연결")
                } label: {
                    Image(systemName: "bell.badge.fill")
                        .symbolRenderingMode(.palette)
                        .foregroundStyle(
                            Color(hexString: "3366FF"),
                            LinearGradient(
                                colors: [SCZColor.CharcoalGray.color, SCZColor.CharcoalGray.opacity48],
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                }
                
            }
            ToolbarItem(placement: .topBarLeading) {
                Text("둘러보기")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundStyle(
                        LinearGradient(colors: [SCZColor.CharcoalGray.color, SCZColor.CharcoalGray.opacity48], startPoint: .top, endPoint: .bottom)
                    )
            }
        }
        
    }
}

//TODO: 배경색상 적용 필요
struct SearchBar: View {
    @State var text: String = ""
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
            TextField("단축어 제작의 기본", text: $text)
                .frame(maxHeight: .infinity)
        }
        .padding(.horizontal, 16)
        .frame(height: 40)
        .background(
            Capsule()
                .fill(SCZColor.CharcoalGray.opacity04)
                .overlay(
                    Capsule()
                        .stroke(Color.white.opacity(0.12), lineWidth: 2)
                )
        )
        .padding(.horizontal, 16)
    }
}


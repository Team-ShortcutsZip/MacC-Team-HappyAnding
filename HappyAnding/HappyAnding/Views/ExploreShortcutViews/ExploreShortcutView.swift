//
//  ExploreShortcutView.swift
//  HappyAnding
//
//  Created by 이지원 on 2022/10/19.
//

import SwiftUI

struct ExploreShortcutView: View {
    
    @StateObject var viewModel: ExploreShortcutViewModel
    @Binding var isSearchActivated: Bool
    
    let sectionType: [SectionType] = [.recent, .download, .popular]
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: 12) {
                PromoteSection(items: viewModel.fetchAdminCuration())
                    .padding(.top, 12)
                ForEach (sectionType, id: \.self) { type in
                    CardSection(type: type, shortcuts: viewModel.fetchShortcuts(by: type))
                }
                
            }
            .padding(.bottom, 96)
        }
        .toolbar{
            ToolbarItem(placement: .topBarTrailing) {
                HStack {
                    Button {
                        //TODO: 알림창 연결
                        withAnimation {
                            isSearchActivated.toggle()
                        }
                    } label: {
                        Image(systemName: "sparkle.magnifyingglass")
                            .symbolRenderingMode(.palette)
                            .foregroundStyle(
                                LinearGradient(
                                    colors: [SCZColor.CharcoalGray.opacity88, SCZColor.CharcoalGray.opacity48],
                                    startPoint: .top,
                                    endPoint: .bottom
                                )
                                .opacity(0.64)
                            )
                    }
                    Button {
                        //TODO: 알림창 연결
                        print("알림창 연결")
                    } label: {
                        Image(systemName: "bell.badge.fill")
                            .symbolRenderingMode(.palette)
                            .foregroundStyle(
                                SCZColor.SCZBlue.strong,
                                LinearGradient(
                                    colors: [SCZColor.CharcoalGray.opacity88, SCZColor.CharcoalGray.opacity48],
                                    startPoint: .top,
                                    endPoint: .bottom
                                )
                                .opacity(0.64)
                            )
                    }
                }
                
                
            }
            ToolbarItem(placement: .topBarLeading) {
                Text(TextLiteral.exploreShortcutViewTitle)
                    .font(.system(size: 24, weight: .bold))
                    .foregroundStyle(
                        LinearGradient(colors: [SCZColor.CharcoalGray.color, SCZColor.CharcoalGray.opacity48], startPoint: .top, endPoint: .bottom)
                            .opacity(0.64)
                    )
            }
        }
        .navigationBarBackground({Color.clear})
        .background(
            ZStack{
                Color.white
                SCZColor.CharcoalGray.opacity04
            }
                .ignoresSafeArea()
        )
    }
}

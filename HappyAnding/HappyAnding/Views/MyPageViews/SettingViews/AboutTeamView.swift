//
//  AboutTeamView.swift
//  HappyAnding
//
//  Created by HanGyeongjun on 2022/11/07.
//

import SwiftUI

struct AboutTeamView: View {
    var body: some View {
        ScrollView {
            
            VStack {
                Text("Team Happy ANDing")
                    .shortcutsZipTitle1()
                    .foregroundStyle(Color.gray5)
                    .multilineTextAlignment(.leading)
                    .padding(.horizontal, 16)
                Text("안녕하세요. ShortcutsZip의 개발팀 Team Happy ANDing입니다. ")
                    .shortcutsZipBody2()
                    .foregroundStyle(Color.gray3)
                    .multilineTextAlignment(.leading)
                    .padding(.bottom, 16)
            }
            .padding(.horizontal, 16)
            
            HStack(spacing: 12) {
                devCard
                devCard
            }
            .padding(.horizontal, 16)
            .padding(.top, 12)
        }
        .frame(maxWidth: .infinity, maxHeight: . infinity)
        .background(Color.shortcutsZipBackground)
        .scrollIndicators(.hidden)
        .navigationTitle("개발팀에 관하여")
    }
    
    var devCard: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.gray2)
                .frame(height: 200)
                .contextMenu{
                    Button {
                        // Add this item to a list of favorites.
                    } label: {
                        Label("개발자 Github 둘러보기", systemImage: "person.fill")
                    }
                }
        }
    }
}

struct AboutTeamView_Previews: PreviewProvider {
    static var previews: some View {
        AboutTeamView()
    }
}

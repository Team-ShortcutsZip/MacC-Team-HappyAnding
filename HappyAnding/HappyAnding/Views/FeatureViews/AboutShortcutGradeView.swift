//
//  AboutShortcutGradeView.swift
//  HappyAnding
//
//  Created by HanGyeongjun on 2023/03/02.
//

import SwiftUI

struct AboutShortcutGradeView: View {
    
    @EnvironmentObject var shortcutsZipViewModel: ShortcutsZipViewModel
    
    @State private var animationAmount = 0.0
    
    let shortcutGrade: [ShortcutGrade] = [.level0, .level1, .level2, .level3, .level4, .level5]
    
    private let hapticManager = HapticManager.instance
    
    var body: some View {
        ScrollView {
            VStack(alignment: .center, spacing: 32) {
                if shortcutsZipViewModel.userInfo != nil {
                    MyGrade
                }
                ExplainGrade
            }
            .padding(.top, 16)
            .padding(.bottom, 44)
        }
        .padding(.top, 16)
        .background(Color.shortcutsZipBackground)
        .scrollIndicators(.hidden)
        .onAppear {
            withAnimation(.interpolatingSpring(stiffness: 10, damping: 3)) {
                self.animationAmount += 360
            }
        }
    }
    
    //유저 현재 등급 표시 섹션
    var MyGrade: some View {
        VStack(alignment: .center, spacing: 12) {
            
            Text((shortcutsZipViewModel.userInfo?.nickname ?? TextLiteral.defaultUser) + TextLiteral.shortcutGradeCurrentLevel)
                .shortcutsZipBody1()
                .fontWeight(.bold)
                .foregroundStyle(Color.gray5)
                .frame(width: UIScreen.screenWidth - 32)
            
            Button {
                hapticManager.impact(style: .rigid)
                withAnimation(.interpolatingSpring(stiffness: 10, damping: 3)) {
                    self.animationAmount += 360
                }
            } label: {
                if shortcutsZipViewModel.checkShortcutGrade(userID: shortcutsZipViewModel.userInfo?.id).rawValue == 0 {
                    Image(systemName: "person.crop.circle.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .fontWeight(.medium)
                        .foregroundStyle(Color.gray5)
                        .frame(width: 120, height: 120)
                        .rotation3DEffect(
                            .degrees(animationAmount), axis: (x: 0.0, y: 1.0, z: 0.0))
                } else {
                    shortcutsZipViewModel.fetchShortcutGradeSuperImage(shortcutGrade: shortcutsZipViewModel.checkShortcutGrade(userID: shortcutsZipViewModel.userInfo?.id))
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 120, height: 120)
                        .rotation3DEffect(
                            .degrees(animationAmount), axis: (x: 0.0, y: 1.0, z: 0.0))
                }
            }
            .padding(.all, 20)
            
            Text("\(shortcutsZipViewModel.checkShortcutGrade(userID: shortcutsZipViewModel.userInfo?.id).fetchTitle())")
                .shortcutsZipTitle1()
                .foregroundStyle(Color.tagText)
                .padding(.horizontal, 16)
                .padding(.vertical, 4)
                .background(
                    Capsule()
                        .fill( Color.tagBackground )
                        .overlay(
                            Capsule()
                                .strokeBorder(Color.shortcutsZipPrimary, lineWidth: 1))
                )
            
            Text(shortcutsZipViewModel.checkShortcutGrade(userID: shortcutsZipViewModel.userInfo?.id).rawValue == 5 ?
                 TextLiteral.shortcutGradeHighestLevel :
                    TextLiteral.shortcutGradeNumberOfShortcutsToNextLevelStart + "\(shortcutsZipViewModel.countShortcutsToNextGrade(numberOfShortcuts: shortcutsZipViewModel.shortcutsMadeByUser.count))" + TextLiteral.shortcutGradeNumberOfShortcutsToNextLevelEnd)
                .shortcutsZipBody2()
                .foregroundStyle(Color.gray5)
                .frame(width: UIScreen.screenWidth - 32)
                .padding(.top, 8)
        }
        .padding(.vertical, 20)
        .background {
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.gray1)
        }
        .padding(.horizontal, 16)
    }
    
    //단축어 작성 등급 안내 섹션
    var ExplainGrade: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(TextLiteral.shortcutGradeAnnouncementSectionTitle)
                .shortcutsZipTitle2()
                .foregroundStyle(Color.gray5)
            
            ForEach(shortcutGrade.filter{ $0 != .level0 }, id: \.self) { grade in
                ExplainGradeCell(gradeIcon: grade.fetchIcon(),
                                 gradeName: grade.fetchTitle(),
                                 gradeDescription: grade.fetchDescription())
            }
            
            Text(TextLiteral.shortcutGradeMaybeDownGrade)
                .shortcutsZipFootnote()
                .foregroundStyle(Color.gray3)
                .padding(.top, 8)
        }
        .padding(.horizontal, 16)
    }
}

struct ExplainGradeCell: View {
    
    var gradeIcon: String
    var gradeName: String
    var gradeDescription: String
    
    var body: some View {
        HStack(spacing: 16) {
            ZStack(alignment: .center) {
                Circle()
                    .fill(Color.gray1)
                    .frame(width: 72, height: 72)
                Image(gradeIcon)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(gradeName)
                    .shortcutsZipBody1()
                    .fontWeight(.bold)
                    .foregroundStyle(Color.gray5)
                Text(gradeDescription)
                    .shortcutsZipBody2()
                    .foregroundStyle(Color.gray5)
            }
            Spacer()
        }
    }
}

//
//  ShortcutCell.swift
//  HappyAnding
//
//  Created by 이지원 on 2022/10/20.
//

import SwiftUI

/**
 단축어를 재사용하기 위한 뷰입니다. (추후 단축어 모델이 생기면 변경될 예정입니다)
 
 단축어 정보를 전달해주세요. 클릭시 단축어 상세 뷰로 이동합니다.
 
 - parameters:
 - shortcut : 단축어 리스트에서 접근 시 Shortcuts  형태로 전달해주세요
 - shortcutCell: 큐레이션에서 접근 시 ShortcutCellModel 형태로 전달해주세요
 
 ShortcutCell에서는 Shortcuts의 형태로 데이터를 전달받아도 ShortcutCellModel의 형태로 변환하여 사용합니다.
 
 - description:
 - 해당 뷰를 리스트로 사용할 때 다음과 같은 속성을 작성해주세요
 
 ```
 .listRowInsets(EdgeInsets())
 .listRowSeparator(.hidden)
 ```
 - list의 경우, plain으로 설정해주세요
 */


struct ShortcutCell: View {
    
    @Environment(\.loginAlertKey) var loginAlerter
    @Environment(\.openURL) private var openURL
    @EnvironmentObject var shortcutsZipViewModel: ShortcutsZipViewModel
    
    @AppStorage("useWithoutSignIn") var useWithoutSignIn: Bool = false
    
    @State var shortcutCell = ShortcutCellModel(
        id: "",
        sfSymbol: "",
        color: "",
        title: "",
        subtitle: "",
        downloadLink: ""
    )
    
    var shortcut: Shortcuts?
    var rankNumber: Int = -1
    var sectionType: SectionType?
    let navigationParentView: NavigationParentView
    
    var body: some View {
        
        ZStack {
            HStack {
                icon
                shortcutInfo
                Spacer()
                downloadInfo
                    .onTapGesture {
                        if !useWithoutSignIn {
                            if let url = URL(string: shortcutCell.downloadLink) {
                                openURL(url)
                                if let shortcut = shortcutsZipViewModel.fetchShortcutDetail(id: shortcutCell.id) {
                                    shortcutsZipViewModel.updateNumberOfDownload(shortcut: shortcut, downloadlinkIndex: 0)
                                }
                            }
                        } else {
                            loginAlerter.isPresented = true
                        }
                    }
            }
            .padding(.vertical, 20)
            .background( background )
            .padding(.horizontal, 20)
        }
        .padding(.bottom, 12)
        .background(Color.shortcutsZipBackground)
        .onAppear() {
            if let shortcut  {
                self.shortcutCell = ShortcutCellModel(
                    id: shortcut.id,
                    sfSymbol: shortcut.sfSymbol,
                    color: shortcut.color,
                    title: shortcut.title,
                    subtitle: shortcut.subtitle,
                    downloadLink: shortcut.downloadLink.last!
                )
            }
        }
    }
    
    var icon: some View {
        
        ZStack(alignment: .center) {
            Rectangle()
                .fill(Color.fetchGradient(color: shortcutCell.color))
                .cornerRadius(8)
                .frame(width: 52, height: 52)
            
            Image(systemName: shortcutCell.sfSymbol)
                .mediumShortcutIcon()
                .foregroundStyle(Color.textIcon)
        }
        .padding(.leading, 20)
    }
    
    var shortcutInfo: some View {
        
        VStack(alignment: .leading, spacing: 0) {
            if rankNumber != -1 {
                Text("\(rankNumber)")
                    .shortcutsZipSubtitle()
                    .foregroundStyle(Color.gray4)
                    .padding(0)
            }
            Text(shortcutCell.title)
                .shortcutsZipHeadline()
                .foregroundStyle(Color.gray5)
                .lineLimit(1)
            Text(shortcutCell.subtitle.lineBreaking)
                .shortcutsZipFootnote()
                .foregroundStyle(Color.gray3)
                .multilineTextAlignment(.leading)
                .lineLimit(2)
        }
        .padding(.horizontal, 12)
    }
    
    var downloadInfo: some View {
        
        VStack(alignment: .center, spacing: 0) {
            if sectionType == SectionType.myDownloadShortcut {
                if let index = shortcutsZipViewModel.userInfo?.downloadedShortcuts.firstIndex(where: { $0.id == shortcut?.id}) {
                    if shortcutsZipViewModel.userInfo?.downloadedShortcuts[index].downloadLink != shortcut?.downloadLink[0] {
                        Image(systemName: "clock.arrow.circlepath")
                            .setCellIcon()
                    }
                    else {
                        Image(systemName: "arrow.down.app.fill")
                            .setCellIcon()
                    }
                }
            } else {
                Image(systemName: "arrow.down.app.fill")
                    .setCellIcon()
            }
        }
        .padding(.leading, 12)
        .padding(.trailing, 18)
    }
    
    var background: some View {
        
        RoundedRectangle(cornerRadius: 12)
            .fill(Color.backgroudList)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .strokeBorder(Color.backgroudListBorder)
            )
    }
}


struct ShortcutCell_Previews: PreviewProvider {
    static var previews: some View {
        ShortcutCell(navigationParentView: .curations)
    }
}

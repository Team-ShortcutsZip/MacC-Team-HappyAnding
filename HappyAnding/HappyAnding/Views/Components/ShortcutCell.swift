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
 - color: 아이콘 색상
 - sfSymbol: 아이콘 이미지
 - name: 단축어 게시글 이름
 - description: 한 줄 설명
 - numberOfDownload: 다운로드 수
 - downloadLink: 다운로드 링크
 
 - description:
 - 해당 뷰를 리스트로 사용할 때 다음과 같은 속성을 작성해주세요
 
 ```
 .listRowInsets(EdgeInsets())
 .listRowSeparator(.hidden)
 ```
 - list의 경우, plain으로 설정해주세요
 */


struct ShortcutCell: View {
    
    @Environment(\.openURL) private var openURL
    
    // TODO: 단축어 구조체 모델 생성 후 객체로 변경하기
    // TODO: Color, Font extension 등록 후 색상 변경하기
    let shortcut: Shortcuts
    
    var rankNumber: Int = -1
    
//    let color: String
//    let sfSymbol: String
//    let name: String
//    let description: String
//    let numberOfDownload: Int
//    let downloadLink: String
    
    var body: some View {
        
        ZStack {
            NavigationLink(destination: ReadShortcutView(shortcut: shortcut)) {
                EmptyView()
            }
            .opacity(0)
            
            Color.Background
            
            HStack {
                icon
                shortcutInfo
                Spacer()
                downloadInfo
                    .onTapGesture {
                        
                        // TODO: 앱 여는 기능 추가
                        if let url = URL(string: shortcut.downloadLink[0]) {
                            openURL(url)
                        }
                    }
            }
            .padding(.vertical, 20)
            .background( background )
            .padding(.horizontal, 20)
        }
        .padding(.top, 12)
        .background(Color.Background)
    }
    
    var icon: some View {
        
        ZStack(alignment: .center) {
            Rectangle()
                .fill(Color.fetchGradient(color: shortcut.color))
                .cornerRadius(8)
                .frame(width: 52, height: 52)
            
            Image(systemName: shortcut.sfSymbol)
                .foregroundColor(.white)
        }
        .padding(.leading, 20)
    }
    
    var shortcutInfo: some View {
        
        VStack(alignment: .leading, spacing: 4) {
            if rankNumber != -1 {
                Text("\(rankNumber)")
                    .Subtitle()
                    .foregroundColor(.Gray4)
                    .padding(0)
            }
            Text(shortcut.title)
                .Headline()
                .foregroundColor(.Gray5)
                .lineLimit(1)
            Text(shortcut.subtitle)
                .Footnote()
                .foregroundColor(.Gray3)
                .lineLimit(2)
        }
        .padding(.horizontal, 12)
    }
    
    var downloadInfo: some View {
        
        VStack(alignment: shortcut.numberOfDownload > 999 ? .trailing : .center, spacing: 0) {
            Image(systemName: "arrow.down.app.fill")
                .foregroundColor(.Gray4)
                .font(.system(size: 24, weight: .medium))
                .frame(height: 32)
        }
        .padding(.leading, 12)
        .padding(.trailing, 18)
    }
    
    var background: some View {
        
        RoundedRectangle(cornerRadius: 12)
            .fill(Color.White)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.Gray1)
            )
    }
}


//struct ShortcutCell_Previews: PreviewProvider {
//    static var previews: some View {
//        ShortcutCell(color: "Red", sfSymbol: "books.vertical.fill", name: "Name", description: "Description", numberOfDownload: 102, downloadLink: "https")
//    }
//}

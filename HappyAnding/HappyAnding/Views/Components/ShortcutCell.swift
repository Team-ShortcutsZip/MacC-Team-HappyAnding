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
 */


struct ShortcutCell: View {
    
    
    // TODO: 단축어 구조체 모델 생성 후 객체로 변경하기
    // TODO: Color, Font extension 등록 후 색상 변경하기
    
    let color: String
    let sfSymbol: String
    let name: String
    let description: String
    let numberOfDownload: Int
    let downloadLink: String
    
    var body: some View {
        
        ZStack {
            NavigationLink(destination: ReadShortcutView()) {
                EmptyView()
            }
            .opacity(0)
            HStack {
                icon
                shortcutInfo
                Spacer()
                downloadInfo
            }
            .padding(.vertical, 20)
            .padding(.horizontal, 36)
            .background(
                background
            )
            .buttonStyle(PlainButtonStyle())
        }
    }
    
    var icon: some View {
        
        ZStack(alignment: .center) {
            Rectangle()
                .fill(Color.blue)
                .cornerRadius(8)
                .frame(width: 50, height: 50)
            
            Image(systemName: sfSymbol)
                .foregroundColor(.white)
        }
    }
    
    var shortcutInfo: some View {
        
        VStack(alignment: .leading, spacing: 4) {
            Text(name)
                .foregroundColor(.black)
            Text(description)
                .foregroundColor(.gray)
        }
        .padding(.horizontal, 12)
    }
    
    var downloadInfo: some View {
        
        VStack(spacing: 0) {
            Image(systemName: "arrow.down.app.fill")
                .foregroundColor(.gray)
                .font(.system(size: 24, weight: .medium))
                .frame(height: 32)
            
            Text(String(numberOfDownload))
                .foregroundColor(.gray)
                .font(.system(size: 13, weight: .regular))
        }
    }
    
    var background: some View {
        
        RoundedRectangle(cornerRadius: 12)
            .fill(.white)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.gray)
            )
            .padding(.horizontal, 16)
    }
}


struct ShortcutCell_Previews: PreviewProvider {
    static var previews: some View {
        ShortcutCell(color: "green", sfSymbol: "books.vertical.fill", name: "Name", description: "Description", numberOfDownload: 102, downloadLink: "https")
    }
}

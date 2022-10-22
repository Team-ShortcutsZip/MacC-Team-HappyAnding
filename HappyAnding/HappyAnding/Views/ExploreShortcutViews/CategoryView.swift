//
//  CategoryView.swift
//  HappyAnding
//
//  Created by KiWoong Hong on 2022/10/22.
//

import SwiftUI

// TODO: 나중에 지울 예정인 임시 카테고리 enum

enum Category: String, CaseIterable {
    case education = "교육"
    case fitness = "건강 및 피트니스"
    case money = "금융"
    case life = "라이프스타일"
    case weather = "날씨"
    case picture = "사진 및 비디오"
    case decoration = "데코레이션/꾸미기"
    case utility = "유틸리티"
    case social = "소셜 네트워킹"
    case enterta = "엔터테인먼트"
    case travel = "여행"
    case bussness = "비즈니스"
}

struct CategoryView: View {
    var body: some View {
        VStack {
            HStack {
                Text("카테고리 모아보기")
                    .Title2()
                    .foregroundColor(Color.Gray5)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Spacer()
                
                Text("더보기")
                    .Footnote()
                    .foregroundColor(Color.Gray4)
                    .padding(.trailing, 16)
            }
            .padding(.leading, 16)
            
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())]) {
                ForEach(Array(Category.allCases.enumerated()), id: \.offset) { index, value in
                    if index < 6 {
                        CategoryCellView(categoryName: value.rawValue)
                    }
                }
            }
            .padding(.horizontal, 16)
        }
    }
}

struct CategoryCellView: View {
    
    let categoryName: String
    
    var body: some View {
        RoundedRectangle(cornerSize: CGSize(width: 12, height: 12))
                .stroke(Color.Gray1, lineWidth: 1)
                .frame(width: .infinity, height: 48)
                .overlay {
                    Text(categoryName)
                        .Body2()
                        .foregroundColor(Color.Gray5)
                }
    }
}

struct CategoryView_Previews: PreviewProvider {
    static var previews: some View {
        CategoryView()
    }
}

//
//  CategoryView.swift
//  HappyAnding
//
//  Created by KiWoong Hong on 2022/10/22.
//

import SwiftUI

struct CategoryView: View {
    let shortcuts: [Shortcuts]?
    var body: some View {
        VStack {
            HStack {
                Text("카테고리 모아보기")
                    .Title2()
                    .foregroundColor(Color.Gray5)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Spacer()
                
                NavigationLink(destination: ListCategoryView()) {
                    Text("더보기")
                        .Footnote()
                        .foregroundColor(Color.Gray4)
                        .padding(.trailing, 16)
                }
            }
            .padding(.leading, 16)
            
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())]) {
                ForEach(Array(Category.allCases.enumerated()), id: \.offset) { index, value in
                    if index < 6 {
                        NavigationLink(destination: {
                            ExploreCategoryView(category: value, shortcuts: shortcuts)
                                .navigationBarTitleDisplayMode(NavigationBarItem.TitleDisplayMode.inline)
                        }, label: {
                            CategoryCellView(categoryName: translateName(value.rawValue))
                        })
                    }
                }
            }
            .padding(.horizontal, 16)
        }
    }
    
    
    private func translateName(_ categoryName: String) -> String {
        switch categoryName {
        case "education":
            return "교육"
        case "finance":
            return "금융"
        case "business":
            return "비즈니스"
        case "health":
            return "건강 및 피트니스"
        case "lifestyle":
            return "라이프스타일"
        case "weather":
            return "날씨"
        case "photo":
            return "사진 및 비디오"
        case "decoration":
            return "데코레이션/꾸미기"
        case "utility":
            return "유틸리티"
        case "sns":
            return "소셜 네트워킹"
        case "entertainment":
            return "엔터테인먼트"
        case "trip":
            return "여행"
        default:
            return ""
        }
    }
}

struct CategoryCellView: View {
    
    let categoryName: String
    
    var body: some View {
        RoundedRectangle(cornerSize: CGSize(width: 12, height: 12))
            .stroke(Color.Gray1, lineWidth: 1)
            .background(Color.White)
            .cornerRadius(12)
            .frame(maxWidth: .infinity, minHeight:48, maxHeight: 48)
            .overlay {
                Text(categoryName)
                    .Body2()
                    .foregroundColor(Color.Gray5)
            }
    }
}

//struct CategoryView_Previews: PreviewProvider {
//    static var previews: some View {
//        CategoryView()
//    }
//}

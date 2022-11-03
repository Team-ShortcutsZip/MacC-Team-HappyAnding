//
//  ListCategoryView.swift
//  HappyAnding
//
//  Created by 이지원 on 2022/10/25.
//

import SwiftUI

struct ListCategoryView: View {
    
    var shortcuts: [Shortcuts]?
    private let gridLayout = [GridItem(.flexible()), GridItem(.flexible())]
    
    var body: some View {
        
        ZStack(alignment: .top) {
            Color.Background
                .ignoresSafeArea()
            
            VStack {
                LazyVGrid(columns: gridLayout, spacing: 0) {
                    ForEach(Category.allCases, id: \.self) { item in
                        
                        NavigationLink(destination: ExploreCategoryView(category: item, shortcuts: shortcuts)) {
                            
                            
                            RoundedRectangle(cornerSize: CGSize(width: 12, height: 12))
                                .stroke(Color.Gray1, lineWidth: 1)
                                .background(Color.White)
                                .cornerRadius(12)
                                .frame(maxWidth: .infinity, minHeight:48, maxHeight: 48)
                                .overlay {
                                    Text(translateName(item.rawValue))
                                        .Body2()
                                        .foregroundColor(Color.Gray5)
                                }
                                .padding(.horizontal, 6)
                                .padding(.vertical, 7)
                        }
                    }
                }
                .padding(.horizontal, 16)
                .padding(.top, 32)
                Spacer().frame(maxWidth: .infinity)
            }
        }
        .frame(maxHeight: .infinity)
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle("카테고리")
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
            return "건강"
        case "lifestyle":
            return "라이프스타일"
        case "weather":
            return "날씨"
        case "photo":
            return "사진 및 비디오"
        case "decoration":
            return "데코레이션 / 꾸미기"
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


struct ListCategoryView_Previews: PreviewProvider {
    static var previews: some View {
        ListCategoryView()
    }
}

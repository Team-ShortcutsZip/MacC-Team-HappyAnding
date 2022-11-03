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
                LazyVGrid(columns: gridLayout) {
                    ForEach(Category.allCases, id: \.self) { item in
                        NavigationLink(destination:
                            ListShortcutView(shortcuts: shortcuts, categoryName: item)
                        ) {
                            Text(translateName(item.rawValue))
                                .Body2()
                                .tag(item)
                                .foregroundColor(Color.Gray3)
                                .frame(maxWidth: UIScreen.main.bounds.size.width * 0.5,
                                       minHeight: 48)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(Color.Gray3, lineWidth: 1)
                                )
                        }
                        .padding(8)
                    }
                }
                .padding(.horizontal, 8)
                .padding(.top, 24)
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

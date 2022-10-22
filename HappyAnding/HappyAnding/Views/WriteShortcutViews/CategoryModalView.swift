//
//  CategoryModalView.swift
//  HappyAnding
//
//  Created by 이지원 on 2022/10/19.
//

import SwiftUI

enum Category: String, CaseIterable {
    case education = "교육"
    case health = "건강 및 피트니스"
    case finance = "금융"
    case lifestyle = "라이프스타일"
    case weather = "날씨"
    case photo = "사진 및 비디오"
    case decoration = "데코레이션/꾸미기"
    case utility = "유틸리티"
    case sns = "소셜 네트워킹"
    case entertainment = "엔터테인먼트"
    case trip = "여행"
    case business = "비즈니스"
    
    var category: String {
        String(describing: self)
    }
}

struct CategoryModalView: View {
    private let gridLayout = [GridItem(.flexible()), GridItem(.flexible())]
    @State var selectedCategories = [String]()
    
    var body: some View {
        VStack {
            Text("카테고리")
                .font(.headline)
            
            LazyVGrid(columns: gridLayout, spacing: 12) {
                ForEach(Category.allCases, id: \.self) { item in
                    Button(item.rawValue, action: {
                        
                        // TODO: 버튼색 변경 및 데이터 저장
                        
                        self.selectedCategories.append(item.category)
                    }).buttonStyle(categoryButtonStyle())
                }
            }
            .padding(.horizontal, 16)
            
            Button(action: {
                
                // TODO: 모달 닫기 및 데이터 전달
                
            }) {
                Text("완료")
                    .Body1()
                    .frame(maxWidth: .infinity, minHeight: 52)
            }
            .buttonStyle(.borderedProminent)
            .disabled(selectedCategories.isEmpty)
            .padding(.horizontal, 16)
            
        }
    }
    
    struct categoryButtonStyle: ButtonStyle {
        func makeBody(configuration: Configuration) -> some View {
            configuration.label
                .Body2()
                .frame(maxWidth: .infinity, minHeight: 48)
                .foregroundColor(.Gray3)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.Gray3, lineWidth: 1)
                )
            
        }
    }
}

struct CategoryModalView_Previews: PreviewProvider {
    static var previews: some View {
        CategoryModalView()
    }
}

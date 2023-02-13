//
//  StickyHeader.swift
//  HappyAnding
//
//  Created by 전지민 on 2023/01/25.
//

import SwiftUI

/**
 어드민 큐레이션 썸네일입니다.
 
 #parameters
 - height: 배경의 높이 값
 - image: 이미지 파일명
 
 #description
 - sticky header가 필요한 곳에서 사용할 수 있습니다.
 - 이미지가 적용되어야 할 경우에만 이미지 파일명을 넣어주시면 됩니다.
 */

struct StickyHeader: View {
    
    var height: CGFloat
    var image: String?
    
    var body: some View {
        GeometryReader { geo in
            let yOffset = geo.frame(in: .global).minY
            
            if let image = image {
                Image(image)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: geo.size.width, height: height + (yOffset > 0 ? yOffset : 0))
                    .clipped()
                    .offset(y: yOffset > 0 ? -yOffset : 0)
            } else {
                Color.shortcutsZipWhite
                    .frame(width: geo.size.width, height: height + (yOffset > 0 ? yOffset : 0))
                    .offset(y: yOffset > 0 ? -yOffset : 0)
            }
        }
        .frame(minHeight: height)
    }
}

//
//  UpdateInfoView.swift
//  HappyAnding
//
//  Created by HanGyeongjun on 2023/05/29.
//

import SwiftUI

struct UpdateInfoView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 52) {
                
                header()
                
                //TODO: Model 만들어서 Foreach로 돌리기. 다음 업데이트
                aboutFeatureCell(type: "기능 업데이트",
                                 title: "더욱 쉬워진 단축어 작성 과정",
                                 image: "easierShortcutWrite",
                                 description: "이제는 단축어 작성 과정에서 제목을 직접 입력하지 않아도 괜찮아요. 단축어 링크만 붙여넣으면 ShortcutsZip이 자동으로 제목을 채워준답니다. 이 기능은 단축어 앱의 공유 시트에서 바로 작성할 때도 만나볼 수 있어요.")
                
                aboutFeatureCell(type: "기능 업데이트",
                                 title: "간편하게 외부 링크 살펴보기",
                                 image: "easierExternalURL",
                                 description: "다른 유저에게 단축어에 대해 더 자세한 정보를 알려 주고 싶을 때가 있지 않나요? 단축어 설명이나 댓글에 URL을 입력하면 ShortcutsZip이 자동으로 인식해 해당 웹사이트로 바로 이동할 수 있는 링크를 제공해요.")
                
                aboutFeatureCell(type: "기능 업데이트",
                                 title: "단축어와 댓글 작성 날짜 확인",
                                 image: nil,
                                 description: "이제 단축어를 업데이트하지 않아도 언제 업로드 된 단축어인지 알 수 있어요. 댓글에도 날짜가 표시되어서 내 단축어에 달린 최근 댓글에 빠르게 피드백 할 수 있답니다.")
                
                footer()
                
            }
            .padding(.bottom, 44)
        }
        .edgesIgnoringSafeArea(.top)
        .navigationBarTitleDisplayMode(.inline)
        .background(Color.shortcutsZipBackground)
    }
    
    //MARK: - Header
    @ViewBuilder
    private func header() -> some View {
        VStack(alignment: .leading, spacing: 20) {
            StickyHeader(height: 280, image: "HeaderImage")
            VStack(alignment: .leading, spacing: 8) {
                Text(TextLiteral.updateInfoViewTitle)
                    .shortcutsZipTitle1()
                    .foregroundStyle(Color.gray6)
                Text(TextLiteral.updateInfoViewVersion)
                    .shortcutsZipBody1()
                    .foregroundStyle(Color.gray4)
            }
            .padding(.horizontal, 20)
        }
    }
    
    //MARK: - Feature
    @ViewBuilder
    private func aboutFeatureCell(type: String, title: String, image: String?,
                                  description: String) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(type)
                .shortcutsZipFootnote()
                .fontWeight(.bold)
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .foregroundStyle(Color.tagText)
                .background(Color.tagBackground)
                .clipShape(Capsule())
                .overlay(
                    Capsule()
                        .strokeBorder(Color.shortcutsZipPrimary)
                )
            Text(title.lineBreaking)
                .shortcutsZipTitle2()
                .foregroundStyle(Color.gray6)
            if let image {
                Image(image)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .cornerRadius(16)
                    .onLongPressGesture {
                        copyImageToClipboard(imageName: image)
                    }
            }
            Text(description.lineBreaking)
                .shortcutsZipBody2()
                .foregroundStyle(Color.gray5)
                .multilineTextAlignment(.leading)
        }
        .padding(.horizontal, 20)
    }
    
    //MARK: - Footer
    @ViewBuilder
    private func footer() -> some View {
        VStack(alignment: .center, spacing: 20) {
            Text(TextLiteral.updateInfoViewFooterTitle)
                .shortcutsZipTitle2()
                .foregroundStyle(Color.gray6)
                .multilineTextAlignment(.center)
            Button {
                //TODO: ShortcutsZipFormView 띄우는 로직 추가
            } label: {
                Text(TextLiteral.updateInfoViewComment)
                    .shortcutsZipBody1()
                    .fontWeight(.semibold)
                    .padding(.horizontal, 24)
                    .padding(.vertical, 12)
                    .foregroundStyle(Color.textButton)
                    .background(Color.shortcutsZipPrimary)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
            }
        }
        .frame(maxWidth: .infinity)
    }
    
    private func copyImageToClipboard(imageName: String) {
        if let image = UIImage(named: imageName) {
            UIPasteboard.general.image = image
        }
    }

}

struct UpdateInfoView_Previews: PreviewProvider {
    static var previews: some View {
        UpdateInfoView()
    }
}

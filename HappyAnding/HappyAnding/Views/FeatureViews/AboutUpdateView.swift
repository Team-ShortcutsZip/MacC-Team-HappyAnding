//
//  AboutUpdateView.swift
//  HappyAnding
//
//  Created by HanGyeongjun on 2023/05/29.
//

import SwiftUI

struct AboutUpdateView: View {
    @Environment(\.loginAlertKey) var loginAlerter
    
    @AppStorage("useWithoutSignIn") var useWithoutSignIn: Bool = false
    
    @State var isShowFormView = false
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 52) {
                
                header()
                
                //TODO: Model 만들어서 Foreach로 돌리기. 다음 업데이트
                aboutFeatureCell(type: TextLiteral.updateInfoViewTypeUpdate,
                                 title: TextLiteral.featTitleFirst,
                                 image: "easierShortcutWrite",
                                 description: TextLiteral.featContentFirst)
                
                aboutFeatureCell(type: TextLiteral.updateInfoViewTypeUpdate,
                                 title: TextLiteral.featTitleSecond,
                                 image: "easierExternalURL",
                                 description: TextLiteral.featContentSecond)
                
                aboutFeatureCell(type: TextLiteral.updateInfoViewTypeUpdate,
                                 title: TextLiteral.featTitleThird,
                                 image: nil,
                                 description: TextLiteral.featContentThird)
                aboutFeatureCell(type: "버그 수정",
                                 title: "iOS 17.1에서 발생하는 버그 수정",
                                 image: nil,
                                 description: "iOS 17.1 및 그 이후의 iOS에서 발생하는 버그를 수정했어요. 단축어를 자세히 둘러보고 나갈 때 탭 바가 사라지고 뒤로가기 동작이 정상적으로 작동하지 않는 문제가 있었어요. 불편함을 느끼셨을 사용자 분들께 사과드려요.")
                
                VStack(alignment: .center, spacing: 20) {
                    Text(TextLiteral.updateInfoViewFooterTitle)
                        .shortcutsZipTitle2()
                        .foregroundStyle(Color.gray6)
                        .multilineTextAlignment(.center)
                    Button {
                        if !useWithoutSignIn {
                            isShowFormView.toggle()
                        } else {
                            loginAlerter.isPresented = true
                        }
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
            .padding(.bottom, 44)
        }
        .edgesIgnoringSafeArea(.top)
        .navigationBarTitleDisplayMode(.inline)
        .background(Color.shortcutsZipBackground)
        .sheet(isPresented: self.$isShowFormView) {
            SuggestionFormView(viewModel: SuggestionFormViewModel())
                .presentationDetents([.large])
                .presentationDragIndicator(.visible)
        }

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
            }
            Text(description.lineBreaking)
                .shortcutsZipBody2()
                .foregroundStyle(Color.gray5)
                .multilineTextAlignment(.leading)
        }
        .padding(.horizontal, 20)
    }
}

struct UpdateInfoView_Previews: PreviewProvider {
    static var previews: some View {
        AboutUpdateView()
    }
}

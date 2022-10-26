//
//  WriteCurationSetView.swift
//  HappyAnding
//
//  Created by 이지원 on 2022/10/19.
//

import SwiftUI

struct WriteCurationSetView: View {
    
    //TODO: 데이터 모델 제작 후 해당 ObservedObject 삭제 필요.
    @ObservedObject var shortcutData = fetchData()
    
    
    @State var selectedShortcuts = [String]()
    
    @State private var numberOfSelected: Int = 0
    @State var isSelected: Bool = false
    
    var body: some View {
        VStack() {
            ProgressView(value: 1, total: 2)
                .padding(.bottom, 40)
            listHeader
            ScrollView {
                shortcutList
            }
            bottomButton
        }
        .background(Color.Background)
    }
    
    ///단축어 선택 텍스트 및 카운터
    var listHeader: some View {
        HStack(alignment: .bottom) {
            Text("단축어 선택")
                .Headline()
                .foregroundColor(.Gray5)
            Text("최대 10개 선택")
                .Footnote()
                .foregroundColor(.Gray3)
            Spacer()
            Text("\(numberOfSelected)개")
                .Body2()
                .foregroundColor(.Primary)
        }
        .padding(.horizontal, 16)
        .padding(.bottom, 20)
    }
    
    ///내가 작성한, 좋아요를 누른 단축어 목록
    var shortcutList: some View {
        ForEach(0..<10, id: \.self) { index in
            CheckBoxShortcutCell(isShortcutTapped: isSelected, color: self.shortcutData.data[index].color,
                         sfSymbol: self.shortcutData.data[index].sfSymbol,
                         name: self.shortcutData.data[index].name,
                         description: self.shortcutData.data[index].description)
        }
    }
    
    ///완료 버튼
    var bottomButton: some View {
        Button(action: {
            //Action넣기
        }, label: {
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .foregroundColor(isSelected ? .Primary : .Gray1)
                    .padding(.horizontal, 16)
                    .frame(height: 52)
                Text("완료")
                    .foregroundColor(isSelected ? .Background : .Gray3)
            }
        })
        .padding(.bottom, 24)
        .disabled(!isSelected)
    }
}

struct WriteCurationSetView_Previews: PreviewProvider {
    static var previews: some View {
        WriteCurationSetView()
    }
}

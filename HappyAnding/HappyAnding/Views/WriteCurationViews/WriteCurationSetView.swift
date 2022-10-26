//
//  WriteCurationSetView.swift
//  HappyAnding
//
//  Created by 이지원 on 2022/10/19.
//

import SwiftUI

struct WriteCurationSetView: View {
    
    @State var title = ""
    @State private var numberOfSelected: Int = 0
    @State private var isSelected: Bool = false
    
    var body: some View {
        VStack(spacing: 36) {
            ProgressView(value: 1, total: 2)
            listHeader
            
            Spacer()
                .frame(maxHeight: .infinity)
            
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
            .disabled(!isSelected)
        }
        .background(Color.Background)
    }

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
    
    var shortcutList: some View {
        VStack {
            
        }
    }
    
}

struct WriteCurationSetView_Previews: PreviewProvider {
    static var previews: some View {
        WriteCurationSetView()
    }
}

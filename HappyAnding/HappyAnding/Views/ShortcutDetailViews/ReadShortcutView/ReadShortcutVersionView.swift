//
//  ReadShortcutVersionView.swift
//  HappyAnding
//
//  Created by 이지원 on 2022/11/21.
//

import SwiftUI

struct ReadShortcutVersionView: View {
    
    @State var shortcut: Shortcuts
    @State var updateDate = ""
    var body: some View {
        if shortcut.updateDescription.count == 1 {
            Text("아직 업데이트된 버전이 없습니다.")
                .Body2()
                .foregroundColor(.Gray4)
        } else {
            VStack(alignment: .leading) {
                Text("업데이트 내용")
                    .Body2()
                    .foregroundColor(.Gray4)
                    .padding(.bottom, 16)
                ForEach(Array(zip(shortcut.updateDescription, shortcut.updateDescription.indices)), id: \.0) { data, index in
                    //                if index != 0 {
                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            Text("Ver \(index+1).0")
                                .Body2()
                                .foregroundColor(.Gray5)
                            
                            Spacer()
                            Text(updateDate)
                                .Body2()
                                .foregroundColor(.Gray3)
                        }
                        .onAppear {
                            var date = shortcut.date[index]
                            date = shortcut.date[index].substring(from: 0, to: 7)
                            let index1 = date.index(date.startIndex, offsetBy: 4)
                            let index2 = date.index(date.startIndex, offsetBy: 6)
                            date.insert(".", at: index2)
                            date.insert(".", at: index1)
                            self.updateDate = date
                        }
                        Text(data)
                            .Body2()
                            .foregroundColor(.Gray5)
                        
                        let link = "[이전 버전 다운로드](\(shortcut.downloadLink[index]))"
                        Text(.init(link))
                            .tint(.Primary)
                        
                        Divider()
                        
                    }
                    Spacer()
                        .frame(maxHeight: .infinity)
                }
            }
        }
    }
}

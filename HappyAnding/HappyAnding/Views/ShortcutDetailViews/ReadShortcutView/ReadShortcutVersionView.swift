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
            VStack(alignment: .leading, spacing: 16) {
                Text("업데이트 내용")
                    .Body2()
                    .foregroundColor(.Gray4)
                ForEach(Array(zip(shortcut.updateDescription, shortcut.updateDescription.indices)), id: \.0) { data, index in
                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            Text("Ver \(shortcut.updateDescription.count - index).0")
                                .Body2()
                                .foregroundColor(.Gray5)
                            
                            Spacer()
                            Text(updateDate)
                                .Body2()
                                .foregroundColor(.Gray3)
                        }
                        .onAppear {
                            self.updateDate = shortcut.date[index].getVersionUpdateDateFormat()
                        }
                        if data != "" {
                            Text(data)
                                .Body2()
                                .foregroundColor(.Gray5)
                        }
                        if index != 0 {
                            let link = "[이전 버전 다운로드](\(shortcut.downloadLink[index]))"
                            Text(.init(link))
                                .tint(.Primary)
                        }
                        Divider()
                            .foregroundColor(.Gray1)
                        
                    }
                }
                Spacer()
                    .frame(maxHeight: .infinity)
            }
            .padding(.top, 16)
        }
    }
}

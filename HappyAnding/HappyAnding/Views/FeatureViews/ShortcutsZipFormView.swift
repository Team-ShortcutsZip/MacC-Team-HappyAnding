//
//  ShortcutsZipFormView.swift
//  HappyAnding
//
//  Created by HanGyeongjun on 10/23/23.
//

import SwiftUI

struct ShortcutsZipFormView: View {
    
    enum Field: Hashable {
        case text
    }
    
    @FocusState var focusState: Bool
    @State var formText: String = ""
    
    var body: some View {
        VStack(spacing: 0) {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    Text("ShortcutsZip에게\n전하고 싶은 말을 남겨 주세요")
                        .shortcutsZipTitle1()
                        .foregroundStyle(Color.gray6)
                    Text("기능 제안, 칭찬 등 무엇이든 작성해주세요")
                        .shortcutsZipHeadline()
                        .foregroundStyle(Color.gray4)
                    TextField("답변 입력하기", text: $formText, axis: .vertical)
                        .shortcutsZipBody1()
                        .padding(.all, 12)
                        .background( Color.gray1 )
                        .cornerRadius(12, corners: .allCorners)
                        .lineLimit(5)
                        .focused($focusState, equals: true)
                }
                .padding(.top, 40)
                .padding(16)
            }
            .onAppear() {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    self.focusState = true
                }
            }
            
            Button {
                //api 연결
            } label: {
                Text("확인")
                    .shortcutsZipBody1()
                    .fontWeight(.semibold)
                    .foregroundStyle( Color.textIcon )
                    .padding(.vertical, 16)
                    .frame(maxWidth: .infinity)
                    .background( formText.isEmpty ? Color.gray3 : Color.shortcutsZipPrimary )
                
            }
            .disabled(formText.isEmpty)
        }
        .background( Color.shortcutsZipBackground )
        .onTapGesture {
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        }
    }
}

#Preview {
    ShortcutsZipFormView()
}

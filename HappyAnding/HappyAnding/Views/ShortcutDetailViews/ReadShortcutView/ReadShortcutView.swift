//
//  ReadShortcutView.swift
//  HappyAnding
//
//  Created by 이지원 on 2022/10/19.
//

import SwiftUI

struct ReadShortcutView: View {
    
    @State var isMyShortcut: Bool = true
    
    var body: some View {
        VStack {
            ReadShortcutHeaderView()
            ReadShortcutContentView()
            Button(action: {
        
            }) {
                RoundedRectangle(cornerRadius: 12)
                    .foregroundColor(Color.Primary)
                    .frame(height: 52)
                    .padding(.horizontal, 16)
                    .overlay {
                        HStack {
                            Text("다운로드 |")
                            Image(systemName: "arrow.down.app")
                            Text("45")
                        }
                        .Body1()
                        .foregroundColor(Color.Background)
                    }
            }
        }
        .padding(.vertical, 20)
        .background(Color.Background)
        .navigationBarItems(trailing: Menu(content: {
            if isMyShortcut {
                myShortcutMenuSection
            } else {
                otherShortcutMenuSection
            }
        }, label: {
            Image(systemName: "ellipsis")
        }))
    }
}

extension ReadShortcutView {
    var myShortcutMenuSection: some View {
        Section {
            Button(action: {
                //Place something action here
            }) {
                Label("편집", systemImage: "square.and.pencil")
            }
            Button(action: {
                //Place something action here
            }) {
                Label("공유", systemImage: "square.and.arrow.up")
            }
            Button(action: {
                //Place something action here
            }) {
                Label("삭제", systemImage: "trash.fill")
            }
        }
    }
    
    var otherShortcutMenuSection: some View {
        Section {
            Button(action: {
                //Place something action here
            }) {
                Label("공유", systemImage: "square.and.arrow.up")
            }
            Button(action: {
                //Place something action here
            }) {
                Label("신고", systemImage: "light.beacon.max.fill")
            }
        }
    }
}

struct ReadShortcutView_Previews: PreviewProvider {
    static var previews: some View {
        ReadShortcutView()
    }
}

//
//  ReadShortcutTabView.swift
//  HappyAnding
//
//  Created by 이지원 on 2022/11/21.
//

import SwiftUI

struct ReadShortcutTabView: View {
    
    @Binding var shortcut: Shortcuts
    @Binding var heigth: CGFloat
    
    @State var currentTab: Int = 0
   
    @Namespace var namespace
    
    var tabItems = ["기본 정보", "버전 정보", "댓글"]
    var body: some View {
        GeometryReader { geometry in
            VStack {
                tabBarView
                TabView(selection: self.$currentTab) {
                    ReadShortcutContentView(shortcut: self.$shortcut).tag(0)
                    view2.tag(1)
                    view3.tag(2)
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
                .edgesIgnoringSafeArea(.all)
            }
        }
    }
    
    // contentsView
    var view1: some View {
        Color.red
            .edgesIgnoringSafeArea(.all)
            .frame(maxHeight: .infinity)
    }
    
    var view2: some View {
        Color.blue
            .edgesIgnoringSafeArea(.all)
    }
    
    var view3: some View {
        Color.yellow
            .edgesIgnoringSafeArea(.all)
    }
    
    var tabBarView: some View {
        HStack(spacing: 20) {
            ForEach(Array(zip(self.tabItems.indices, self.tabItems)), id: \.0) { index, name in
                tabBarItem(string: name, tab: index)
            }
        }
        .background(Color.Background)
        .frame(height: 36)
    }
    
    func tabBarItem(string: String, tab: Int) -> some View {
        Button {
            self.currentTab = tab
        } label: {
            VStack {
                Spacer()
                
                if self.currentTab == tab {
                    Text(string)
                        .Headline()
                        .foregroundColor(.Gray5)
                    Color.Gray5
                        .frame(height: 2)
                        .matchedGeometryEffect(id: "underline", in: namespace, properties: .frame)
                    
                } else {
                    Text(string)
                        .Body1()
                        .foregroundColor(.Gray3)
                    Color.clear.frame(height: 2)
                }
            }
            .animation(.spring(), value: currentTab)
        }
        .buttonStyle(.plain)
    }
}

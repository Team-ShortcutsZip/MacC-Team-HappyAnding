//
//  NavigationRouter.swift
//  HappyAnding
//
//  Created by 이지원 on 2023/02/16.
//

import SwiftUI


struct NavigationRouter<Content>: View where Content: View {
    
    @ViewBuilder var content: () -> Content
    @Binding var path: NavigationPath
    
    var body: some View {

        if #available(iOS 16.1, *) {
            NavigationStack(path: $path, root: content)
                .modifier(NavigationViewModifier())
            
        } else {
            NavigationView(content: content)
                .navigationViewStyle(StackNavigationViewStyle())
        }
    }
}




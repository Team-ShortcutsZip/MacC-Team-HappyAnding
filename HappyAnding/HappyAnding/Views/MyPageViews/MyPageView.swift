//
//  MyPageView.swift
//  HappyAnding
//
//  Created by 이지원 on 2022/10/19.
//

import SwiftUI

struct MyPageView: View {
    var body: some View {
        VStack(spacing: 32) {
            HStack {
                Text("프로필")
                    .LargeTitle()
                Spacer()
                NavigationLink(destination: SettingView()) {
                    Image(systemName: "gearshape.fill")
                        .Title2()
                }
            }
            .foregroundColor(.Gray5)
            .padding(.horizontal, 16)
            .padding(.top, 46)
            .padding(.bottom, 3)
            HStack(spacing: 16) {
                Circle().frame(width: 60).foregroundColor(.gray)
                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        Text("이름")
                            .Title1()
                            .foregroundColor(.Gray5)
                        Image(systemName: "square.and.pencil")
                            .Title2() 
                            .foregroundColor(.Gray4)
                    }
                    Text("이메일")
                        .Body2()
                        .foregroundColor(.Gray3)
                }
                Spacer()
            }
            .frame(maxWidth: .infinity)
            .padding(.horizontal, 16)
            
            MyShortcutCardListView()
        }
        
        
    }
}

struct MyPageView_Previews: PreviewProvider {
    static var previews: some View {
        MyPageView()
    }
}

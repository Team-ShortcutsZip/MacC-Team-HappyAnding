//
//  MyPageView.swift
//  HappyAnding
//
//  Created by 이지원 on 2022/10/19.
//

import SwiftUI

struct MyPageView: View {
    
    var userName: String
    var userEmail: String
    
    var userShortcuts = Shortcut.fetchData(number: 5)
    var userCurations = UserCuration.fetchData(number: 10)
    
    var body: some View {
        ScrollView {
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
                
                //MARK: - 사용자 프로필
                HStack(spacing: 16) {
                    Circle()
                        .frame(width: 60)
                        .foregroundColor(.gray)
                    VStack(alignment: .leading, spacing: 4) {
                        HStack {
                            Text(userName)
                                .Title1()
                                .foregroundColor(.Gray5)
                            Image(systemName: "square.and.pencil")
                                .Title2()
                                .foregroundColor(.Gray4)
                        }
                        Text(userEmail)
                            .Body2()
                            .foregroundColor(.Gray3)
                    }
                    Spacer()
                }
                .frame(maxWidth: .infinity)
                .padding(.horizontal, 16)
                
                //TODO: - 단축어 목록 데이터를 넘겨주는 로직으로 변경 시 변경 필요
//                MyShortcutCardListView(shortcuts: userShortcuts)
                MyShortcutCardListView()
                UserCurationListView(userCurations: userCurations)
                    .frame(maxWidth: .infinity)
                    .padding(.bottom, 44)
            }
        }
        .scrollIndicators(.hidden)
        .background(Color.Background)
    }
}

struct MyPageView_Previews: PreviewProvider {
    static var previews: some View {
        MyPageView(userName: "롬희", userEmail: "appleid@pos.idserve.net")
    }
}

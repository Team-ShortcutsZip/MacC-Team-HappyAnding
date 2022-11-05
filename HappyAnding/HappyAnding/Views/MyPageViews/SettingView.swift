//
//  SettingView.swift
//  HappyAnding
//
//  Created by 이지원 on 2022/10/19.
//

import MessageUI
import SwiftUI

struct SettingView: View {
    
    @State var result: Result<MFMailComposeResult, Error>? = nil
    @State var isShowingMailView = false
    
    var body: some View {
        VStack(alignment: .leading) {
            //            Text("알림 설정")
            //                .padding(.top, 16)
            //                .padding(.bottom, 12)
            //
            //            //TODO: 화면 연결 필요
            //            NavigationLink(destination: EmptyView()) {
            //                SettingCell(title: "알림 및 소리")
            //            }
            
            SettingCell(title: "버전정보", version: "1.0.0")
            
            Button(action : {
                if MFMailComposeViewController.canSendMail() {
                    self.isShowingMailView.toggle()
                    
                }
            }) {
                if MFMailComposeViewController.canSendMail() {
                    SettingCell(title: "개발자에게 연락하기")
                    
                }
                //못 보내는 기기일 때 뜨는 것. 아예 지워도 될 것 같긴 한데 어떻게할까요. 못 보내는 기기의 기준이 확실치 않아서 일단 이렇게 둠.
                else {
                    SettingCell(title: "문의사항은 shortcutszip@gmail.com로 메일 주세요")
                }
                
            }
            .sheet(isPresented: $isShowingMailView) {
                MailView(isShowing: self.$isShowingMailView, result: self.$result)
            }
            
            Button(action: {
                //TODO: 로그아웃 로직 작성 필요
                print("로그아웃")
            }) {
                SettingCell(title: "로그아웃")
            }
            Spacer()
        }
        .padding(.horizontal, 16)
        .background(Color.Background)
        .navigationBarTitleDisplayMode(.inline)
    }
}
struct SettingCell: View {
    var title: String
    var version: String?
    var body: some View {
        HStack {
            Text(title)
            Spacer()
            if let version {Text(version)}
        }
        .Body1()
        .foregroundColor(.Gray4)
        .padding(.horizontal, 12)
        .padding(.vertical, 16)
    }
    
}

struct SettingView_Previews: PreviewProvider {
    static var previews: some View {
        SettingView()
    }
}

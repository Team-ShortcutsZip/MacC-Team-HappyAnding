//
//  SettingView.swift
//  HappyAnding
//
//  Created by 이지원 on 2022/10/19.
//

import MessageUI
import SwiftUI

import FirebaseAuth

struct SettingView: View {
    
    @AppStorage("signInStatus") var signInStatus = false
    @StateObject var userAuth = UserAuth.shared
    
    @State var result: Result<MFMailComposeResult, Error>? = nil
    @State var isShowingMailView = false
    @State var isTappedSignOutButton = false
    
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
                    SettingCell(title: "문의사항은 shortcutszip@gmail.com 으로 메일 주세요")
                        .multilineTextAlignment(.leading)
                }
                
            }
            .sheet(isPresented: $isShowingMailView) {
                MailView(isShowing: self.$isShowingMailView, result: self.$result)
            }
            
            Button(action: {
                self.isTappedSignOutButton = true
            }) {
                SettingCell(title: "로그아웃")
            }
            .alert(isPresented: $isTappedSignOutButton) {
                Alert(title: Text("로그아웃"),
                      message: Text("로그아웃 하시겠습니까?"),
                      primaryButton: .default(Text("닫기")
                                              ,action: { self.isTappedSignOutButton = false }),
                      secondaryButton: .destructive( Text("로그아웃"), action: { signOut() }))
            }
            Spacer()
        }
        .padding(.horizontal, 16)
        .background(Color.Background)
        .navigationBarTitleDisplayMode(.inline)
    }
    
    
    private func signOut() {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            self.signInStatus = false
        } catch {
            print(error.localizedDescription)
        }
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

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
    @EnvironmentObject var userAuth: UserAuth
    @EnvironmentObject var shortcutsZipViewModel: ShortcutsZipViewModel
    
    @ObservedObject var webViewModel = WebViewModel()
    
    @AppStorage("signInStatus") var signInStatus = false
    @AppStorage("useWithoutSignIn") var useWithoutSignIn = false
    
    @State var result: Result<MFMailComposeResult, Error>? = nil
    @State var isShowingMailView = false
    @State var isTappedLogOutButton = false
    @State var isTappedSignOutButton = false
    @State var isTappedPrivacyButton = false
    
    var body: some View {
        VStack(alignment: .leading) {
            
            /*
             // TODO: 알림 기능
            Text("알림 설정")
                .padding(.top, 16)
                .padding(.bottom, 12)
            
            //TODO: 화면 연결 필요
            NavigationLink(destination: EmptyView()) {
                SettingCell(title: "알림 및 소리")
            }
            */
            
            // MARK: - 버전 정보
            SettingCell(title: TextLiteral.settingViewVersion, version: TextLiteral.settingViewVersionNumber)
            
            
            // MARK: - 오픈소스 라이선스
            
            SettingCell(title: TextLiteral.settingViewOpensourceLicense)
                .navigationLinkRouter(data: NavigationLisence.first)
            
            
            // MARK: - 개인정보처리방침 모달뷰
            
            Button {
                self.isTappedPrivacyButton.toggle()
            } label: {
                SettingCell(title: TextLiteral.settingViewPrivacyPolicy)
            }
            
            
            // MARK: - 개발팀에 관하여 버튼
            //TODO: Halogen의 꿈. 추후 스프린트 시 완성되면 적용 예정
//            NavigationLink(destination: AboutTeamView()) {
//                SettingCell(title: "개발팀에 관하여")
//            }
            
            // MARK: - 개발자에게 연락하기 버튼
            
            Button(action : {
                if MFMailComposeViewController.canSendMail() {
                    self.isShowingMailView.toggle()
                }
            }) {
                if MFMailComposeViewController.canSendMail() {
                    SettingCell(title: TextLiteral.settingViewContact)
                }
                //못 보내는 기기일 때 뜨는 것. 아예 지워도 될 것 같긴 한데 어떻게할까요. 못 보내는 기기의 기준이 확실치 않아서 일단 이렇게 둠.
                else {
                    SettingCell(title: TextLiteral.settingViewContactMessage)
                        .multilineTextAlignment(.leading)
                }
            }
            
            //로그인없이 둘러보기 여부에 따라 보여지는 버튼 다르게 표시
            if useWithoutSignIn {
                //MARK: - 로그인없이 둘러보기 시 로그인 버튼
                Button {
                    useWithoutSignIn = false
                } label: {
                    SettingCell(title: TextLiteral.settingViewLogin)
                }
                
            } else {
                // MARK: - 로그아웃 버튼
                Button {
                    self.isTappedLogOutButton.toggle()
                } label: {
                    SettingCell(title: TextLiteral.settingViewLogout)
                }
                .alert(TextLiteral.settingViewLogout, isPresented: $isTappedLogOutButton) {
                    Button(role: .cancel) {
                        
                    } label: {
                        Text(TextLiteral.cancel)
                    }
                    
                    Button(role: .destructive) {
                        logOut()
                    } label: {
                        Text(TextLiteral.settingViewLogout)
                    }
                } message: {
                    Text(TextLiteral.settingViewLogoutMessage)
                }
                
                // MARK: - 회원탈퇴 버튼
                SettingCell(title: TextLiteral.settingViewWithdrawal)
                    .navigationLinkRouter(data: NavigationWithdrawal.first)
            }
            
            Spacer()
        }
        .sheet(isPresented: $isShowingMailView) {
            MailView(isShowing: self.$isShowingMailView, result: self.$result)
        }
        
        .sheet(isPresented: self.$isTappedPrivacyButton) {
            ZStack {
                PrivacyPolicyView(viewModel: webViewModel,
                                  isTappedPrivacyButton: $isTappedPrivacyButton,
                                  url: TextLiteral.settingViewPrivacyPolicyURL)
                    .environmentObject(webViewModel)
                    .presentationDetents([.large])
                    .presentationDragIndicator(.visible)
                if webViewModel.isLoading {
                    ProgressView()
                }
            }
        }
        
        .padding(.horizontal, 16)
        .background(Color.shortcutsZipBackground)
        .navigationBarTitleDisplayMode(.inline)
    }
    
    
    private func logOut() {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            userAuth.signOut()
            self.signInStatus = false
            shortcutsZipViewModel.resetUser()
            UserDefaults.shared.set(false, forKey: "isSignInForShareExtension")
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
        .foregroundColor(.gray4)
        .padding(.horizontal, 12)
        .padding(.vertical, 16)
    }
    
}

struct SettingView_Previews: PreviewProvider {
    static var previews: some View {
        SettingView()
    }
}

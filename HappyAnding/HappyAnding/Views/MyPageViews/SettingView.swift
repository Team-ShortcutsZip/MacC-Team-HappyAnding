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
    
    @State var result: Result<MFMailComposeResult, Error>? = nil
    @State var isShowingMailView = false
    @State var isTappedLogOutButton = false
    @State var isTappedSignOutButton = false
    @State var isTappedPrivacyButton = false
    
    @AppStorage("signInStatus") var signInStatus = false
    @AppStorage("useWithoutSignIn") var useWithoutSignIn = false
    
    enum NavigationLisence: Hashable, Equatable {
        case first
    }
    
    enum NavigationWithdrawal: Hashable, Equatable {
        case first
    }
    
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
            SettingCell(title: "버전정보", version: "1.1.0")
            
            
            // MARK: - 오픈소스 라이선스
            
            NavigationLink(value: NavigationLisence.first) {
                SettingCell(title: "오픈소스 라이선스")
            }
            
            
            // MARK: - 개인정보처리방침 모달뷰
            
            Button {
                self.isTappedPrivacyButton.toggle()
            } label: {
                SettingCell(title: "개인정보처리방침")
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
                    SettingCell(title: "개발자에게 연락하기")
                }
                //못 보내는 기기일 때 뜨는 것. 아예 지워도 될 것 같긴 한데 어떻게할까요. 못 보내는 기기의 기준이 확실치 않아서 일단 이렇게 둠.
                else {
                    SettingCell(title: "문의사항은 shortcutszip@gmail.com 으로 메일 주세요")
                        .multilineTextAlignment(.leading)
                }
            }
            
            //로그인없이 둘러보기 여부에 따라 보여지는 버튼 다르게 표시
            if useWithoutSignIn {
                //MARK: - 로그인없이 둘러보기 시 로그인 버튼
                Button {
                    useWithoutSignIn = false
                } label: {
                    SettingCell(title: "로그인")
                }
                
            } else {
                // MARK: - 로그아웃 버튼
                Button {
                    self.isTappedLogOutButton.toggle()
                } label: {
                    SettingCell(title: "로그아웃")
                }
                .alert("로그아웃", isPresented: $isTappedLogOutButton) {
                    Button(role: .cancel) {
                        
                    } label: {
                        Text("닫기")
                    }
                    
                    Button(role: .destructive) {
                        logOut()
                    } label: {
                        Text("로그아웃")
                    }
                } message: {
                    Text("로그아웃 하시겠습니까?")
                }
                
                // MARK: - 회원탈퇴 버튼
                NavigationLink(value: NavigationWithdrawal.first) {
                    SettingCell(title: "탈퇴하기")
                }
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
                                  url: "https://noble-satellite-574.notion.site/60d8fa2f417c40cca35e9c784f74b7fd")
                    .environmentObject(webViewModel)
                    .presentationDetents([.large])
                    .presentationDragIndicator(.visible)
                if webViewModel.isLoading {
                    ProgressView()
                }
            }
        }
        
        .navigationDestination(for: NavigationLisence.self) { value in
            LicenseView()
        }
        
        .navigationDestination(for: NavigationWithdrawal.self) { _ in
            WithdrawalView()
        }
        
        .padding(.horizontal, 16)
        .background(Color.Background)
        .navigationBarTitleDisplayMode(.inline)
    }
    
    
    private func logOut() {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            userAuth.signOut()
            self.signInStatus = false
            shortcutsZipViewModel.resetUser()
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

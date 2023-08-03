//
//  HappyAndingApp.swift
//  HappyAnding
//
//  Created by 이지원 on 2022/10/14.
//

import SwiftUI

import Firebase
import FirebaseCore
import FirebaseFirestore
import FirebaseMessaging


@main
struct HappyAndingApp: App {
    @Environment(\.scenePhase) var scenePhase
    @Environment(\.openURL) private var openURL
    
    @StateObject var shortcutsZipViewModel = ShortcutsZipViewModel.share
    @StateObject var loginAlerter = Alerter()
    @StateObject var gradeAlerter = Alerter()
    
    @AppStorage("useWithoutSignIn") var useWithoutSignIn: Bool = false
    
    @State var isNeededUpdate = false
    @State var isShowingLaunchScreen = true
    @State var version = Version(latestVersion: "", minimumVersion: "", description: "", title: "")
    
    init() {
        FirebaseApp.configure()
    }
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    var body: some Scene {
        WindowGroup {
            if isShowingLaunchScreen {
                ZStack {
                    Color.shortcutsZipPrimary.ignoresSafeArea()
                    Text("ShortcutsZip")
                        .foregroundColor(Color.white)
                        .font(.system(size: 26, weight: .bold))
                        .frame(maxHeight: .infinity)
                        .ignoresSafeArea()
                }
                .alert(version.title, isPresented: $isNeededUpdate) {
                    Button(role: .cancel) {
                        isShowingLaunchScreen = false
                    } label: {
                        Text(TextLiteral.later)
                    }
                    Button() {
                        let url = TextLiteral.appStoreUrl
                        if let url = URL(string: url){
                            UIApplication.shared.open(url)
                        }
                        isShowingLaunchScreen = false
                    } label: {
                        Text(TextLiteral.update)
                    }
                } message: {
                    Text(version.description)
                }
            } else {
                ShortcutsZipView()
                    .environmentObject(shortcutsZipViewModel)
                    .environment(\.loginAlertKey, loginAlerter)
                    .alert(TextLiteral.loginTitle, isPresented: $loginAlerter.isPresented) {
                        Button(role: .cancel) {
                        } label: {
                            Text(TextLiteral.cancel)
                        }
                        Button {
                            useWithoutSignIn = false
                        } label: {
                            Text(TextLiteral.loginAction)
                        }
                    } message: {
                        Text(TextLiteral.loginMessage)
                    }
            }
        }
        .onChange(of: scenePhase) { (newScenePhase) in
            switch newScenePhase {
            case .active:
                CheckUpdateVersion.share.fetchVersion { version, isNeeded in
                    self.version = version
                    self.isNeededUpdate = isNeeded
                    if !isNeeded {
                        isShowingLaunchScreen = false
                    }
                }
                break
            case .inactive:
                break
            case .background:
                break
            @unknown default:
                break
            }
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {
    
    let gcmMessageIDKey = "gcm.message_id"
    
    // APN 등록 및 사용자 권한 받기
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        
        // 원격 알림 등록
        UNUserNotificationCenter.current().delegate = self
        
        let authOption: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(
            options: authOption,
            completionHandler: { _, _ in }
        )
        
        application.registerForRemoteNotifications()
        
        // 메시지 대리자 설정
        Messaging.messaging().delegate = self
        
        return true
    }
    
    // APNs 토큰과 등록 토큰 매핑
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Messaging.messaging().apnsToken = deviceToken
    }
    
    // 주제 메시지 수신 및 처리
    func application(_ application: UIApplication,
                     didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        
        print(userInfo)
        
        completionHandler(UIBackgroundFetchResult.newData)
    }
}

// 토큰 갱신 모니터링
extension AppDelegate: MessagingDelegate {
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        
        let dataDict: [String: String] = ["token": fcmToken ?? ""]
        NotificationCenter.default.post(
            name: Notification.Name("FCMToken"),
            object: nil,
            userInfo: dataDict
        )
        
        // TODO: If necessary send token to application server.
        
        print("================== 토큰 =========================")
        print(dataDict)
    }
}

// 알림 처리
extension AppDelegate: UNUserNotificationCenterDelegate {
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        let userInfo = notification.request.content.userInfo
        
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        
        
        print(userInfo)
        
        completionHandler([[.banner, .badge, .sound]])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        
        let userInfo = response.notification.request.content.userInfo
        
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        
        print(userInfo)
        
        completionHandler()
    }
}

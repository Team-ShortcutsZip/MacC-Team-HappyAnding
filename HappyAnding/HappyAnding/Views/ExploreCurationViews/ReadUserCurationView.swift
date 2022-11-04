//
//  ReadUserCurationView.swift
//  HappyAnding
//
//  Created by HanGyeongjun on 2022/10/22.
//

import SwiftUI

struct ReadUserCurationView: View {
    
    @Environment(\.presentationMode) var presentation: Binding<PresentationMode>
    
    let firebase = FirebaseService()
    @State var authorInformation: User? = nil
    
    @State var isWriting = false
    @State var isTappedEditButton = false
    @State var isTappedShareButton = false
    @State var isTappedDeleteButton = false
    
    let userCuration: Curation
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            ZStack(alignment: .bottom) {
                Color.White
                    .ignoresSafeArea(.all, edges: .all)
                    .frame(height: 371)
                
                VStack{
                    userInformation
                        .padding(.bottom, 22)
                    UserCurationCell(curation: userCuration)
                        .padding(.bottom, 12)
                }
            }
            ForEach(Array(userCuration.shortcuts.enumerated()), id: \.offset) { index, shortcut in
                NavigationLink(destination: ReadShortcutView(shortcutCell: shortcut)) {
                    ShortcutCell(shortcutCell: shortcut)
                    .padding(.bottom, index == userCuration.shortcuts.count - 1 ? 44 : 0)
                }
            }
        }
        .background(Color.Background.ignoresSafeArea(.all, edges: .all))
        .scrollContentBackground(.hidden)
        .edgesIgnoringSafeArea([.top])
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarItems(trailing: Menu(content: {
            if userCuration.author == firebase.currentUser() {
                myCurationMenuSection
            } else {
                //다른 사람 큐레이션 볼 때 공유버튼 동작(트레일링 아이템) 제거.
                // TODO: 2차 스프린트 이후 공유 기능 구현 및 해당 코드 복원
//                otherCurationMenuSection
            }
        }, label: {
            Image(systemName: userCuration.author == firebase.currentUser() ? "ellipsis" : "square.and.arrow.up")
                .foregroundColor(.Gray4)
                //다른 사람 큐레이션 볼 때 공유버튼 (트레일링 아이템) opacity 0
                // TODO: 2차 스프린트 이후 공유 기능 구현 및 해당 코드 제거
                .opacity(userCuration.author == firebase.currentUser() ? 1 : 0)
        }))
        .fullScreenCover(isPresented: $isTappedEditButton) {
            NavigationView {
                WriteCurationSetView(isWriting: $isTappedEditButton,
                                     curation: userCuration, isEdit: true)
            }
        }
    }
    
    var userInformation: some View {
        ZStack {
            HStack {
                Image(systemName: "person.fill")
                    .frame(width: 28, height: 28)
                    .foregroundColor(.White)
                    .background(Color.Gray3)
                    .clipShape(Circle())
                
                Text(authorInformation?.nickname ?? "닉네임")
                    .Headline()
                    .foregroundColor(.Gray4)
                
                Spacer()
                //TODO: 스프린트 1에서 배제 , 추후 주석 삭제 필요
                /*
                Image(systemName: "light.beacon.max.fill")
                    .Headline()
                    .foregroundColor(.Gray5)
                    .onTapGesture {
                        
                        // TODO: 신고기능 연결
                        
                        print("Tapped!")
                    }
                 */
            }
            .padding(.horizontal, 30)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .frame(height: 48)
                    .foregroundColor(.Gray1)
                    .padding(.horizontal, 16)
            )
            .alert(isPresented: $isTappedDeleteButton) {
                Alert(title: Text("글 삭제")
                    .foregroundColor(.Gray5),
                      message: Text("글을 삭제하시겠습니까?")
                    .foregroundColor(.Gray5),
                      primaryButton: .default(Text("닫기"),
                      action: {
                    self.isTappedDeleteButton.toggle()
                }),
                      secondaryButton: .destructive(
                        Text("삭제")
                        , action: {
                            firebase.deleteData(model: userCuration)
                            presentation.wrappedValue.dismiss()
                }))
            }
        }
        .onAppear {
            firebase.fetchUser(userID: userCuration.author) { user in
                authorInformation = user
            }
        }
    }
}


extension ReadUserCurationView {
    var myCurationMenuSection: some View {
        Section {
            Button(action: {
                isTappedEditButton.toggle()
            }) {
                Label("편집", systemImage: "square.and.pencil")
            }
            
            // TODO: 함수 구현 필요
            // TODO: 2차 스프린트 이후 공유 기능 구현 및 해당 코드 복원
//            Button(action: {
//                //Place something action here
//            }) {
//                Label("공유", systemImage: "square.and.arrow.up")
//            }
            Button(role: .destructive, action: {
                isTappedDeleteButton.toggle()
                
                // TODO: firebase delete function
                
            }) {
                Label("삭제", systemImage: "trash.fill")
            }
        }
    }
    
    var otherCurationMenuSection: some View {
        Button(action: {
            //Place something action here
        }) {
            Label("공유", systemImage: "square.and.arrow.up")
        }
    }
}

//struct ReadUserCurationView_Previews: PreviewProvider {
//    static var previews: some View {
//        ReadUserCurationView(userCuration: UserCuration.fetchData(number: 1)[0], nickName: "test")
//    }
//}

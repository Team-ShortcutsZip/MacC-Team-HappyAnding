//
//  NicknameTextField.swift
//  HappyAnding
//
//  Created by 이지원 on 2022/12/01.
//

import SwiftUI



struct NicknameTextField: View {
    
    enum NickNameState {
        case notStatus // not focus && empty
        case status // focus
        case done // 중복확인 완료
        case doneSuccess // 중복확인 미완료
        case doneFail // error
        
        var strokeColor: Color {
            switch self {
            case .notStatus:
                return .Gray2
            case .status:
                return .Primary
            case .done:
                return .Gray4
            case .doneSuccess:
                return .Gray4
            case .doneFail:
                return .Gray4
            }
        }
    }

    enum NickNameError {
        case none
        case emoticon
        case length
        
        var message: String {
            switch self {
            case .none:
                return "*공백 없이 한글, 숫자, 영문만 입력 가능"
            case .emoticon:
                return "사용할 수 없는 문자가 포함되어있습니다."
            case .length:
                return "닉네임은 최대 8글자까지 입력 가능합니다."
            }
        }
        
    }
    
    @EnvironmentObject var shortcutszipViewModel: ShortcutsZipViewModel
    
    @FocusState var isFocused: Bool
    
    @Binding var nickname: String
    
    @State var isNickNameChecked = false
    @State var textFieldState = NickNameState.notStatus
    @State var textFieldError = NickNameError.none
    
    var body: some View {
        
        VStack {
            textField
            errorMessage
        }
        .onChange(of: isFocused) { _ in
            if !isFocused {
                checkValidation()
            }
        }
        .onChange(of: nickname) { _ in
            changedNickname()
//            self.textFieldState = .status
        }
            
//        TextField("닉네임 (최대 8글자)", text: $nickname)
//            .disableAutocorrection(true)
//            .textInputAutocapitalization(.never)
//            .Body2()
//            .focused($isFocused)
//            .foregroundColor(.Gray5)
//            .frame(height: 20)
//            .padding(.leading, 16)
//            .padding(.vertical, 12)
//            .onAppear(perform : UIApplication.shared.hideKeyboard)
//            .onChange(of: nickname) {_ in
//                isValidLength = nickname.count <= 8 && !nickname.isEmpty
//                isNicknameChecked = false
//                isNormalString = nickname.checkCorrectNickname()
//            }
//        if !nickname.isEmpty {
//            textFieldSFSymbol
//        }
//        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
    
    
    var textField: some View {
        HStack (spacing: 12) {
            
            HStack {
                TextField("닉네임 (최대 8글자)", text: $nickname)
                    .disableAutocorrection(true)
                    .textInputAutocapitalization(.never)
                    .focused($isFocused)
                    .frame(height: 52)
                    .Body2()
                    .padding(.horizontal, 16)
                    .onAppear { UIApplication.shared.hideKeyboard() }
                    .onChange(of: nickname) { _ in
                        self.isNickNameChecked = false
                    }
                
                stateIcon
            }
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .strokeBorder(lineWidth: 1)
                    .foregroundColor(textFieldState.strokeColor)
            )
            
            Button {
                shortcutszipViewModel.checkNickNameDuplication(name: nickname) { result in
                    if result {
                        self.textFieldState = .doneFail
                    } else {
                        self.textFieldState = .doneSuccess
                    }
                    
                }
            } label: {
                
                ZStack {
                    RoundedRectangle(cornerRadius: 12)
                        .foregroundColor(self.textFieldState == .doneSuccess && textFieldError == .none ? .Primary.opacity(0.13) : .Primary)
                        .frame(width: 80, height: 52)
                    
                    Text("중복확인")
                        .Body1()
                        .foregroundColor(self.textFieldState == .doneSuccess && textFieldError == .none ? .Text_Button_Disable : .Text_icon)
                }
            }
            .disabled(self.textFieldState == .doneSuccess && textFieldError == .none)
        }
    }
    
    var stateIcon: some View {
        HStack {
        switch self.textFieldState {
            case .status:
                if !nickname.isEmpty {
                    Button {
                        nickname.removeAll()
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .Body2()
                            .foregroundColor(.Gray5)
                    }
                } else {
                    EmptyView()
                }
            case .doneSuccess:
                Image(systemName: "checkmark.circle.fill")
                    .Body2()
                    .foregroundColor(.Success)
                    .onTapGesture { }
            case .doneFail:
                Image(systemName: "exclamationmark.circle.fill")
                    .Body2()
                    .foregroundColor(.red)
            default:
                EmptyView()
            }
        }
        .padding()
    }
    
    var errorMessage: some View {
        VStack {
            if self.textFieldError == .none {
                Text(textFieldError.message)
                    .Footnote()
                    .foregroundColor(nickname.isEmpty ? .Gray2 : .Gray4)
            } else {
                Text(textFieldError.message)
                    .Footnote()
                    .foregroundColor(.red)
            }
        }
    }
    
    private func checkValidation() {
        if isFocused {
            if nickname.count > 8 {
                self.textFieldError = .length
            } else {
                if nickname.checkCorrectNickname() {
                    self.textFieldError = .none
//                    self.textFieldState = .status
                } else {
                    self.textFieldError = .emoticon
                }
            }
        } else {
            if nickname.count > 8 || !nickname.isNormalString() {
                textFieldState = .doneFail
            } else {
                textFieldState = .done
            }
            
        }
    }
    
    
    private func changedNickname() {
        if nickname.count > 8 {
            self.textFieldError = .length
        } else {
            if nickname.checkCorrectNickname() {
                self.textFieldError = .none
                self.textFieldState = .status
            } else {
                textFieldError = .emoticon
            }
        }
    }
    
}

struct NicknameTextField_Previews: PreviewProvider {
    static var previews: some View {
        NicknameTextField(nickname: .constant(""))
    }
}

//
//  NicknameTextField.swift
//  HappyAnding
//
//  Created by 이지원 on 2022/12/01.
//

import SwiftUI

struct NicknameTextField: View {
    
    enum NicknameState {
        case success
        case fail
        case none
        
        var state: Bool {
            if self == .success || self == .none {
                return true
            } else {
                return false
            }
        }
    }
    
    enum NicknameFocus {
        case focus
        case focusError
        case notfocus
        
        var color: Color {
            switch self {
            case .focus:
                return .Primary
            case .focusError:
                return .red
            case .notfocus:
                return .Gray2
            }
        }
        
    }
    
    enum NicknameError {
        case length
        case emoticon
        
        var message: String {
            switch self {
            case .length:
                return "*닉네임은 최대 8글자까지 입력가능합니다."
            case .emoticon:
                return "사용할 수 없는 문자가 포함되어 있습니다."
            }
        }
    }
    
    @EnvironmentObject var shortcutszipViewModel: ShortcutsZipViewModel
    
    @FocusState var isFocused: Bool
    
    @Binding var nickname: String
    
    @State var nicknameState = NicknameState.none
    @State var nicknameFocus = NicknameFocus.notfocus
    @State var nicknameError = NicknameError.length
    @State var isCheckedDuplicated = false
    @Binding var isValid: Bool
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 8) {
            textField
            
            if nicknameFocus == .focusError {
                Text(nicknameError.message)
                    .Footnote()
                    .foregroundColor(.red)
            }
        }
        .onChange(of: nickname) { _ in
            self.nicknameState = .none
            changedFocus()
        }
        .onChange(of: isFocused) { _ in
            if self.nicknameState != .success {
                changedFocus()
            }
        }
        .onChange(of: nicknameState) { newValue in
            self.isValid = newValue == .success
        }
        .alert("닉네임 중복 확인", isPresented: $isCheckedDuplicated) {
            Button {
            } label: {
                Text(nicknameState == .success ? "확인" : "다시 입력하기")
            }
        } message: {
            Text(nicknameState == .success ? "중복된 닉네임이 없습니다" : "중복된 닉네임이 있습니다")
        }
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
                    .foregroundColor(.Gray5)
                    .padding(.horizontal, 16)
                    .onAppear { UIApplication.shared.hideKeyboard()
                    }
                
                stateIcon
                    .padding()
            }
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .strokeBorder(lineWidth: 1)
                    .foregroundColor(nicknameFocus.color)
            )
            
            Button {
                shortcutszipViewModel.checkNickNameDuplication(name: nickname) { result in
                    if !result {
                        self.nicknameState = .success
                        self.nicknameFocus = .notfocus
                    } else {
                        self.nicknameState = .none
                    }
                    self.isCheckedDuplicated = true
                    self.isFocused = self.nicknameState != .success
                }
                
                
            } label: {
                
                ZStack {
                    RoundedRectangle(cornerRadius: 12)
                        .foregroundColor(nicknameState != .none || nickname.isEmpty ? .Primary.opacity(0.13) : .Primary)
                        .frame(width: 80, height: 52)
                    
                    Text("중복확인")
                        .Body1()
                        .foregroundColor(nicknameState != .none || nickname.isEmpty ? .Text_Button_Disable : .Text_icon)
                }
            }
            .disabled(nicknameState != .none || nickname.isEmpty)
        }
    }
    
    var stateIcon: some View {
        HStack {
            if isFocused {
                Button {
                    nickname.removeAll()
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .Body2()
                        .foregroundColor(.Gray5)
                }
            } else {
                if nicknameState == .fail {
                    Image(systemName: "exclamationmark.circle.fill")
                        .Body2()
                        .foregroundColor(.red)
                        .onTapGesture { }
                } else if nicknameState == .success {
                    Image(systemName: "checkmark.circle.fill")
                        .Body2()
                        .foregroundColor(.Success)
                        .onTapGesture { }
                }
            }
        }
    }
    
    
    private func changedFocus() {
        
        if isFocused {
            if self.nickname.count > 8 {
                self.nicknameFocus = .focusError
                self.nicknameError = .length
                self.nicknameState = .fail
            } else if !self.nickname.checkCorrectNickname() {
                self.nicknameFocus = .focusError
                self.nicknameError = .emoticon
                self.nicknameState = .fail
            } else {
                self.nicknameFocus = .focus
                self.nicknameState = .none
            }
        } else {
            if nicknameState == .fail {
                self.nicknameFocus = .focusError
            } else {
                self.nicknameFocus = .notfocus
            }
        }
        
    }
}

struct NicknameTextField_Previews: PreviewProvider {
    static var previews: some View {
        NicknameTextField(nickname: .constant(""), isValid: .constant(true))
    }
}

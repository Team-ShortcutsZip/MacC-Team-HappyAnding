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
                return Color.shortcutsZipPrimary
            case .focusError:
                return Color.shortcutsZipError
            case .notfocus:
                return Color.gray2
            }
        }
        
    }
    
    enum NicknameError {
        case length
        case emoticon
        
        var message: String {
            switch self {
            case .length:
                return TextLiteral.nicknameTextFieldLength
            case .emoticon:
                return TextLiteral.nicknameTextFieldEmoticon
            }
        }
    }
    
    @EnvironmentObject var shortcutszipViewModel: ShortcutsZipViewModel
    
    @FocusState var isFocused: Bool
    
    @Binding var nickname: String
    @Binding var isValid: Bool
    
    @State var nicknameState = NicknameState.none
    @State var nicknameFocus = NicknameFocus.notfocus
    @State var nicknameError = NicknameError.length
    @State var isCheckedDuplicated = false
    
    var initName = ""
    
    private let hapticManager = HapticManager.instance

    var body: some View {
        
        VStack(alignment: .leading, spacing: 8) {
            
            textField
                .padding(.top, 16)
            
            if nicknameFocus == .focusError {
                Text(nicknameError.message)
                    .shortcutsZipFootnote()
                    .foregroundStyle(Color.shortcutsZipError)
                    .onAppear() {
                        hapticManager.notification(type: .error)
                    }
            } else {
                Text(TextLiteral.nicknameTextFieldSpace)
                    .shortcutsZipFootnote()
                    .foregroundStyle(Color.gray3)
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
        .alert(TextLiteral.nicknameTextFieldDuplicateTitle, isPresented: $isCheckedDuplicated) {
            Button {
            } label: {
                Text(nicknameState == .success ? TextLiteral.confirm : TextLiteral.nicknameTextFieldDuplicateFailLabel)
            }
        } message: {
            Text(nicknameState == .success ? TextLiteral.nicknameTextFieldDuplicateSuccessMessage : TextLiteral.nicknameTextFieldDuplicateFailMessage)
        }
    }
    
    var textField: some View {
        HStack (spacing: 12) {
            
            HStack {
                TextField(TextLiteral.nicknameTextFieldTitle, text: $nickname)
                    .disableAutocorrection(true)
                    .textInputAutocapitalization(.never)
                    .focused($isFocused)
                    .frame(height: 52)
                    .shortcutsZipBody2()
                    .foregroundStyle(Color.gray5)
                    .padding(.horizontal, 16)
                    .onAppear { UIApplication.shared.hideKeyboard() }
                
                stateIcon
                    .padding()
            }
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .strokeBorder(lineWidth: 1)
                    .foregroundStyle(nicknameFocus.color)
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
                        .foregroundStyle(nicknameState != .none || nickname.isEmpty || initName == nickname ? Color.shortcutsZipPrimary.opacity(0.13) : Color.shortcutsZipPrimary)
                        .frame(width: 80, height: 52)
                    
                    Text(TextLiteral.nicknameTextFieldDuplicateCheck)
                        .shortcutsZipBody1()
                        .foregroundStyle(nicknameState != .none || nickname.isEmpty || initName == nickname ? Color.textButtonDisable : Color.textIcon)
                }
            }
            .disabled(nicknameState != .none || nickname.isEmpty || initName == nickname)
        }
    }
    
    var stateIcon: some View {
        HStack {
            if isFocused {
                Button {
                    nickname.removeAll()
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .smallIcon()
                        .foregroundStyle(Color.gray5)
                }
            } else {
                if nicknameState == .fail {
                    Image(systemName: "exclamationmark.circle.fill")
                        .smallIcon()
                        .foregroundStyle(Color.shortcutsZipError)
                        .onTapGesture { }
                } else if nicknameState == .success {
                    Image(systemName: "checkmark.circle.fill")
                        .smallIcon()
                        .foregroundStyle(Color.shortcutsZipSuccess)
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

//
//  GradeAlertView.swift
//  HappyAnding
//
//  Created by 전지민 on 2023/02/28.
//

import SwiftUI

struct GradeAlertView: View {
    @Environment(\.gradeAlertKey) var gradeAlerter
    @EnvironmentObject var shortcutsZipViewModel: ShortcutsZipViewModel
    
    @Binding var isShowing: Bool
    
    @State var offset: CGFloat = 0
    @State var isTextShowing = false
    @State var index = 0
    
    var animationSpeed = 0.002
    var delayTime = 0.5
    
    let gradeImage = ["level1Super", "level5Super", "level10Super", "level25Super", "level50Super"]
    private let hapticManager = HapticManager.instance

    var body: some View {
        ZStack {
            Color.black
                .opacity(0.4)
                .edgesIgnoringSafeArea(.all)
            
            xmark
            
            VStack(spacing: 20) {
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(spacing: 60) {
                        if index < 1 {
                            Rectangle()
                                .foregroundColor(Color.white)
                                .frame(width: 170, height: 198)
                        } else {
                            Image(gradeImage[index - 1])
                                .resizable()
                                .frame(width: 170, height: 198)
                        }
                        Image(gradeImage[index])
                            .resizable()
                            .frame(width: 170, height: 198)
                    }
                    .offset(y: offset)
                }
                .frame(maxHeight: 250)
                .disabled(true)
                
                Text(isTextShowing ? TextLiteral.gradeAlertMessage : TextLiteral.gradeAlertMessageBlank)
                    .shortcutsZipTitle1()
                    .foregroundColor(.gray5)
                    .padding(.bottom, 60)
                    .disabled(isTextShowing)
            }
            .padding(.top, 66)
        }
        .onAppear() {
            hapticManager.notification(type: .success)
            index = shortcutsZipViewModel.shortcutGrade - 1
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                withAnimation(.spring(response: 0.7, dampingFraction: 0.3, blendDuration: 0)) {
                    offset = -245
                }
                
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                withAnimation(.easeIn(duration: 0.5)) {
                    isTextShowing = true
                }
            }
        }
    }
    
    var xmark: some View {
        VStack {
            HStack {
                Spacer()
                if isTextShowing {
                    Button {
                        gradeAlerter.isPresented = false
                        isShowing = false
                    } label: {
                        Image(systemName: "xmark")
                            .foregroundColor(.gray5)
                            .font(.system(size: 24, weight: .medium))
                    }
                }
            }
            .padding(.horizontal, 24)
            .padding(.top, 24)
            Spacer()
        }
        .frame(width: 358, height: 516)
        .background(Color.shortcutsZipWhite)
        .cornerRadius(12)
    }
}

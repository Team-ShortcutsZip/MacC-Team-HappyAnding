//
//  VersionCheckView.swift
//  HappyAnding
//
//  Created by 이지원 on 2023/05/27.
//

import SwiftUI

struct VersionCheckView: View {
    @State private var isAnimating = false
    private let animationAxis: Double = 1.0
    private let degree: Double = 5.0
    
    var body: some View {
        VStack {
            
            Spacer()
            
            VStack(spacing: 50) {
                Text("새로운 ShortcutsZip이 나왔어요")
                    .shortcutsZipHeadline()
                    .foregroundColor(.gray5)
                
                Image("versionAppIcon")
                    .cornerRadius(33)
                    .shadow(color: .black.opacity(0.3), radius: 10, x: 10, y: 20)
                    .rotation3DEffect(.degrees(isAnimating ? degree : -degree), axis: (x: animationAxis, y: 0, z:  0))
                    .animation(.easeInOut(duration: 2).repeatForever(), value: isAnimating)
                    .rotation3DEffect(.degrees(isAnimating ? degree : -degree), axis: (x: 0, y: animationAxis, z: 0))
                    .animation(.easeInOut(duration: 2).repeatForever().delay(1), value: isAnimating)
                
                Text("1.0.0/1.2.3")
                    .shortcutsZipFootnote()
                    .foregroundColor(.gray3)
            }
            
            Spacer()
            
            Button {
                print("tapped")
            } label: {
                ZStack {
                    RoundedRectangle(cornerRadius: 12)
                        .foregroundColor(.shortcutsZipPrimary)
                        .frame(maxWidth: .infinity, maxHeight: 52)
                    
                    Text("만나러 가기")
                        .shortcutsZipBody1()
                        .foregroundColor(.textButton)
                }
                .padding(.bottom, 44)
            }
        }
        .onAppear {
            withAnimation {
                isAnimating.toggle()
            }
        }
        .padding(.horizontal, 16)
    }
}

struct VersionCheckView_Previews: PreviewProvider {
    static var previews: some View {
        VersionCheckView()
    }
}

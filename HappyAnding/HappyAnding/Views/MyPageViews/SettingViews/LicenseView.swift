//
//  LicenseView.swift
//  HappyAnding
//
//  Created by HanGyeongjun on 2022/11/07.
//

import SwiftUI

struct LicenseView: View {
    
    @ObservedObject var webViewModel = WebViewModel(url: "https://github.com/firebase")
    
    @State private var isTappedFirebaseButton = false

    
    var body: some View {
        VStack(alignment: .leading) {
            Text("[Firebase](https://github.com/firebase)")
                .Title2()
                .foregroundColor(Color.Gray5)
                .padding(.top, 36)
                .tint(.Gray5)
                /*.onTapGesture {
                    self.isTappedFirebaseButton = true
                }*/
            
            Text("License\nThe contents of this repository are licensed under the Apache License, version 2.0.\nYour use of Firebase is governed by the Terms of Service for Firebase Services.")
                .Body2()
                .foregroundColor(Color.Gray4)
                .multilineTextAlignment(.leading)
            Spacer()
        }
        .frame(maxWidth: .infinity)
        .padding(.horizontal, 16)
        .background(Color.Background)
        .navigationTitle("오픈소스 라이선스")
        .sheet(isPresented: self.$isTappedFirebaseButton) {
            ZStack {
                PrivacyPolicyView(webViewModel: webViewModel)
                    .environmentObject(webViewModel)
                if webViewModel.isLoading {
                    ProgressView()
                }
            }
        }
    }
}

struct LicenseView_Previews: PreviewProvider {
    static var previews: some View {
        LicenseView()
    }
}

//
//  LicenseView.swift
//  HappyAnding
//
//  Created by HanGyeongjun on 2022/11/07.
//

import SwiftUI

struct LicenseView: View {
    
    var body: some View {
        ScrollView {
            LicenseCell(title: "[Firebase](https://github.com/firebase)", text: "License\nThe contents of this repository are licensed under the Apache License, version 2.0.\nYour use of Firebase is governed by the Terms of Service for Firebase Services.")
            LicenseCell(title: "Apache License 2.0", text: readTextFile("apache.txt"))
        }
        .background(Color.Background)
    }
}

struct LicenseCell: View {
    
    @ObservedObject var webViewModel = WebViewModel()
    
    @State private var isTappedFirebaseButton = false
    var title: String
    var text: String
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(.init(title))
                .Title2()
                .foregroundColor(Color.Gray5)
                .multilineTextAlignment(.leading)
                .padding(.top, 36)
                .tint(.Gray5)
            
            Text(text)
                .Body2()
                .foregroundColor(Color.Gray4)
                .multilineTextAlignment(.leading)
            Spacer()
        }
        .frame(maxWidth: .infinity)
        .padding(.horizontal, 16)
        .navigationTitle("오픈소스 라이선스")
    }
}

extension LicenseView {
    func readTextFile(_ name: String) -> String {
        var result = ""
        let path = Bundle.main.path(forResource: "\(name)", ofType: nil)
        guard path != nil else { return "" }
        
        do {
            result = try String(contentsOfFile: path!, encoding: .utf8)
        } catch let error as NSError {
            print("catch :: ", error.localizedDescription)
            return ""
        }
        return result
    }
}

struct LicenseView_Previews: PreviewProvider {
    static var previews: some View {
        LicenseView()
    }
}

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
            LicenseCell(title: "[Firebase](https://github.com/firebase)", text: readTextFile("apache.txt"))
            LicenseCell(title: "[Wrapping HStack](https://github.com/dkk/WrappingHStack)", text: readTextFile("wrappinghstack+license.txt"))
        }
        .background(Color.shortcutsZipBackground)
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
                .shortcutsZipTitle2()
                .foregroundStyle(Color.gray5)
                .multilineTextAlignment(.leading)
                .padding(.top, 36)
                .tint(.gray5)
            
            Text(text)
                .shortcutsZipBody2()
                .foregroundStyle(Color.gray4)
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

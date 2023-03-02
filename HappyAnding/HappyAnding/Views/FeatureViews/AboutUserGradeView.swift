//
//  AboutUserGradeView.swift
//  HappyAnding
//
//  Created by HanGyeongjun on 2023/03/02.
//

import SwiftUI

struct AboutUserGradeView: View {
        
    var body: some View {
        ScrollView {
            VStack(spacing: 32) {
                MyGrade
                ExplainGrade
            }
        }
        .background(Color.shortcutsZipBackground)
        .toolbar(.automatic, for: .automatic)
    }
    
    var MyGrade: some View {
        Text("hello")
    }
    
    var ExplainGrade: some View {
        Text("world")
    }
}

//struct AboutUserGradeView_Previews: PreviewProvider {
//    static var previews: some View {
//        AboutUserGradeView()
//    }
//}

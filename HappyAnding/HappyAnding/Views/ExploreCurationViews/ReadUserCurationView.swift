//
//  ReadUserCurationView.swift
//  HappyAnding
//
//  Created by HanGyeongjun on 2022/10/22.
//

import SwiftUI

struct ReadUserCurationView: View {
    let nickName: String
    
    var body: some View {
        Text("Hello, World!")
    }
    
    var userInformation: some View {
        ZStack {
            
            HStack {
                Image(systemName: "person.fill")
                    .frame(width: 28, height: 28)
                    .foregroundColor(.White)
                    .background(Color.Gray3)
                    .clipShape(Circle())
                
                Text(nickName)
                    .Headline()
                    .foregroundColor(.Gray4)
                
                Spacer()
                Image(systemName: "light.beacon.max.fill")
                    .Headline()
                    .foregroundColor(.Gray5)
                    .onTapGesture {
                        
                        // TODO: 신고기능 연결
                        
                        print("Tapped!")
                    }
            }
            .padding(.horizontal, 30)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .frame(height: 48)
                    .padding(.horizontal, 16)
                    .foregroundColor(.Gray1)
            )
        }
    }
}

struct ReadUserCurationView_Previews: PreviewProvider {
    static var previews: some View {
        ReadUserCurationView()
    }
}

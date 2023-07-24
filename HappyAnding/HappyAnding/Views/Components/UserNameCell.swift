//
//  UserNameCell.swift
//  HappyAnding
//
//  Created by 전지민 on 2023/05/10.
//

import SwiftUI

/**
 작성자 셀을 재사용하기 위한 뷰입니다.
 
 사용자 정보를 전달해주세요. 클릭시 사용자 프로필 뷰로 이동합니다.
 
 - parameters:
 - userInformation : 뷰모델에서 fetchUser 로 불러온 결과값 User를 전달해주세요
 - gradeImage : 뷰모델에서 fetchShortcutGradeImage로 불러온 결과값 Image를 전달해주세요
 
 - description:
 - 해당 뷰는 넓이가 부모 프레임에 꽉차도록 만들어졌습니다. 여백이 필요한 경우 부모프레임 또는 해당 뷰를 불러온 후 설정해주세요.
 
 */
struct UserNameCell: View {
    var userInformation: User
    var gradeImage: Image
    
    var body: some View {
        HStack {
            gradeImage
                .font(.system(size: 24, weight: .medium))
                .frame(width: 24, height: 24)
                .foregroundColor(.gray3)
            
            if !userInformation.nickname.isEmpty {
                Text(userInformation.nickname)
                    .shortcutsZipBody2()
                    .foregroundColor(.gray4)
            } else {
                Text(TextLiteral.withdrawnUser)
                    .shortcutsZipBody2()
                    .foregroundColor(.gray4)
            }
            
            Spacer()
            
            if !userInformation.id.isEmpty {
                Image(systemName: "chevron.right")
                    .shortcutsZipFootnote()
                    .foregroundColor(.gray4)
            }
            
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 10)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .foregroundColor(.gray1)
        )
        .navigationLinkRouter(data: self.userInformation)
        .disabled(self.userInformation.id.isEmpty)
    }
}

struct UserNameCell_Previews: PreviewProvider {
    static var previews: some View {
        UserNameCell(userInformation: User(), gradeImage: Image(systemName: "person.crop.circle.fill"))
    }
}

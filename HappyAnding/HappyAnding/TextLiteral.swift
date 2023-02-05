//
//  TextLiteral.swift
//  HappyAnding
//
//  Created by kimjimin on 2023/01/29.
//

import Foundation

enum TextLiteral {
    
    // MARK: - AnyWhere
    static let more: String = "더보기"
    static let loginTitle: String = "로그인을 먼저 진행해주세요"
    static let loginMessage: String = "이 기능은 로그인 후 사용할 수 있는 기능이에요"
    static let loginAction: String = "로그인하기"
    static let cancel: String = "취소"
    static let next: String = "다음"
    static let upload: String = "업로드"
    static let close: String = "닫기"
    static let done: String = "완료"
    static let edit: String = "편집"
    static let update: String = "업데이트"
    static let share: String = "공유"
    static let delete: String = "삭제"
    static let withdrawnUser: String = "탈퇴한 사용자"
    static let defaultUser: String = "user"
    
    // MARK: - ExploreShortcutView
    static let exploreShortcutViewTitle: String = "단축어 둘러보기"
    
    // MARK: - RecentRegisteredView
    static let recentRegisteredViewTitle: String = "최신 단축어"
    
    // MARK: - LovedShortcutView
    static let lovedShortcutViewTitle: String = "사랑받는 단축어"
    
    // MARK: - DownloadRankView
    static let downloadRankViewTitle: String = "다운로드 순위"
    
    // MARK: - CategoryView
    static let categoryViewTitle: String = "카테고리 모아보기"
    static let categoryViewUnfold: String = "펼치기"
    static let categoryViewFold: String = "접기"
    
    // MARK: - MyShortcutCardListView
    static let myShortcutCardListViewTitle: String = "내가 작성한 단축어"
    
    // MARK: - ValidationCheckTextField
    static let validationCheckTextFieldInvalid: String = "단축어 링크가 아니에요"
    static let validationCheckTextFieldExcess: String = "입력할 수 있는 문자 수를 초과했어요"
    static let validationCheckTextFieldOption: String = "(선택입력)"
    static let validationCheckTextFieldPrefix: String = "https://www.icloud.com/shortcuts/"
    
    // MARK: - UserCurationListView
    static let userCurationListViewAdd: String = "추천 모음집 작성"
    
    // MARK: - NicknameTextField
    static let nicknameTextFieldLength: String = "최대 8자까지 입력할 수 있어요"
    static let nicknameTextFieldEmoticon: String = "사용할 수 없는 문자가 포함되어 있어요"
    static let nicknameTextFieldSpace: String = "공백 없이 한글 ,숫자, 영문만 입력할 수 있어요"
    static let nicknameTextFieldDuplicateTitle: String = "닉네임 중복 확인"
    static let nicknameTextFieldDuplicateSuccessMessage: String = "사용할 수 있는 닉네임이에요"
    static let nicknameTextFieldDuplicateFailMessage: String = "이미 사용 중인 닉네임이에요"
    static let nicknameTextFieldDuplicateSuccessLabel: String = "확인"
    static let nicknameTextFieldDuplicateFailLabel: String = "다시 입력하기"
    static let nicknameTextFieldTitle: String = "닉네임 (최대 8글자)"
    static let nicknameTextFieldDuplicateCheck: String = "중복확인"
    
    // MARK: - WriteShortcutTitleView
    static let writeShortcutTitleViewNameTitle: String = "단축어 이름"
    static let writeShortcutTitleViewNamePlaceholder: String = "단축어 이름을 입력하세요"
    static let writeShortcutTitleViewLinkTitle: String = "단축어 링크"
    static let writeShortcutTitleViewLinkPlaceholder: String = "단축어 링크를 입력하세요"
    static let writeShortcutTitleViewOneLineTitle: String = "한 줄 설명"
    static let writeShortcutTitleViewOneLinePlaceholder: String = "단축어의 핵심 기능을 입력하세요"
    static let writeShortcutTitleViewMultiLineTitle: String = "상세 설명"
    static let writeShortcutTitleViewMultiLinePlaceholder: String = "단축어 사용법, 필수적으로 요구되는 사항 등 단축어를 이용하기 위해 필요한 정보를 입력하세요"
    static let writeShortcutTitleViewEdit: String = "단축어 편집"
    static let writeShortcutTitleViewPost: String = "단축어 등록"
    static let writeShortcutTitleViewCategoryTitle: String = "카테고리"
    static let writeShortcutTitleViewCategoryDescription: String = "최대 3개"
    static let writeShortcutTitleViewCategoryCell: String = "카테고리 선택"
    static let writeShortcutTitleViewRequiredAppDescription: String = "(선택)"
    static let writeShortcutTitleViewRequiredAppsTitle: String = "단축어 사용에 필요한 앱"
    static let writeShortcutTitleViewRequiredAppInformation: String = "해당 단축어를 사용하기 위해 필수로 다운로드해야 하는 앱을 입력해주세요"
    static let writeShortcutTitleViewRequiredAppCell: String = "앱 추가"
    
    // MARK: - IconModalView
    static let iconModalViewTitle: String = "아이콘"
    static let iconModalViewColor: String = "색상"
    static let iconModalViewIcon: String = "기호"
    
    // MARK: - CategoryModalView
    static let categoryModalViewTitle: String = "카테고리"
    
    // MARK: - ReadShortcutView
    static let readShortcutViewBasicTabTitle: String = "기본 정보"
    static let readShortcutViewVersionTabTitle: String = "버전 정보"
    static let readShortcutViewCommentTabTitle: String = "댓글"
    static let readShortcutViewDeletionTitle: String = "단축어 삭제"
    static let readShortcutViewDeletionMessage: String = "단축어를 삭제하시겠어요?"
    static let readShortcutViewDeleteFixes: String = "수정사항을 삭제하시겠어요?"
    static let readShortcutViewKeepFixes: String = "계속 작성"
    static let readShortcutViewCommentDescriptionBeforeLogin: String = "로그인 후 댓글을 작성할 수 있어요"
    static let readShortcutViewCommentDescription: String = "댓글을 입력하세요"
    
    // MARK: - ReadShortcutContentView
    static let readShortcutContentViewDescription: String = "단축어 설명"
    static let readShortcutContentViewCategory: String = "카테고리"
    static let readShortcutContentViewRequiredApps: String = "단축어 사용에 필요한 앱"
    static let readShortcutContentViewRequirements: String = "단축어 사용을 위한 요구사항"
    
    // MARK: - ReadShortcutVersionView
    static let readShortcutVersionViewNoUpdates: String = "업데이트된 버전이 없어요"
    static let readShortcutVersionViewUpdateContent: String = "업데이트 내용"
    static let readShortcutVersionViewDownloadPreviousVersion: String = "이전 버전 다운로드"
    
    // MARK: - ReadShortcutCommentView
    static let readShortcutCommentViewNoComments: String = "등록된 댓글이 없어요"
    static let readShortcutCommentViewDeletionTitle: String = "댓글 삭제"
    static let readShortcutCommentViewDeletionMessage: String = "답글도 함께 삭제됩니다. 댓글을 삭제하시겠습니까?"
    static let readShortcutCommentViewReply: String = "답글"
    static let readShortcutCommentViewEdit: String = "수정"
    
    // MARK: - UpdateShortcutView
    static let updateShortcutViewLinkTitle: String = "업데이트된 단축어 링크"
    static let updateShortcutViewLinkPlaceholder: String = "업데이트된 단축어 링크를 입력하세요"
    static let updateShortcutViewDescriptionTitle: String = "업데이트 설명"
    static let updateShortcutViewDescriptionPlaceholder: String = "업데이트된 내용을 입력하세요"
    
    // MARK: - ShowProfileView
    static let showProfileViewShortcutTabTitle: String = "작성한 단축어"
    static let showProfileViewCurationTabTitle: String = "작성한 추천 모음집"
    static let showProfileViewNoShortcuts: String = "아직 단축어를 작성하지 않았어요"
    static let showProfileViewNoCurations: String = "아직 추천 모음집을 작성하지 않았어요"
    
    // MARK: - ExploreCurationView
    static let exploreCurationViewTitle: String = "추천 모음집 둘러보기"
    static let exploreCurationViewAdminCurations: String = "숏컷집 추천 모음집"
    static let exploreCurationViewUserCurations: String = "사용자 추천 모음집"
    
    // MARK: - ReadUserCurationView
    static let readUserCurationViewDeletionTitle: String = "추천 모음집 삭제"
    static let readUserCurationViewDeletionMessage: String = "추천 모음집을 삭제하시겠어요?"
    
    // MARK: - WriteCurationSetView
    static let writeCurationSetViewNoShortcuts: String = "아직 선택할 수 있는 단축어가 없어요.\n단축어를 업로드하거나 좋아요를 눌러주세요:)"
    static let writeCurationSetViewEdit: String = "추천 모음집 편집"
    static let writeCurationSetViewPost: String = "추천 모음집 작성"
    static let writeCurationSetViewSelectionTitle: String = "단축어 선택"
    static let writeCurationSetViewSelectionDescription: String = "최대 10개"
    static let writeCurationSetViewSelectionInformation: String = "추천 모음집을 위한 단축어 목록은 '내가 업로드한 단축어'와 '좋아요를 누른 단축어'로 구성되어 있어요."
    
    // MARK: - WriteCurationInfoView
    static let writeCurationInfoViewNameTitle: String = "추천 모음집 이름"
    static let writeCurationInfoViewNamePlaceholder: String = "추천 모음집의 이름을 입력하세요"
    static let writeCurationInfoViewDescriptionTitle: String = "추천 모음집 설명"
    static let writeCurationInfoViewDescriptionPlaceholder: String = "추천 모음집에 대한 설명을 입력하세요"
    static let writeCurationInfoViewEdit: String = "추천 모음집 편집"
    static let wrietCurationInfoViewPost: String = "추천 모음집 작성"
    
    // MARK: - WithdrawalView
    static let withdrawalViewTitle: String = "탈퇴하기"
    static let withdrawalViewDeleteTitle: String = "탈퇴 시 삭제되는 항목"
    static let withdrawalViewDeleteContent: String = "로그인 정보 / 닉네임 / 좋아요한 단축어 목록 / 다운로드한 단축어 목록"
    static let withdrawalViewNoDeleteTitle: String = "탈퇴 시 삭제되지 않는 항목"
    static let withdrawalViewNoDeleteContent: String = "작성한 단축어 / 작성한 추천 모음집"
    static let withdrawalViewHeadline: String = "ShortcutsZip에서 탈퇴 시 다음과 같이 사용자 데이터가 처리됩니다."
    static let withdrawalViewAgree: String = "위의 데이터 처리방법에 동의합니다."
    static let withdrawalViewButton: String = "사용자 재인증 후 탈퇴하기"
    static let withdrawalViewAlertTitle: String = "탈퇴하기"
    static let withdrawalViewAlertMessage: String = "ShortcutsZip에서 탈퇴하시겠습니까?"
    static let withdrawalViewAlertAction: String = "탈퇴"
    
    // MARK: - SettingView
    static let settingViewVersion: String = "버전 정보"
    static let settingViewVersionNumber: String = "1.1.0"
    static let settingViewOpensourceLicense: String = "오픈소스 라이선스"
    static let settingViewPrivacyPolicy: String = "개인정보 처리방침"
    static let settingViewPrivacyPolicyURL: String = "https://noble-satellite-574.notion.site/60d8fa2f417c40cca35e9c784f74b7fd"
    static let settingViewContact: String = "개발자에게 메일 보내기"
    static let settingViewContactMessage: String = "문의사항은 shortcutszip@gmail.com 으로 메일 보내주세요"
    static let settingViewLogin: String = "로그인"
    static let settingViewLogout: String = "로그아웃"
    static let settingViewLogoutMessage: String = "로그아웃 하시겠습니까?"
    static let settingViewWithdrawal: String = "탈퇴하기"
    
    // MARK: - MyPageView
    static let myPageViewTitle: String = "프로필"
    static let myPageViewMyCuration: String = "내가 작성한 추천 모음집"
    static let myPageViewLikedShortcuts: String = "좋아요한 단축어"
    static let myPageViewDownloadedShortcuts: String = "다운로드한 단축어"
    
    // MARK: - MailView
    static let mailViewReceiver: String = "shortcutszip@gmail.com"
    static let mailViewSubject: String = "🎤 ShortcutsZip 개발자에게 문의드립니다"
    
    // MARK: - EditNicknameView
    static let editNicknameViewTitle: String = "닉네임 수정"
    static let editNicknameViewHeadline: String = "닉네임을 수정해주세요"
    
    // MARK: - WriteNicknameView
    static let writeNicknameViewHeadline: String = "닉네임을 입력해주세요"
    static let writeNicknameViewStart: String = "시작하기"
    
    // MARK: - SearchView
    static let searchViewPrompt: String = "제목 또는 관련앱으로 검색하세요"
    static let searchViewRecommendedKeyword: String = "추천 검색어"
    static let searchViewProposal: String = "단축어 제안하기"
    static let searchViewProposalURL: String = "https://docs.google.com/forms/d/e/1FAIpQLScQc3KeYjDGCE-C2YRU-Hwy2XNy5bt89KVX1OMUzRiySaMX1Q/viewform"
}

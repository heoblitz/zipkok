# 나홀로 집콕

> 집에 머무르는 시간을 체크하는 챌린지형 서비스입니다.

![](images/header.jpeg)

## 사용 프레임 워크 및 라이브러리
- UIKit
- Alamofire (~ 네트워크 처리)
- KakaoSDK (~ 카카오톡 로그인 및 링크)
- FireBase (~ notification 및 크래시 로그 분석)
- MBCircularProgressBar (~ 타이머 progress bar)
- SwiftKeychainWrapper (~ KeyChain Manager)
<br>
<br>

## 아키텍처
MVVM + Observable 사용하여 데이터 바인딩 (not use RxSwift)
<br>
<br>
<br>

# 문제 해결

## 앱 초기 화면 설정
- 문제점
    - 유저 상태에 따라서 초기에 보여질 화면이 다른 상황
    - (신규 유저, 회원 가입 된 상태, 챌린지 진행 중)
    - 각각 (회원가입, 홈 화면, 챌린지 화면) 으로 분기처리 해야하는 로직

- 해결 방법
    - SceneDelegate 에서 서버 요청 값에 따라 window 를 설정함
    - 특히 여러 Depth 로 들어가야 하는 챌린지 화면의 경우
    - navigation 에 필요한 컨트롤러들을 먼저 Push 하여 해결할 수 있었음
<br>
<br>

## 타이머 애니메이션
- 문제점
    - 앱이 background 로 전환되거나, 타이머가 다른 VC 로 가려질 때
    - 애니메이션이 모두 처리되는 문제점이 발생함

- 해결 방법
    - 앱이 InActive 그리고 ViewDidAppear 되는 시점에 애니메이션을 정지하고
    - ViewDidAppear 됬을 때 다시 애니메이션을 처리하는 로직을 구성함
    - percent 만큼 progressView 를 조정 -> 남은 시간 만큼 애니메이션


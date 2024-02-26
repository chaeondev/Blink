<p>
  <img width="100" alt="image" src="https://github.com/chaeondev/Blink/assets/80023607/cf3a2161-422f-462c-8d6b-29c1ff47b771">
</p>

# Blink

#### 사용자 간 팀 커뮤니케이션이 가능한 메신저 앱입니다.

## Preview

<img width="1000" alt="image" src="https://github.com/chaeondev/Blink/assets/80023607/9fd7c6c4-13da-46e2-a7fd-f3f88cee6387">


[📱 상세 UI 보러가기](https://github.com/chaeondev/Blink#ui) 


## 프로젝트 소개

> 앱 소개
- 소셜로그인(애플, 카카오), 이메일 로그인 기능 제공
- 워크스페이스, 채널 CRUD 기능
- 채널, DM에서 실시간 채팅 제공 (텍스트, 이미지 송수신 가능)
- 채팅방 알림(Remote Push) 실시간 수신
- 앱 내 인앱결제를 통한 코인 충전 가능

---

> 서비스
- **개발인원** : 1인 개발
- **개발기간** : 2024.01.03 - 2024.02.22 (7주)
- **협업툴** : Git, Figma, Confluence, Swagger
- **iOS Deployment Target** : iOS 16.0

---

> 기술스택
- **프레임워크** : UIKit, WebKit
- **디자인패턴** : MVVM, Input/Output, Singleton, Repository
- **라이브러리** :
  - RxSwift, SocketIO, Alamofire, Realm, Kingfisher,  
  - iamport, Firebase(Cloud Messaging), RxKakaoOpenSDK  
  - SideMenu, Toast, SnapKit, IQKeyboardManager  
- **의존성관리** : Swift Package Manager
- **ETC** : CodabaseUI, CompositionalLayout, PHPicker, UIImagePicker, PropertyWrapper, KeyChain

---

> 주요기능

- **RxKakaoSDK**(카카오), **AuthenticationServices**(애플)을 통해 **소셜 로그인** 제공
- **First Responder**, Toast Message를 활용해 **RxSwift** 기반 **반응형** 회원가입 로직 구현
- 섹션 별 계층적 구조 데이터 기반 홈화면 **Expandable Section(토글)** TableView UI 구현
- **Dispatch Group**을 활용하여 비동기 네트워크 호출의 순차적 실행을 보장
- **SocketIO**를 활용하여 양방향 **실시간** 통신 기반 다인원 **채팅** 시스템 구현
- 과거 채팅 내역을 **Realm DB**에 저장하여, **네트워크 요청 최소화**
- **Compositional Layout**을 사용하여 이미지 개수에 기반한 **동적인 채팅 레이아웃** 조정
- **Firebase Cloud Messaging**을 통해 실시간으로 채팅 **Remote Push Notification** 수신
- **포트원**을 연동하여 WebView 기반 **인앱 결제** 구현, 결제 영수증 검증을 통한 서버 유효성 확인 및 코인 반영
- **RxSwift**를 활용하여 **MVVM** 아키텍처 내에서 **Input/Output** 패턴을 구현
- **Alamofire**의 **URLRequestConvertible**을 통해 **Router** 패턴으로 네트워크 요청 추상화 및 모듈화



[📱 상세 UI 보러가기](https://github.com/chaeondev/Blink#ui)

---

<br> </br>

## 트러블 슈팅



## UI

#### ✔︎ 회원가입, 로그인  

<img width="1000" alt="image" src="https://github.com/chaeondev/Blink/assets/80023607/a37cb6a8-b156-49fa-82fc-92680f37b4c0">

#### ✔︎ 워크스페이스

<img width="1000" alt="image" src="https://github.com/chaeondev/Blink/assets/80023607/b240d41c-cb96-4385-9775-4ca42b37521d">


#### ✔︎ 채널, DM

<img width="1000" alt="image" src="https://github.com/chaeondev/Blink/assets/80023607/5b6a2c40-bebb-4bd9-8655-d3c2cc9bf034">


#### ✔︎ 프로필, 인앱결제, Push Notification

<img width="1000" alt="image" src="https://github.com/chaeondev/Blink/assets/80023607/6dbd1c38-c6fb-4666-98f3-ffb6803a4034">




<div align=right> 
 
 [Preview로 돌아가기](https://github.com/chaeondev/Blink#preview)
 
</div>

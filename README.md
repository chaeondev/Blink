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
- 홈 화면에서 **계층적 데이터 구조**를 기반으로 **Expandable Section** TableView UI를 구현
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

### 1. 화면 내 다수의 비동기 네트워크 콜에서 발생하는 순서 의존성 에러

#### Issue
홈화면에 채팅 목록과 안읽은 메세지 개수를 데이터로 요청해야 했습니다. 
**여러 번의 네트워크 통신이 순차적**으로 일어나야 했는데, 네트워크 통신은 **비동기 작업**으로 수행되기 때문에 작업 완료 시점을 체크하기 힘들었습니다.
이로 인해 채팅 목록 또는 안읽은 메세지 개수 데이터가 누락된 채로 뷰가 보여지는 문제가 발생했습니다.

#### Solution
completionHandler와 **DispatchGroup**을 이용해 작업 완료 시점을 체크할 수 있었습니다.
안읽은 메세지 개수 네트워크 통신의 경우 여러 번의 비동기 작업을 그룹화하고, 완료 시점을 **notify**로 체크했습니다.
이후 해당 시점에 completion()을 통해 원하는 작업을 원하는 시점에 할 수 있도록 구현했습니다.

```swift
//HomeDefaultViewModel

func fetchDMInfo(completion: @escaping () -> Void) {
    APIService.shared.requestCompletion(type: [DMsRoomRes].self, api: DMSRouter.checkDMRooms(self.workspaceID)) { [weak self] result in
        switch result {
        case .success(let response):
            print("===DM 정보 조회 성공 ===")
            self?.dmData = HomeDMsData(
                opened: true,
                sectionData: response.map {
                    HomeDMsData.DMCellInfo(dmInfo: $0, unreadDMCnt: 10)
                }
            )
            self?.fetchDMsUnreadCount {
                completion()
            }
            
        case .failure(let error):
            print("===DM 정보 조회 실패 ===", error)
        }
    }
}

func fetchDMsUnreadCount(completion: @escaping () -> Void) {
  guard let dmData else { return }
  
  let group = DispatchGroup()
  
  for (index, item) in dmData.sectionData.enumerated() {
      let requestModel = DMsUnreadCountRequest(
          roomID: item.dmInfo.room_id,
          workspaceID: self.workspaceID,
          after: item.dmInfo.createdAt)
      
      group.enter()
      APIService.shared.requestCompletion(type: DMsUnreadCountResponse.self, api: DMSRouter.dmsUnreadCount(requestModel)) { [weak self] result in
          switch result {
          case .success(let response):
              print("===\(response.room_id) 방 DM개수: \(response.count) 네트워크 성공===")
              self?.dmData!.sectionData[index].unreadDMCnt = response.count

          case .failure(let error):
              print("===DM 읽지 않은 채팅 개수 네트워크 실패===")
              print("===DM방 정보: \(String(describing: self?.dmData?.sectionData[index].dmInfo))")
              print("===에러: \(error)===")
          }
          
          group.leave()
      }
  }
  
  group.notify(queue: .main) {
      completion()
  }
}
```

<br> </br>

### 2. 소켓 통신 연결 해제 시점 이슈

#### Issue
실시간 채팅을 구현하기 위해 소켓을 연결해야 했고, 소켓 연결과 해제 시점이 중요했습니다.
view에 들어갈 때 뷰를 구현하면서 소켓을 연결시켰고, 화면을 나가는 경우 viewDidDissapear에서 해제를 했지만, **채팅 화면에서 앱을 종료시키는 경우 소켓이 종료되지 않는 문제**가 발생했습니다.

#### Solution
`ChattingViewController`에서는 **deinit** 시점에 한번 더 소켓의 해제 여부를 체크했습니다.
또한 `SceneDelegate`에서 **백그라운드** 시점 또는 **Scene이 종료** 되었을 때 소켓 연결을 해제함으로써 리소스를 최적화하였습니다.

```swift
//ChattingViewController

override func viewDidDisappear(_ animated: Bool) {
    super.viewDidDisappear(animated)
    
    print(#function)
    viewModel.disconnectSocket()
}

deinit {
    viewModel.disconnectSocket()
    print("===========채널 채팅뷰 DEINIT============")
}
```

```swift
//SceneDelegate

func sceneDidDisconnect(_ scene: UIScene) {
    if SocketIOManager.shared.isOpen {
        SocketIOManager.shared.closeConnection()
    }
}

func sceneDidBecomeActive(_ scene: UIScene) {
    SocketIOManager.shared.reconnect()
}

func sceneDidEnterBackground(_ scene: UIScene) {
    SocketIOManager.shared.pauseConnect()
}
```


<br> </br>

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

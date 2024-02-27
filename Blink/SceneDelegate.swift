//
//  SceneDelegate.swift
//  Blink
//
//  Created by Chaewon on 1/2/24.
//

import UIKit
import RxKakaoSDKAuth
import KakaoSDKAuth
import iamport_ios

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let scene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: scene)
        window?.rootViewController = SplashViewController()
//        window?.rootViewController = OnboardingViewController()
        window?.makeKeyAndVisible()
    }
    
    func changeRootViewController(_ vc: UIViewController, animated: Bool = true) {
        guard let window = self.window else {
            return
        }
        window.rootViewController = vc
        
        UIView.transition(with: window, duration: 0.5, options: [.transitionFlipFromLeft], animations: nil, completion: nil)
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        if SocketIOManager.shared.isOpen {
            SocketIOManager.shared.closeConnection()
        }
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        SocketIOManager.shared.reconnect()
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        SocketIOManager.shared.pauseConnect()
    }


}

//카카오 로그인
extension SceneDelegate {
    
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        //카카오 로그인
        if let url = URLContexts.first?.url {
            if (AuthApi.isKakaoTalkLoginUrl(url)) {
                _ = AuthController.rx.handleOpenUrl(url: url)
            }
        }
        
        //코인 결제
        if let url = URLContexts.first?.url {
            Iamport.shared.receivedURL(url)
        }
        
    }
}

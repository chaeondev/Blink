//
//  SwitchViewController.swift
//  Blink
//
//  Created by Chaewon on 1/16/24.
//

import UIKit

final class SwitchViewController: BaseViewController {
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(setTabBarController())
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    
    private func setTabBarController() -> UITabBarController {

        let tabBar = UITabBarController()
        
        // TODO: 나중에 empty랑 분기처리로 나누기
        let homeVC = UINavigationController(rootViewController: HomeDefaultViewController())
        homeVC.tabBarItem = UITabBarItem(title: "홈", image: .home, selectedImage: .homeActive)
        
        let dmVC = UINavigationController(rootViewController: DMViewController())
        dmVC.tabBarItem = UITabBarItem(title: "DM", image: .message, selectedImage: .messageActive)
        
        let searchVC = UINavigationController(rootViewController: SearchViewController())
        searchVC.tabBarItem = UITabBarItem(title: "검색", image: .profile, selectedImage: .profileActive)
        
        let settingVC = UINavigationController(rootViewController: SettingViewController())
        settingVC.tabBarItem = UITabBarItem(title: "설정", image: .setting, selectedImage: .settingActive)
        
        tabBar.viewControllers = [homeVC, dmVC, searchVC, settingVC]
        
        return tabBar
    }
}

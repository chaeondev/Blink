//
//  HomeTabViewController.swift
//  Blink
//
//  Created by Chaewon on 1/17/24.
//

import UIKit

class HomeTabViewController: UITabBarController {
    
    let homeVC = UINavigationController(rootViewController: HomeDefaultViewController())
    let dmVC = UINavigationController(rootViewController: DMViewController())
    let searchVC = UINavigationController(rootViewController: SearchViewController())
    let settingVC = UINavigationController(rootViewController: SettingViewController())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        homeVC.tabBarItem = UITabBarItem(title: "홈", image: .home, selectedImage: .homeActive)
        dmVC.tabBarItem = UITabBarItem(title: "DM", image: .message, selectedImage: .messageActive)
        searchVC.tabBarItem = UITabBarItem(title: "검색", image: .profile, selectedImage: .profileActive)
        settingVC.tabBarItem = UITabBarItem(title: "설정", image: .setting, selectedImage: .settingActive)
        
        let tabItems = [homeVC, dmVC, searchVC, settingVC]
        
        self.viewControllers = tabItems
        setViewControllers(tabItems, animated: true)
    }
    
    
}

//
//  HomeTabViewController.swift
//  Blink
//
//  Created by Chaewon on 1/17/24.
//

import UIKit

class HomeTabViewController: UITabBarController {
    
    //HomeDefaultVC
    var workspaceID: Int = 0 {
        didSet {
            homeVC.viewModel.workspaceID = workspaceID
            dmVC.viewModel.workspaceID = workspaceID
        }
    }
    
    let homeVC = HomeDefaultViewController()
    let dmVC = DMListViewController()
    let searchVC = SearchViewController()
    let settingVC = MyProfileViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //값 전달
        homeVC.viewModel.workspaceID = workspaceID
        dmVC.viewModel.workspaceID = workspaceID
        
        let homeNav = UINavigationController(rootViewController: homeVC)
        let dmNav = UINavigationController(rootViewController: dmVC)
        let searchNav = UINavigationController(rootViewController: searchVC)
        let settingNav = UINavigationController(rootViewController: settingVC)
        
        homeNav.tabBarItem = UITabBarItem(title: "홈", image: .home, selectedImage: .homeActive)
        dmNav.tabBarItem = UITabBarItem(title: "DM", image: .message, selectedImage: .messageActive)
        searchNav.tabBarItem = UITabBarItem(title: "검색", image: .profile, selectedImage: .profileActive)
        settingNav.tabBarItem = UITabBarItem(title: "설정", image: .setting, selectedImage: .settingActive)
        
        let tabItems = [homeNav, dmNav, searchNav, settingNav]
        
        self.viewControllers = tabItems
        setViewControllers(tabItems, animated: true)
    }
    
    
}

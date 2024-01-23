//
//  InviteMemberViewController.swift
//  Blink
//
//  Created by Chaewon on 1/23/24.
//

import UIKit
import RxSwift
import RxCocoa

final class InviteMemberViewController: BaseViewController {
    
    private let mainView = InviteMemberView()
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavigation(title: "팀원 초대")
    }
    
    private func bind() {
        
    }
    
}

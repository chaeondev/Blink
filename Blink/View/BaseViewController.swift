//
//  BaseViewController.swift
//  Blink
//
//  Created by Chaewon on 1/2/24.
//

import UIKit
import SnapKit
import Toast

class BaseViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setHierarchy()
        setConstraints()
        setToastMessage()
    }
    
    func setHierarchy() {
        
    }
    
    func setConstraints() {
        view.backgroundColor = .backgroundPrimary
    }
    
    func setToastMessage() {
        var style = ToastStyle()
        style.backgroundColor = .brandGreen
        style.messageFont = .customFont(.body)
        style.messageAlignment = .center
        ToastManager.shared.style = style
    }
}

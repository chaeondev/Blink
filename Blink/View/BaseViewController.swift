//
//  BaseViewController.swift
//  Blink
//
//  Created by Chaewon on 1/2/24.
//

import UIKit
import SnapKit

class BaseViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setHierarchy()
        setConstraints()
    }
    
    func setHierarchy() {
        
    }
    
    func setConstraints() {
        view.backgroundColor = .backgroundPrimary
    }
}

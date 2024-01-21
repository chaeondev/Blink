//
//  OneAlertViewController.swift
//  Blink
//
//  Created by Chaewon on 1/19/24.
//

import UIKit

final class OneAlertViewController: BaseViewController {
    let backView = {
        let view = UIView()
        view.backgroundColor = .brandWhite
        view.layer.cornerRadius = 16
        view.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
        return view
    }()
    
    lazy var titleLabel = UILabel.labelBuilder(text: "워크스페이스 나가기", font: .title2, textColor: .textPrimary, textAlignment: .center)
    
    lazy var messageLabel = UILabel.labelBuilder(text: "회원님은 워크스페이스 관리자입니다. 워크스페이스 관리자를 다른 멤버로 변경한 후 나갈 수 있습니다.", font: .body, textColor: .textSecondary, numberOfLines: 0, textAlignment: .center)
    
    lazy var okButton = {
        let view = RoundedButton(title: "확인")
        view.addTarget(self, action: #selector(okButtonClicked), for: .touchUpInside)
        return view
    }()
    
    var completion: (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func setUp(title: String, message: String, completion: @escaping () -> Void) {
        titleLabel.text = title
        messageLabel.text = message
        self.completion = completion
    }
    
    @objc func okButtonClicked() {
        completion?()
    }
    
    override func setHierarchy() {
        super.setHierarchy()
        
        view.addSubview(backView)
        [titleLabel, messageLabel, okButton].forEach { backView.addSubview($0) }
        
    }
    
    override func setConstraints() {
        super.setConstraints()
        
        backView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.horizontalEdges.equalToSuperview().inset(25)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(16.5)
            make.top.equalToSuperview().offset(16)
            make.height.equalTo(20)
        }
        
        messageLabel.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(16.5)
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
        }
        
        okButton.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(16)
            make.bottom.equalToSuperview().inset(16)
            make.top.equalTo(messageLabel.snp.bottom).offset(16)
            make.height.equalTo(44)
        }
    }

    override func setting() {
        super.setting()
        
        view.backgroundColor = .alpha
    }
}

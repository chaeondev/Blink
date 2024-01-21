//
//  TwoAlertViewController.swift
//  Blink
//
//  Created by Chaewon on 1/19/24.
//

import UIKit

final class TwoAlertViewController: BaseViewController {
    let backView = {
        let view = UIView()
        view.backgroundColor = .brandWhite
        view.layer.cornerRadius = 16
        view.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
        return view
    }()
    
    lazy var titleLabel = UILabel.labelBuilder(text: "워크스페이스 삭제", font: .title2, textColor: .textPrimary, textAlignment: .center)
    
    lazy var messageLabel = UILabel.labelBuilder(text: "정말 이 워크스페이스를 삭제하시겠습니까? 삭제 시 채널/멤버/채팅 등 워크스페이스 내의 모든 정보가 삭제되며 복구할 수 없습니다.", font: .body, textColor: .textSecondary, numberOfLines: 0, textAlignment: .center)
    
    lazy var cancelButton = {
        let view = RoundedButton(title: "취소", backgroundColor: .brandInactive)
        view.addTarget(self, action: #selector(cancelButtonClicked), for: .touchUpInside)
        return view
    }()
    
    lazy var doButton = {
        let view = RoundedButton(title: "삭제")
        view.addTarget(self, action: #selector(doButtonClicked), for: .touchUpInside)
        return view
    }()
    
    var cancelCompletion: (() -> Void)?
    var doCompletion: (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func setUp(
        title: String,
        message: String,
        doCompletion: @escaping () -> Void,
        cancelCompletion: @escaping () -> Void
    ) {
        titleLabel.text = title
        messageLabel.text = message
        self.cancelCompletion = cancelCompletion
        self.doCompletion = doCompletion
    }
    
    @objc func cancelButtonClicked() {
        cancelCompletion?()
    }
    
    @objc func doButtonClicked() {
        doCompletion?()
    }
    
    override func setHierarchy() {
        super.setHierarchy()
        
        view.addSubview(backView)
        [titleLabel, messageLabel, cancelButton, doButton].forEach { backView.addSubview($0) }
        
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
        
        cancelButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.top.equalTo(messageLabel.snp.bottom).offset(16)
            make.width.equalTo(152)
            make.height.equalTo(44)
            make.bottom.equalToSuperview().inset(16)
        }
        
        doButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-16)
            make.top.equalTo(messageLabel.snp.bottom).offset(16)
            make.width.equalTo(152)
            make.height.equalTo(44)
            make.bottom.equalToSuperview().inset(16)
        }
    }

    override func setting() {
        super.setting()
        
        view.backgroundColor = .alpha
    }
}

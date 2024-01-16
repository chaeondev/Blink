//
//  AddView.swift
//  Blink
//
//  Created by Chaewon on 1/11/24.
//

import UIKit

class WSAddView: BaseView {
    
    let profileButton = {
        let view = UIButton()
        view.setImage(.workspace, for: .normal)
        view.imageEdgeInsets = UIEdgeInsets(top: 10, left: 11, bottom: 0, right: 11)
        view.contentMode = .scaleAspectFit
        view.backgroundColor = .brandGreen
        view.layer.cornerRadius = 8
        view.clipsToBounds = true
        return view
    }()
    
    let cameraImageView = {
        let view = UIImageView()
        view.image = .camera
        view.contentMode = .scaleAspectFill
        return view
    }()
    
    let titleLabel = BTitleLabel(title: "워크스페이스 이름")
    let titleTextField = BTextField(placeholder: "워크스페이스 이름을 입력하세요 (필수)")
    let infoLabel = BTitleLabel(title: "워크스페이스 설명")
    let infoTextField = BTextField(placeholder: "워크스페이스를 설명하세요 (옵션)")
    let doneButton = RoundedButton(title: "완료")
    
    override func setHierarchy() {
        super.setHierarchy()
        [
            profileButton,
            cameraImageView,
            titleLabel,
            titleTextField,
            infoLabel,
            infoTextField,
            doneButton
        ].forEach { self.addSubview($0) }
    }
    
    override func setConstraints() {
        super.setConstraints()
        
        profileButton.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide).offset(24)
            make.centerX.equalToSuperview()
            make.size.equalTo(70)
        }
        
        cameraImageView.snp.makeConstraints { make in
            make.top.equalTo(profileButton).offset(51)
            make.leading.equalTo(profileButton).offset(53)
            make.size.equalTo(24)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(profileButton.snp.bottom).offset(16)
            make.horizontalEdges.equalToSuperview().inset(24)
            make.height.equalTo(24)
        }
        
        titleTextField.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.horizontalEdges.equalToSuperview().inset(24)
            make.height.equalTo(44)
        }
        
        infoLabel.snp.makeConstraints { make in
            make.top.equalTo(titleTextField.snp.bottom).offset(24)
            make.horizontalEdges.equalToSuperview().inset(24)
            make.height.equalTo(24)
        }
        
        infoTextField.snp.makeConstraints { make in
            make.top.equalTo(infoLabel.snp.bottom).offset(8)
            make.horizontalEdges.equalToSuperview().inset(24)
            make.height.equalTo(44)
        }
        
        doneButton.snp.makeConstraints { make in
            make.bottom.equalTo(self.keyboardLayoutGuide.snp.top).offset(-12)
            make.horizontalEdges.equalToSuperview().inset(24)
            make.height.equalTo(44)
        }
        
    }
}

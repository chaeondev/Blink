//
//  SplashView.swift
//  Blink
//
//  Created by Chaewon on 1/19/24.
//

import UIKit

class SplashView: BaseView {
    
    let introduceLabel = {
        let view = UILabel.labelBuilder(text: "새싹톡을 사용하면 어디서나\n팀을 모을 수 있습니다", font: .title1, textColor: .brandBlack, numberOfLines: 0, textAlignment: .center)
        view.lineBreakMode = .byWordWrapping
        return view
    }()
    
    let onboardingImageView = {
        let view = UIImageView()
        view.image = .onboarding
        view.contentMode = .scaleAspectFill
        return view
    }()
    
    override func setHierarchy() {
        self.addSubview(introduceLabel)
        self.addSubview(onboardingImageView)
    }
    
    override func setConstraints() {
        introduceLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(93)
            make.centerX.equalToSuperview()
            make.width.equalTo(345)
            make.height.equalTo(60)
        }
        
        onboardingImageView.snp.makeConstraints { make in
            make.top.equalTo(introduceLabel.snp.bottom).offset(89)
            make.size.equalTo(368)
            make.centerX.equalToSuperview()
        }
    }
}

//
//  OnboardingViewController.swift
//  Blink
//
//  Created by Chaewon on 1/2/24.
//

import UIKit

final class OnboardingViewController: BaseViewController {
    
    private lazy var introduceLabel = {
        let view = UILabel.labelBuilder(text: "새싹톡을 사용하면 어디서나\n팀을 모을 수 있습니다", font: .title1, textColor: .brandBlack, numberOfLines: 0, textAlignment: .center)
        view.lineBreakMode = .byWordWrapping
        return view
    }()
    
    private lazy var onboardingImageView = {
        let view = UIImageView()
        view.image = .onboarding
        view.contentMode = .scaleAspectFill
        return view
    }()
    
    private lazy var startButton = RoundedButton(title: "시작하기")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func setHierarchy() {
        view.addSubview(introduceLabel)
        view.addSubview(onboardingImageView)
        view.addSubview(startButton)
    }
    
    override func setConstraints() {
        super.setConstraints()
        
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
        
        startButton.snp.makeConstraints { make in
            make.top.equalTo(onboardingImageView.snp.bottom).offset(153)
            make.horizontalEdges.equalToSuperview().inset(24)
            make.height.equalTo(44)
        }
    }
}

#Preview {
    UINavigationController(rootViewController: OnboardingViewController())
}

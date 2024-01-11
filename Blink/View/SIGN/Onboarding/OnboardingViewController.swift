//
//  OnboardingViewController.swift
//  Blink
//
//  Created by Chaewon on 1/2/24.
//

import UIKit
import RxSwift
import RxCocoa

final class OnboardingViewController: BaseViewController {
    
    private let introduceLabel = {
        let view = UILabel.labelBuilder(text: "새싹톡을 사용하면 어디서나\n팀을 모을 수 있습니다", font: .title1, textColor: .brandBlack, numberOfLines: 0, textAlignment: .center)
        view.lineBreakMode = .byWordWrapping
        return view
    }()
    
    private let onboardingImageView = {
        let view = UIImageView()
        view.image = .onboarding
        view.contentMode = .scaleAspectFill
        return view
    }()
    
    private let startButton = RoundedButton(title: "시작하기")
    
    private var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
        
    }
    
    private func bind() {
        startButton.rx.tap
            .subscribe(with: self) { owner, _ in
                let vc = AuthViewController()
                vc.modalPresentationStyle = .pageSheet
                let customDetentId = UISheetPresentationController.Detent.Identifier("custom")
                let customDetent = UISheetPresentationController.Detent.custom(identifier: customDetentId) { context in
                   return 279
                }
                self.sheetPresentationController?.detents = [customDetent]
               
                if let sheet = vc.sheetPresentationController {
                    //지원할 크기 지정
                    sheet.detents = [customDetent]
                    //크기 변하는거 감지
                    sheet.prefersGrabberVisible = true
                }
               
                self.present(vc, animated: true, completion: nil)
            }
            .disposed(by: disposeBag)
             
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


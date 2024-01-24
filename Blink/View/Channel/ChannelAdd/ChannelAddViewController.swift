//
//  ChannelAddViewController.swift
//  Blink
//
//  Created by Chaewon on 1/24/24.
//

import UIKit
import RxSwift
import RxCocoa

protocol CreateChannelDelegate: AnyObject {
    func sendToastMessageAndReload(_ message: String)
}

final class ChannelAddViewController: BaseViewController {
    
    private let mainView = ChannelAddView()
    let viewModel = ChannelAddViewModel()
    
    private var disposeBag = DisposeBag()
    
    var delegate: CreateChannelDelegate?
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavigation(title: "채널 생성")
        
        bind()
    }
    
    private func bind() {
        let input = ChannelAddViewModel.Input(
            nameText: mainView.nameTextfield.rx.text.orEmpty,
            descriptText: mainView.descriptionTextfield.rx.text.orEmpty,
            createButtonTap: mainView.createButton.rx.tap
        )
        let output = viewModel.transform(input: input)
        
        // MARK: 네비게이션 X 버튼
        navigationItem.leftBarButtonItem!.rx.tap
            .bind(with: self) { owner, _ in
                owner.dismiss(animated: true)
            }
            .disposed(by: disposeBag)
        
        // MARK: 생성 버튼 활성화
        input.nameText
            .map { !$0.isEmpty }
            .bind(with: self) { owner, bool in
                owner.mainView.createButton.rx.isEnabled.onNext(bool)
                owner.mainView.createButton.backgroundColor = bool ? .brandGreen : .brandInactive
            }
            .disposed(by: disposeBag)
        
        // MARK: 네트워크 결과
        output.networkResult
            .subscribe(with: self) { owner, result in
                
                let toastPosition = owner.mainView.createButton.frame.origin.y - 30
                
                switch result {
                case .success:
                    owner.dismiss(animated: true) {
                        let message = "채널이 생성되었습니다."
                        owner.delegate?.sendToastMessageAndReload(message)
                    }
                case .serverConflict:
                    owner.toast(message: "워크스페이스에 이미 있는 채널 이름입니다. 다른 이름을 입력해주세요", pointY: toastPosition)
                case .noData:
                    owner.toast(message: "데이터가 없다~~ 워크스페이스 삭제된거 아님?", pointY: toastPosition)
                case .wrongRequest:
                    owner.toast(message: "잘못된 요청이란다~~", pointY: toastPosition)
                }
            }
            .disposed(by: disposeBag)
        
            
    }
    
}

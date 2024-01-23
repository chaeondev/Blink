//
//  InviteMemberViewController.swift
//  Blink
//
//  Created by Chaewon on 1/23/24.
//

import UIKit
import RxSwift
import RxCocoa

protocol InvitationDelegate: AnyObject {
    func sendInvitationResultMessage(message: String)
}

final class InviteMemberViewController: BaseViewController {
    
    private let mainView = InviteMemberView()
    let viewModel = InviteMemberViewModel()
    
    private var disposeBag = DisposeBag()
    
    //delegate
    weak var delegate: InvitationDelegate?
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavigation(title: "팀원 초대")
        
        bind()
    }
    
    private func bind() {
        let input = InviteMemberViewModel.Input(
            sendButtonTap: mainView.sendButton.rx.tap,
            emailText: mainView.emailTextfield.rx.text.orEmpty
        )
        let output = viewModel.transform(input: input)
        
        
        //navigation X 버튼
        navigationItem.leftBarButtonItem!.rx.tap
            .bind(with: self) { owner, _ in
                owner.dismiss(animated: true)
            }
            .disposed(by: disposeBag)
        
        //이메일 버튼 enable
        input.emailText
            .map { !$0.isEmpty }
            .bind(with: self) { owner, bool in
                owner.mainView.sendButton.rx.isEnabled.onNext(bool)
                owner.mainView.sendButton.backgroundColor = bool ? .brandGreen : .brandInactive
            }
            .disposed(by: disposeBag)
        
        //invite 네트워크 결과
        output.inviteResult
            .bind(with: self) { owner, result in
            
                var message: String {
                    switch result {
                    case .success:
                        return "멤버를 성공적으로 초대했습니다."
                    case .serverConflict:
                        return "이미 워크스페이스에 소속된 팀원이에요."
                    case .noData:
                        return "회원 정보를 찾을 수 없습니다."
                    case .invalidEmail:
                        return "올바른 이메일을 입력해주세요."
                    case .permissionDenied:
                        return "워크스페이스 관리자만 멤버를 초대할 수 있습니다."
                    case .networkError:
                        return "네트워크 오류입니다. 다시 시도해주세요"
                    }
                }
                
                //HomeDefault로 전환
                owner.dismiss(animated: true) {
                    self.delegate?.sendInvitationResultMessage(message: message)
                }
        
            }
            .disposed(by: disposeBag)
    }
    
}

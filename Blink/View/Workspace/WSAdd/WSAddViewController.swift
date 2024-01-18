//
//  AddViewController.swift
//  Blink
//
//  Created by Chaewon on 1/11/24.
//

import UIKit
import RxSwift
import RxCocoa

final class WSAddViewController: BaseViewController {
    
    private let mainView = WSAddView()
    private let viewModel = WSAddViewModel()
    private var disposeBag = DisposeBag()
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationbar()
        setUpSheet()
        bind()
    }
    
    private func bind() {
        let input = WSAddViewModel.Input(
            nameText: mainView.titleTextField.rx.text.orEmpty,
            descriptText: mainView.infoTextField.rx.text.orEmpty,
            doneButtonTap: mainView.doneButton.rx.tap
        )
        let output = viewModel.transform(input: input)
        
        // MARK: 프로필 버튼 - 카메라, 갤러리 액션시트
        mainView.profileButton.rx.tap
            .bind(with: self) { owner, _ in
                owner.showActionSheet()
            }
            .disposed(by: disposeBag)
        
        // MARK: 생성 버튼 활성화
        input.nameText
            .map { !$0.isEmpty }
            .bind(with: self) { owner, bool in
                owner.mainView.doneButton.rx.isEnabled.onNext(bool)
                owner.mainView.doneButton.backgroundColor = bool ? .brandGreen : .brandInactive
            }
            .disposed(by: disposeBag)
        
        // MARK: validation 따른 토스트 메세지
        output.validationOutput
            .bind(with: self) { owner, validation in
                var message: String {
                    switch validation {
                    case .invalidName:
                        return "워크스페이스 이름은 1~30자로 설정해주세요."
                    case .invalidImage:
                        return "워크스페이스 이미지를 등록해주세요."
                    }
                }
                
                let toastPosition = owner.mainView.doneButton.frame.origin.y - 30
                owner.toast(message: message, pointY: toastPosition)
            }
            .disposed(by: disposeBag)
        
        // MARK: 네트워크 결과
        output.createWSResult
            .bind(with: self) { owner, result in
                
                let toastPosition = owner.mainView.doneButton.frame.origin.y - 30
                
                switch result {
                case .success(let response):
                    let wsID = response.workspace_id
                    
                    let vc = HomeTabViewController()
                    vc.workspaceID = wsID
                    
                    owner.changeRootViewController(viewController: vc)
                case .networkError:
                    owner.toast(message: "에러가 발생했어요. 잠시 후 다시 시도해주세요.", pointY: toastPosition)
                case .serverConflict:
                    owner.toast(message: "중복된 이름입니다. 워크스페이스 이름은 고유한 이름으로 지정해주세요", pointY: toastPosition)
                case .insufficientCoin:
                    owner.toast(message: "새싹 코인이 부족합니다. 코인을 채워주세요", pointY: toastPosition)
                }
            }
            .disposed(by: disposeBag)
    }
    
    // TODO: 나중에 extension으로 빼기
    private func showActionSheet() {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let cameraAction = UIAlertAction(title: "카메라", style: .default) { (action) in
            self.takePhoto()
        }
        
        let galleryAction = UIAlertAction(title: "앨범에서 가져오기", style: .default) { (action) in
            self.openLibrary()
        }
        
        let cancel = UIAlertAction(title: "취소", style: .cancel)
        alert.addAction(cameraAction)
        alert.addAction(galleryAction)
        alert.addAction(cancel)
        present(alert, animated: true)
    }
    
    
}

extension WSAddViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func takePhoto() {
        let camera = UIImagePickerController()
        camera.sourceType = .camera
        camera.allowsEditing = false
        camera.cameraDevice = .rear
        camera.cameraCaptureMode = .photo
        camera.delegate = self
        present(camera, animated: true, completion: nil)
    }
    
    func openLibrary() {
        let gallery = UIImagePickerController()
        gallery.sourceType = .photoLibrary
        gallery.delegate = self
        gallery.allowsEditing = false
        present(gallery, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            
            guard let imageData = image.jpegData(compressionQuality: 0.01) else { return }
            
            self.viewModel.imageData.onNext(imageData)

            mainView.profileButton.setImage(image, for: .normal)
            mainView.profileButton.contentMode = .scaleAspectFill
            mainView.profileButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        }
        
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
}


extension WSAddViewController {
    private func setNavigationbar() {
        title = "워크스페이스 생성"
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: .close, style: .done, target: self, action: nil)
        navigationController?.navigationBar.tintColor = .brandBlack
    } // TODO: 네비게이션 bar background color 변경 (white), border 처리
    
    private func setUpSheet() {
        if let sheet = sheetPresentationController {
            sheet.detents = [.large()]
            sheet.prefersGrabberVisible = true
        }
    }
}



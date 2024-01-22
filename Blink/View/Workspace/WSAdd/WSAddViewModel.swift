//
//  AddViewModel.swift
//  Blink
//
//  Created by Chaewon on 1/11/24.
//

import Foundation
import RxSwift
import RxCocoa

final class WSAddViewModel: ViewModelType {
    
    enum CreateWorkspaceValidation {
        case invalidName
        case invalidImage
    }
    
    enum CreateWSResult<T: Decodable> {
        case networkError
        case serverConflict
        case insufficientCoin
        case success(T)
    }
    
    let imageData = PublishSubject<Data>()
    
    private var disposeBag = DisposeBag()
    
    struct Input {
        let nameText: ControlProperty<String>
        let descriptText: ControlProperty<String>
        let doneButtonTap: ControlEvent<Void>
    }
    
    struct Output {
        let validationOutput: PublishSubject<CreateWorkspaceValidation>
        let createWSResult: PublishSubject<CreateWSResult<WorkspaceInfoResponse>>
    }
    
    func transform(input: Input) -> Output {
        
        let isValidName = BehaviorSubject(value: false)
        let isValidImage = BehaviorSubject(value: false)
        
        let validationOutput = PublishSubject<CreateWorkspaceValidation>()
        let createWSResult = PublishSubject<CreateWSResult<WorkspaceInfoResponse>>()
        
        //워크스페이스 이름 검증
        input.nameText
            .map { $0.count >= 1 && $0.count <= 30 }
            .bind(to: isValidName)
            .disposed(by: disposeBag)
        
        //워크스페이스 이미지 검증
        imageData
            .subscribe(with: self) { owner, value in
                isValidImage.onNext(!value.isEmpty)
            }
            .disposed(by: disposeBag)
        
        // MARK: 생성(완료)버튼 클릭
        
        //request 구조체 만들기
        let createRequestModel = Observable.combineLatest(
            input.nameText,
            input.descriptText,
            imageData
        )
            .map { (name, descript, image) in
                return WorkspaceInfoRequest(
                    name: name,
                    description: descript,
                    image: image
                )
            }
        
        let validation = Observable.combineLatest(
            isValidName,
            isValidImage
        )
        
        //생성 버튼 클릭
        input.doneButtonTap
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .withLatestFrom(validation)
            .filter { value in
                if !value.0 {
                    validationOutput.onNext(.invalidName)
                    return false
                } else if !value.1 {
                    validationOutput.onNext(.invalidImage)
                    return false
                } else {
                    return true
                }
            }
            .withLatestFrom(createRequestModel)
            .flatMapLatest {
                APIService.shared.requestMultipart(type: WorkspaceInfoResponse.self, api: WorkspaceRouter.createWorkspace($0))
            }
            .subscribe(with: self) { owner, result in
                switch result {
                case .success(let response):
                    print("===Create Workspace success===")
                    createWSResult.onNext(.success(response))
                case .failure(let error):
                    let isCommonError = NetworkError.allCases.map { $0.rawValue }.contains(error.errorCode)
                    let customError: (any HTTPError)? = isCommonError ? NetworkError(rawValue: error.errorCode) : CreateWorkspaceError(rawValue: error.errorCode)
                    
                    if let wsError = customError as? CreateWorkspaceError {
                        switch wsError {
                        case .wrongRequest:
                            createWSResult.onNext(.networkError)
                        case .serverConflict:
                            createWSResult.onNext(.serverConflict)
                        case .insufficientCoin:
                            createWSResult.onNext(.insufficientCoin)
                        }
                    }
                    
                    print("==Create Workspace Failed \(String(describing: customError))")
                }
            }
            .disposed(by: disposeBag)
        
        
        
        return Output(validationOutput: validationOutput, createWSResult: createWSResult)
    }
}

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
    
    private var disposeBag = DisposeBag()
    
    struct Input {
        let imageData: Observable<Data?>
        let nameText: ControlProperty<String>
        let descriptText: ControlProperty<String>
        let doneButtonTap: ControlEvent<Void>
    }
    
    struct Output {
        
    }
    
    func transform(input: Input) -> Output {
        
        let isValidName = BehaviorSubject(value: false)
        
        //워크스페이스 이름 검증
        input.nameText
            .map { $0.count >= 1 && $0.count <= 30 }
            .bind(to: isValidName)
            .disposed(by: disposeBag)
        return Output()
    }
}

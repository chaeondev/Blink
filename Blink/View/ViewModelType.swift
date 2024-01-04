//
//  ViewModelType.swift
//  Blink
//
//  Created by Chaewon on 1/4/24.
//

import Foundation

protocol ViewModelType {
    associatedtype Input
    associatedtype Output
    
    func transform(input: Input) -> Output
}

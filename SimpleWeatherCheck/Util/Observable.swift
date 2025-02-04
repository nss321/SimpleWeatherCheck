//
//  Observable.swift
//  SimpleWeatherCheck
//
//  Created by BAE on 2/4/25.
//

import Foundation

class Observable<T> {
    var closure: ((T) -> ())?
    
    var value: T {
        didSet {
            closure?(value)
        }
    }
    
    init(_ value: T) {
        self.value = value
    }
    
    func bind(closure: @escaping (T) -> ()) {
        closure(value)
        self.closure = closure
    }
}

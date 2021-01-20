//
//  Observable.swift
//  zipkok
//
//  Created by won heo on 2021/01/20.
//

import Foundation

final class Observable<T> {
    typealias Observer = (T) -> ()
    
    var observer: Observer?
    
    var value: T {
        didSet {
            observer?(value)
        }
    }

    init(_ value: T) {
        self.value = value
    }
    
    func bind(observer: Observer?) {
        self.observer = observer
        observer?(value)
    }
}

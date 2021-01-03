//
//  Observable.swift
//  Pokedex
//
//  Created by claudio cavalli on 19/12/20.
//

import Foundation

final class Observable<Value> {
    typealias Listener = (Value) -> Void
    var listener: Listener?
    
    var value: Value {
        didSet {
            listener?(value)
        }
    }
    
    init(_ value: Value) {
        self.value = value
    }
    
    func bind(listener: Listener?) {
        self.listener = listener
        listener?(value)
    }
}

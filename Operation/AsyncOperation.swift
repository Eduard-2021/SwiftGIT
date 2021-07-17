//
//  AsyncOperation.swift
//  VK_PlusHW2.4
//
//  Created by Eduard on 16.07.2021.
//

import Foundation

open class AsyncOperation: Operation {
    
    public enum State: String {
        case ready, executing, finished
        
        fileprivate var keyPath: String {
            return "is" + rawValue.capitalized
        }
    }
    
    public var state = State.ready {
        willSet {
            willChangeValue(forKey: state.keyPath)
            willChangeValue(forKey: newValue.keyPath)
        }
        didSet {
            didChangeValue(forKey: state.keyPath)
            didChangeValue(forKey: oldValue.keyPath)
        }
    }
}

extension AsyncOperation {
    open override var isAsynchronous: Bool {
        return true
    }
    
    open override var isReady: Bool {
        return super.isReady && state == .ready
    }
    
    open override var isExecuting: Bool {
        return state == .executing
    }
    
    open override var isFinished: Bool {
        return state == .finished
    }
    
    open override func start() {
        if isCancelled {
            state = .finished
        } else {
            main()
            state = .executing
        }
    }
    
    open override func cancel() {
        super.cancel()
        state = .finished
    }
}

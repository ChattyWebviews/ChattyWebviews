//
//  Executor.swift
//  ChattyWebviews
//
//  Created by Teodor Dermendzhiev on 22.03.23.
//
import Foundation

protocol Executor {
    var executionQueue: DispatchQueue { get }
    func execute(action: @escaping () -> Void)
}

extension Executor {
    func execute(action: @escaping () -> Void) {
        executionQueue.async(execute: action)
    }
}


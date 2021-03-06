//
//  Subscriptions.swift
//  NatsysTemplate1
//
//  Created by amglobal on 4/26/19.
//  Copyright © 2019 Natsys. All rights reserved.
//

import Foundation

struct Subscription<State: StateType> {
    weak var subscriber: AnyStoreSubscriber?
    let transform: ((State) -> Any)?
}

public protocol AnyStoreSubscriber: class {
    func _newState(_ state: Any)
}

public protocol SubscriberType: AnyStoreSubscriber {
    associatedtype StoreSubscriberStateType
    func newState(_ subscription: StoreSubscriberStateType)
}

extension SubscriberType {
    public func _newState(_ state: Any) {
        if let typedState = state as? StoreSubscriberStateType {
            newState(typedState)
        } else {
            preconditionFailure("newState does not accept right type")
        }
    }
}

/// Renderer is a special SubscriberType that has semantics that match what we expect
/// in a view controller.
public protocol Renderer: SubscriberType {
    associatedtype ViewModel
    func render(_ viewModel: ViewModel)
}

extension Renderer {
    public func newState(_ state: Any) {
        if let viewModel = state as? ViewModel {
            render(viewModel)
        } else {
            preconditionFailure("render on \(type(of: self)) does not accept right type. Expected \(ViewModel.self), given \(type(of: state))")
        }
    }
}

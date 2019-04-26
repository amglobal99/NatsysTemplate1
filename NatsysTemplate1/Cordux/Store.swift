//
//  Store.swift
//  NatsysTemplate1
//
//  Created by amglobal on 4/26/19.
//  Copyright © 2019 Natsys. All rights reserved.
//

import Foundation

/// Action is a marker type that describes types that can modify state.
public protocol Action {}

/// StateType describes the minimum requirements for state.
public protocol StateType {
    
    /// The current representation of the route for the app.
    ///
    /// This describes what the user is currently seeing and how they navigated there.
    var route: Route { get set }
}

public final class Store<State : StateType> {
    public fileprivate (set) var state: State
    var reducer: AnyReducer
    
    typealias SubscriptionType = Subscription<State>
    var subscriptions: [SubscriptionType] = []
    
    public init(initialState: State, reducer: AnyReducer) {
        self.state = initialState
        self.reducer = reducer
    }
    
    public func subscribe<Subscriber : SubscriberType, SelectedState>(_ subscriber: Subscriber, _ transform: ((State) -> SelectedState)? = nil) where Subscriber.StoreSubscriberStateType == SelectedState {
        guard isNewSubscriber(subscriber) else {
            return
        }
        
        subscriptions.append(Subscription(subscriber: subscriber, transform: transform))
        subscriber._newState(transform?(state) as Any? ?? state)
    }
    
    public func unsubscribe(_ subscriber: AnyStoreSubscriber) {
        #if swift(>=3)
        if let index = subscriptions.firstIndex(where: { return $0.subscriber === subscriber }) {
            subscriptions.remove(at: index)
        }
        #else
        if let index = subscriptions.firstIndex(where: { return $0.subscriber === subscriber }) {
            subscriptions.remove(at: index)
        }
        #endif
    }
    
    /// Function updates the route and executes a Route based action.
    ///
    /// First, the **'reduce'** function in Routing.Swift is called,
    /// which gives us an updated Route.
    /// The action is executed next. It can be one of the folowing:
    /// * goto
    /// * push
    /// * pop
    /// * replace
    /// * poplast
    ///
    /// - Parameter action: an action of type **RouteAction**
    ///
    /// - Returns: Nothing
    public func route<T>(_ action: RouteAction<T>) {
        state.route = reduce(action, route: state.route)
        dispatch(action)
    }
    
    public func setRoute<T>(_ action: RouteAction<T>) {
        state.route = reduce(action, route: state.route)
    }
    
    /// Function creates a new state from a given action.
    /// For each subscriber, it executes the **'_newState'** function (Subscription.swift)
    ///
    /// - Parameter action: an action
    ///
    /// - Returns: Nothing
    ///
    public func dispatch(_ action: Action) {
        state = reducer._handleAction(action, state: state) as! State
        subscriptions.forEach { $0.subscriber?._newState($0.transform?(state) ?? state) }
    }
    
    func isNewSubscriber(_ subscriber: AnyStoreSubscriber) -> Bool {
        #if swift(>=3)
        guard !subscriptions.contains(where: { $0.subscriber === subscriber }) else {
            return false
        }
        #else
        guard !subscriptions.contains(where: { $0.subscriber === subscriber }) else {
            return false
        }
        #endif
        return true
    }
}





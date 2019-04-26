//
//  SceneCoordinator.swift
//  NatsysTemplate1
//
//  Created by amglobal on 4/26/19.
//  Copyright © 2019 Natsys. All rights reserved.
//

import UIKit

public protocol SceneCoordinator: Coordinator {
    var scenePrefix: String { get }
    var currentScene: AnyCoordinator? { get }
    func changeScene(_ route: Route)
    func sceneRoute(_ route: Route) -> Route
}

public extension SceneCoordinator {
    var route: Route {
        get {
            let route: Route = scenePrefix.route()
            return route + (currentScene?.route ?? [])
        }
        set {
            let r = route
            if r.first != newValue.first {
                changeScene(newValue)
            }
            routeScene(newValue)
        }
    }
    
    func routeScene(_ route: Route) {
        currentScene?.route = sceneRoute(route)
    }
    
    func sceneRoute(_ route: Route) -> Route {
        return Route(route.dropFirst())
    }
}





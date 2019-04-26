//
//  NavigationControllerCoordinator.swift
//  
//
//  Created by amglobal on 4/26/19.
//

import UIKit

public protocol NavigationControllerCoordinator: Coordinator {
    var navigationController: UINavigationController { get }
    func updateRoute(_ route: Route)
}

public extension NavigationControllerCoordinator  {
    var rootViewController: UIViewController { return navigationController }
    
    var route: Route {
        get {
            var route: Route = []
            navigationController.viewControllers.forEach { vc in
                #if swift(>=3)
                route.append(contentsOf: vc.corduxContext?.routeSegment.route() ?? [])
                #else
                route.append(contentsOf: vc.corduxContext?.routeSegment.route() ?? [])
                #endif
            }
            return route
        }
        set {
            if newValue != route {
                updateRoute(newValue)
            }
        }
    }
    
    func popRoute(_ viewController: UIViewController) {
        guard let context = viewController.corduxContext else {
            return
        }
        store.setRoute(.pop(context.routeSegment.route()))
    }
}

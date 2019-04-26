//
//  Context.swift
//  NatsysTemplate1
//
//  Created by amglobal on 4/26/19.
//  Copyright © 2019 Natsys. All rights reserved.
//

import UIKit

public protocol Contextual: class {
    var corduxContext: Context? { get }
}

public final class Context: NSObject {
    public let routeSegment: RouteConvertible
    public weak var lifecycleDelegate: ViewControllerLifecycleDelegate?
    
    public init(_ routeSegment: RouteConvertible, lifecycleDelegate: ViewControllerLifecycleDelegate?) {
        self.routeSegment = routeSegment
        self.lifecycleDelegate = lifecycleDelegate
    }
}

extension UIViewController: Contextual {
    fileprivate struct ViewControllerKeys {
        static var Context = "cordux_context"
    }
    
    public var corduxContext: Context? {
        get {
            return objc_getAssociatedObject(self, &ViewControllerKeys.Context) as? Context
        }
        
        set {
            if let newValue = newValue {
                objc_setAssociatedObject(
                    self,
                    &ViewControllerKeys.Context,
                    newValue as Context?,
                    .OBJC_ASSOCIATION_RETAIN_NONATOMIC
                )
            }
        }
    }
}

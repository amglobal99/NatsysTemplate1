//
//  ViewControllerLifecycle.swift
//  NatsysTemplate1
//
//  Created by amglobal on 4/26/19.
//  Copyright © 2019 Natsys. All rights reserved.
//

import UIKit

@objc public protocol ViewControllerLifecycleDelegate {
    @objc optional func viewDidLoad(_ viewController: UIViewController)
    @objc optional func viewWillDisappear(_ viewController: UIViewController)
    @objc optional func viewWillAppear(_ viewController: UIViewController)
    @objc optional func viewDidAppear(_ viewController: UIViewController)
    @objc optional func viewDidDisappear(_ viewController: UIViewController)
    @objc optional func didMove(_ toParentViewController: UIViewController?, viewController: UIViewController)
}

extension UIViewController {
    static let swizzle: Void = {
        UIViewController.cordux_swizzleMethod(#selector(UIViewController.viewDidLoad),
                                              swizzled: #selector(UIViewController.cordux_viewDidLoad))
        UIViewController.cordux_swizzleMethod(#selector(UIViewController.viewDidDisappear(_:)),
                                              swizzled: #selector(UIViewController.cordux_viewDidDisappear))
        UIViewController.cordux_swizzleMethod(#selector(UIViewController.viewWillDisappear(_:)),
                                              swizzled: #selector(UIViewController.cordux_viewWillDisappear))
        UIViewController.cordux_swizzleMethod(#selector(UIViewController.viewWillAppear(_:)),
                                              swizzled: #selector(UIViewController.cordux_viewWillAppear))
        UIViewController.cordux_swizzleMethod(#selector(UIViewController.viewDidAppear(_:)),
                                              swizzled: #selector(UIViewController.cordux_viewDidAppear))
        
        
        #if swift(>=3)
        UIViewController.cordux_swizzleMethod(#selector(UIViewController.didMove),
                                              swizzled: #selector(UIViewController.cordux_didMoveToParentViewController(_:)))
        #else
        UIViewController.cordux_swizzleMethod(#selector(UIViewController.didMove(toParentViewController:)(_:)),
                                              swizzled: #selector(UIViewController.cordux_didMoveToParentViewController(_:)))
        #endif
    }()
    
    public class func swizzleLifecycleDelegatingViewControllerMethods() {
        _ = swizzle
    }
    
    @objc func cordux_viewDidLoad() {
        self.cordux_viewDidLoad()
        #if swift(>=3)
        self.corduxContext?.lifecycleDelegate?.viewDidLoad?(self)
        #else
        self.corduxContext?.lifecycleDelegate?.viewDidLoad?(self)
        #endif
    }
    
    @objc func cordux_viewDidDisappear() {
        self.cordux_viewDidDisappear()
        #if swift(>=3)
        self.corduxContext?.lifecycleDelegate?.viewDidDisappear?(self)
        #else
        self.corduxContext?.lifecycleDelegate?.viewDidDisappear?(self)
        #endif
    }
    
    @objc func cordux_viewWillDisappear() {
        self.cordux_viewWillDisappear()
        #if swift(>=3)
        self.corduxContext?.lifecycleDelegate?.viewWillDisappear?(self)
        #else
        self.corduxContext?.lifecycleDelegate?.viewWillDisappear?(self)
        #endif
    }
    
    @objc func cordux_viewWillAppear() {
        self.cordux_viewWillAppear()
        #if swift(>=3)
        self.corduxContext?.lifecycleDelegate?.viewWillAppear?(self)
        #else
        self.corduxContext?.lifecycleDelegate?.viewWillAppear?(self)
        #endif
    }
    
    @objc func cordux_viewDidAppear() {
        self.cordux_viewDidAppear()
        #if swift(>=3)
        self.corduxContext?.lifecycleDelegate?.viewDidAppear?(self)
        #else
        self.corduxContext?.lifecycleDelegate?.viewDidAppear?(self)
        #endif
    }
    
    
    
    @objc func cordux_didMoveToParentViewController(_ parentViewController: UIViewController?) {
        self.cordux_didMoveToParentViewController(parentViewController)
        
        #if swift(>=3)
        self.corduxContext?.lifecycleDelegate?.didMove?(parentViewController, viewController: self)
        #else
        self.corduxContext?.lifecycleDelegate?.didMove?(parentViewController, viewController: self)
        #endif
    }
    
    static func cordux_swizzleMethod(_ original: Selector, swizzled: Selector) {
        guard let originalMethod = class_getInstanceMethod(self, original) else { fatalError("\(#function) failed to get originalMethod") }
        guard let swizzledMethod = class_getInstanceMethod(self, swizzled) else { fatalError("\(#function) failed to get swizzledMethod") }
        
        let didAddMethod = class_addMethod(self, original, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod))
        
        if didAddMethod {
            class_replaceMethod(self, swizzled, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod))
        } else {
            method_exchangeImplementations(originalMethod, swizzledMethod)
        }
    }
}




//
//  ClassNameNibLoadable.swift
//  NatsysTemplate1
//
//  Created by amglobal on 4/26/19.
//  Copyright © 2019 Natsys. All rights reserved.
//

import Foundation
import UIKit

public protocol ClassNameNibLoadable: IdentifiableByClassName {
    
}

public protocol IdentifiableByClassName {
    static var reusableIdentifier: String { get }
}

public extension ClassNameNibLoadable where Self: NSObjectProtocol {
    static var nib: UINib {
        return nibFrom(Bundle(for: self))
    }
    
    static func nibFrom(_ bundle: Bundle) -> UINib {
        var currentClass: AnyClass = self
        var nib: UINib?
        
        while currentClass != NSObject.self {
            let nibName = String(describing: currentClass)
            if bundle.path(forResource: nibName, ofType: "nib") != nil {
                nib = UINib(nibName: nibName, bundle: bundle)
                break
            }
            currentClass = currentClass.superclass()!
        }
        
        guard let returnNib = nib else {
            fatalError("Could not find nib for \(String(describing: self)) in bundle \(bundle.bundleIdentifier!)")
        }
        return returnNib
    }
    
    
//    static func loadInstanceFromNib(_ owner: AnyObject? = nil, options: [AnyHashable: Any]? = nil, bundle: Bundle? = nil) -> Self {
//        
//        let nib: UINib
//        if let bundle = bundle {
//            nib = self.nibFrom(bundle)
//        } else {
//            nib = self.nib
//        }
//        
//        let objects: [AnyObject] = nib.instantiate(withOwner: owner, options: options) as [AnyObject]
//        var result: Self?
//        for object in objects {
//            if let object = object as? Self {
//                result = object
//                break
//            }
//        }
//        guard let returnValue = result else {
//            fatalError("Cannot find class \(self) or any of its ancestors as a top level object in nib")
//        }
//        return returnValue
//    }
}



extension IdentifiableByClassName where Self: UITableViewCell {
    static var reusableIdentifier: String {
        return String(describing: self)
    }
}

extension IdentifiableByClassName where Self: UIView {
    static var reusableIdentifier: String {
        return String(describing: self)
    }
}

extension IdentifiableByClassName where Self: UICollectionViewCell {
    static var reusableIdentifier: String {
        return String(describing: self)
    }
}

extension IdentifiableByClassName where Self: UITableViewHeaderFooterView {
    static var reusableIdentifier: String {
        return String(describing: self)
    }
}

extension IdentifiableByClassName where Self: UIViewController {
    static var reusableIdentifier: String {
        return String(describing: self)
    }
    
    static var storyboardIdentifier: String {
        return reusableIdentifier
    }
}

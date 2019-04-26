//
//  UIViewController.swift
//  NatsysTemplate1
//
//  Created by amglobal on 4/26/19.
//  Copyright © 2019 Natsys. All rights reserved.
//

import UIKit

public typealias Callback = ()->()
public typealias CellSelectionCallback = (_ tableView: UITableView, _ indexPath: IndexPath) -> ()
public typealias BoolCallback = (Bool)->()

public protocol ChildViewControllerEmbeddable {
    
    func installChildViewControllerInParent(_ parent: UIViewController)
    func uninstallChildViewController()
}

extension Collection {
    subscript (safe index: Index) -> Iterator.Element? {
        return (startIndex..<endIndex).contains(index) ? self[index] : nil
    }
}

extension UIViewController {
    
    func addChild(_ child: UIViewController, toView destinationView: UIView) {
        addChild(child)
        destinationView.addConstrainedSubview(child.view)
        child.didMove(toParent: self)
    }
    
    func addNonConstrainedChild(_ child: UIViewController, toView destinationView: UIView) {
        addChild(child)
        destinationView.addSubview(child.view)
        child.didMove(toParent: self)
    }
    
    func removeViewFromParent() {
        willMove(toParent: nil)
        view.removeFromSuperview()
        removeFromParent()
    }
    
    func useBackButtonTitle() {
        navigationItem.backBarButtonItem = UIBarButtonItem(title: NSLocalizedString("NavigationItem.LeftBarButtonItem.Back.Title", comment: ""),
                                                           style: .plain,
                                                           target: nil,
                                                           action: nil)
    }
    
    /// Returns the top most view controller, if the caller hasn't presented
    /// any other view controllers, it returns itself
    var topMostViewController: UIViewController {
        var topMostViewController = self
        
        while let currentViewController = topMostViewController.presentedViewController {
            topMostViewController = currentViewController
        }
        return topMostViewController
    }
}

//MARK: AlertController
extension UIViewController {
    
//    func alertForUnexpectedError(title: String? = nil, message: String, completion: Callback? = nil){
//
//        let title = title ?? NSLocalizedString("UIAlertController.UnexpectedError.Title", comment: "")
//
//        let alertController = UIAlertController(title: title,
//                                                message: message,
//                                                preferredStyle: .alert)
//
//        let okAction = UIAlertAction.makeOKAction { completion?() }
//        alertController.addAction(okAction)
//
//        self.present(alertController, animated: true, completion: nil)
//
//    }
//
//    /// Generic function used to display error alerts.
//    func showErrorAlert(error: Error, completion: Callback? = nil) {
//
//        let message: String
//        var title: String? = nil
//
//        switch error {
//        case let err as VerifyRSRCountsError:
//            title = err.localizedStringError().title
//            message = err.localizedStringError().message
//
//        case let addStopsErrors as AddStopsToTodayErrors:
//            switch addStopsErrors {
//            case .listOfErrors(let addStopsError):
//                guard let firstError = addStopsError.first?.value else {
//                    message =  "\(error)"
//                    recoverableFailure(error)
//                    break
//                }
//                title = firstError.localizedStringError().title
//                message = firstError.localizedStringError().message
//            case .fatalError(let error):
//                message = error.uiMessage()
//                recoverableFailure(error)
//            }
//
//        case let err as DatabaseError:
//            message = err.uiMessage()
//            recoverableFailure(error)
//        default:
//            message =  "\(error)"
//            recoverableFailure(error)
//        }
//
//        alertForUnexpectedError(title: title, message: message, completion: completion)
//    }
    
//    func alertForDeleteConfirmation(title: String, message: String, cancelHandler: Callback? = nil, deleteHandler: Callback? = nil) {
//        
//        let alertController = UIAlertController(title: title,
//                                                message: message,
//                                                preferredStyle: .alert)
//        
//        let deleteAction = UIAlertAction.makeDeleteAction { deleteHandler?() }
//        let cancelAction = UIAlertAction.makeCancelAction() { cancelHandler?() }
//        alertController.addAction(deleteAction)
//        alertController.addAction(cancelAction)
//        
//        self.present(alertController, animated: true, completion: nil)
//    }
//    
//    func alertForConfirmation(title: String, message: String, cancelHandler: Callback? = nil, okHandler: Callback? = nil) {
//        
//        let alertController = UIAlertController(title: title,
//                                                message: message,
//                                                preferredStyle: .alert)
//        
//        let deleteAction = UIAlertAction.makeOKAction { okHandler?() }
//        let cancelAction = UIAlertAction.makeCancelAction() { cancelHandler?() }
//        alertController.addAction(deleteAction)
//        alertController.addAction(cancelAction)
//        
//        self.present(alertController, animated: true, completion: nil)
//    }
    
}

//
//  UIView.swift
//  NatsysTemplate1
//
//  Created by amglobal on 4/26/19.
//  Copyright © 2019 Natsys. All rights reserved.
//

import Foundation
import UIKit

// MARK: - NSLayoutAnchor Extensions
extension UIView {
    
    func constrainEdgeAnchorsToEdgeAnchors(of view: UIView, margin: UIEdgeInsets = UIEdgeInsets.zero, priority: UILayoutPriority = UILayoutPriority.required) {
        let topConstraint = topAnchor.constraint(equalTo: view.topAnchor, constant: CGFloat(margin.top))
        let rightConstraint = trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: CGFloat(-margin.right))
        let bottomConstraint = bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: CGFloat(-margin.bottom))
        let leftConstraint = leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: CGFloat(margin.left))
        
        topConstraint.priority = priority
        rightConstraint.priority = priority
        bottomConstraint.priority = priority
        leftConstraint.priority = priority
        
        NSLayoutConstraint.activate([topConstraint,rightConstraint,bottomConstraint,leftConstraint])
    }
    
    func constrainEdgeAnchorsToEdgeAnchorsOfSuperview() {
        guard let view = self.superview else {
            fatalError("Must have a superview to use this method")
        }
        constrainEdgeAnchorsToEdgeAnchors(of: view)
    }
    
    //MARK: - Centering
    func constrainCenterXAnchorToCenterXAnchorOfSuperview() {
        constrainCenterXAnchorToCenterXAnchor(of: _superview)
    }
    
    func constrainCenterYAnchorToCenterYAnchorOfSuperview() {
        constrainCenterYAnchorToCenterYAnchor(of: _superview)
    }
    
    func constrainCenterXAnchorToCenterXAnchor(of view: UIView) {
        self.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
    
    func constrainCenterYAnchorToCenterYAnchor(of view: UIView) {
        self.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
    
    func constrainCenterToCenterOfSuperView() {
        constrainCenterToCenter(of: _superview)
    }
    
    func constrainCenterToCenter(of view: UIView) {
        constrainCenterXAnchorToCenterXAnchor(of: view)
        constrainCenterYAnchorToCenterYAnchor(of: view)
    }
    
    //MARK: -
    func constrainLeadingTrailingConstraintsToMarginsOfSuperview() {
        constrainLeadingTrailingConstraintsToSuperview(UIEdgeInsets.zero)
    }
    
    func constrainLeadingTrailingConstraintsToSuperview(_ margin: UIEdgeInsets) {
        let leadingConstraint = _superview.layoutMarginsGuide.leadingAnchor.constraint(greaterThanOrEqualTo: self.leadingAnchor,
                                                                                       constant: margin.left)
        let trailingConstraint = _superview.layoutMarginsGuide.trailingAnchor.constraint(greaterThanOrEqualTo: self.trailingAnchor,
                                                                                         constant: margin.right)
        leadingConstraint.priority = UILayoutPriority.defaultHigh
        NSLayoutConstraint.activate([leadingConstraint, trailingConstraint])
    }
    
    func constrainBottomAnchorToBottomAnchorOfSuperView(with margin: UIEdgeInsets) {
        let bottomConstraint = bottomAnchor.constraint(equalTo: _superview.bottomAnchor, constant: CGFloat(-margin.bottom))
        let leftConstraint = leadingAnchor.constraint(equalTo: _superview.leadingAnchor, constant: CGFloat(margin.left))
        let rightConstraint = trailingAnchor.constraint(equalTo: _superview.trailingAnchor, constant: CGFloat(-margin.right))
        
        NSLayoutConstraint.activate([rightConstraint, bottomConstraint, leftConstraint])
    }
    
    func constrainUnderneath(view destinationView: UIView, margin: UIEdgeInsets) {
        let topConstraint = topAnchor.constraint(equalTo: destinationView.bottomAnchor, constant: CGFloat(margin.top))
        let leftConstraint = leadingAnchor.constraint(equalTo: destinationView.leadingAnchor, constant: CGFloat(margin.left))
        let rightConstraint = trailingAnchor.constraint(equalTo: destinationView.trailingAnchor, constant: CGFloat(-margin.right))
        
        NSLayoutConstraint.activate([rightConstraint, topConstraint, leftConstraint])
    }
    
    func addHeightConstraint(with height: CGFloat) {
        heightAnchor.constraint(equalToConstant: height).isActive = true
    }
    
    fileprivate var _superview: UIView {
        precondition(superview != nil, "Must have a superview to use this variable")
        return superview!
    }
    
    // MARK: - Child/Parent Container View Relationship
    func addConstrainedSubview(_ childView: UIView) {
        childView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(childView)
        childView.constrainEdgeAnchorsToEdgeAnchorsOfSuperview()
    }
    
    func addConstrainedSubview(_ childView: UIView, margin: UIEdgeInsets) {
        childView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(childView)
        childView.constrainEdgeAnchorsToEdgeAnchors(of: self, margin: margin)
    }
    
    func addExpandableHeightContrainedSubview(_ childView: UIView, margin: UIEdgeInsets) {
        childView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(childView)
        
        let topConstraint = childView.topAnchor.constraint(equalTo: topAnchor,
                                                           constant: CGFloat(Theme.Metrics.EdgeInsets.centerContentView.top))
        let bottomConstraint = bottomAnchor.constraint(greaterThanOrEqualTo: childView.bottomAnchor,
                                                       constant: CGFloat(-Theme.Metrics.EdgeInsets.centerContentView.bottom))
        let rightConstraint = childView.trailingAnchor.constraint(equalTo: trailingAnchor,
                                                                  constant: CGFloat(-Theme.Metrics.EdgeInsets.centerContentView.right))
        let leftConstraint = childView.leadingAnchor.constraint(equalTo: leadingAnchor,
                                                                constant: CGFloat(Theme.Metrics.EdgeInsets.centerContentView.left))
        NSLayoutConstraint.activate([topConstraint, bottomConstraint, rightConstraint, leftConstraint])
    }
    
    func addTopExpandableWidthConstraint(with margin: UIEdgeInsets) {
        let topConstraint = topAnchor.constraint(equalTo: _superview.topAnchor, constant: margin.top)
        let leftConstraint = leftAnchor.constraint(equalTo: _superview.leftAnchor, constant: margin.left)
        let rightConstraint = rightAnchor.constraint(greaterThanOrEqualTo: _superview.rightAnchor, constant: margin.right)
        
        NSLayoutConstraint.activate([topConstraint, rightConstraint, leftConstraint])
    }
    
    func addCenteredConstrainedSubview(_ childView: UIView) {
        childView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(childView)
        
        let centerConstraint = childView.centerYAnchor.constraint(equalTo: centerYAnchor)
        let rightConstraint = childView.trailingAnchor.constraint(equalTo: trailingAnchor,
                                                                  constant: CGFloat(-Theme.Metrics.EdgeInsets.horizontalScroll.right))
        let leftConstraint = childView.leadingAnchor.constraint(equalTo: leadingAnchor,
                                                                constant: CGFloat(Theme.Metrics.EdgeInsets.horizontalScroll.left))
        NSLayoutConstraint.activate([centerConstraint, rightConstraint, leftConstraint])
    }
    
    // MARK: - Inspectables for Setting Shadows
    
    // From - https://stackoverflow.com/questions/7484855/uiview-shadow-and-interfacebuilder
    
    /* The color of the shadow. Defaults to nil. Colors created
     * from patterns are currently NOT supported. Animatable. */
    @IBInspectable var shadowColor: UIColor? {
        set {
            layer.shadowColor = newValue!.cgColor
        }
        get {
            if let color = layer.shadowColor {
                return UIColor(cgColor: color)
            }
            else {
                return nil
            }
        }
    }
    
    /* The opacity of the shadow. Defaults to 0. Specifying a value outside the
     * [0,1] range will give undefined results. Animatable. */
    @IBInspectable var shadowOpacity: Float {
        set {
            layer.shadowOpacity = newValue
        }
        get {
            return layer.shadowOpacity
        }
    }
    
    /* The shadow offset. Defaults to (0, -3). Animatable. */
    @IBInspectable var shadowOffset: CGPoint {
        set {
            layer.shadowOffset = CGSize(width: newValue.x, height: newValue.y)
        }
        get {
            return CGPoint(x: layer.shadowOffset.width, y:layer.shadowOffset.height)
        }
    }
    
    /* The blur radius used to create the shadow. Defaults to 3. Animatable. */
    @IBInspectable var shadowRadius: CGFloat {
        set {
            layer.shadowRadius = newValue
        }
        get {
            return layer.shadowRadius
        }
    }
}

extension UITableViewCell {
    
    func setLayoutMargins() {
        contentView.layoutMargins.left = 15
        contentView.layoutMargins.right = 15
    }
}

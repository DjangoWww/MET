//
//  UIView+ContainingVC.swift
//  MET
//
//  Created by Django on 3/2/22.
//

import UIKit

extension UIView {
    /**
    Returns the UIViewController object that manages the receiver.
    */
    public func viewContainingController() -> UIViewController? {
        var nextResponder: UIResponder? = self
        repeat {
            nextResponder = nextResponder?.next
            if let viewController = nextResponder as? UIViewController {
                return viewController
            }
        } while nextResponder != nil
        return nil
    }
}

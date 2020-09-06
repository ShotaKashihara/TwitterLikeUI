//
//  UIView.swift
//  TwitterLikeUI
//
//  Created by wantedly on 2020/09/06.
//  Copyright © 2020 shota.kashihara. All rights reserved.
//

import UIKit

extension UIView {
    /// viewから所属しているviewControllerを得る
    var viewController: UIViewController? {
        var parent: UIResponder? = self
        while parent != nil {
            parent = parent?.next
            if let viewController = parent as? UIViewController {
                return viewController
            }
        }
        return nil
    }
}

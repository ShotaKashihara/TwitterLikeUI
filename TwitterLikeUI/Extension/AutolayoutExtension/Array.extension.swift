//
//  Array.extension.swift
//  AutoLayoutExtension
//
//  Created by mono on 2017/06/02.
//  Copyright © 2017 mono. All rights reserved.
//

import Foundation
import UIKit

extension Array where Element == NSLayoutConstraint {
    public func activate() {
        NSLayoutConstraint.activate(self)
    }
    public func deactivate() {
        NSLayoutConstraint.deactivate(self)
    }
}

extension Array {
    public subscript(safe index: Int) -> Element? {
        return indices ~= index ? self[index] : nil
    }
}

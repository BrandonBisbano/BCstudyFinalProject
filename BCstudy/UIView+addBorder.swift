//
//  UIView+addBorder.swift
//  BCstudy
//
//  Created by Brandon Bisbano on 5/1/19.
//  Copyright © 2019 Brandon Bisbano. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    func addBorder(width: CGFloat, radius: CGFloat, color: UIColor) {
        self.layer.borderWidth = width
        self.layer.borderColor = color.cgColor
        self.layer.cornerRadius = radius
    }
    
    func noBorder() {
        self.layer.borderWidth = 0.0
    }
}

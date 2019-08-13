//
//  UIView+Extensions.swift
//  Vision
//
//  Created by Krystyna Kruchkovska on 8/13/19.
//  Copyright © 2019 Mac. All rights reserved.
//

import UIKit

extension UIView {
    func roundedShadowView(cornerRadius:CGFloat? = nil) {
        self.layer.shadowColor = UIColor.darkGray.cgColor
        self.layer.shadowRadius = 15
        self.layer.shadowOpacity = 0.75
        if cornerRadius == nil {
            self.layer.cornerRadius = self.layer.frame.height / 2
        } else {
            self.layer.cornerRadius = cornerRadius!
        }
        
    }
}

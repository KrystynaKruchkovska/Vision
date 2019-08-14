//
//  RoundedShadowImageView.swift
//  Vision
//
//  Created by Krystyna Kruchkovska on 8/13/19.
//  Copyright © 2019 Mac. All rights reserved.
//

import UIKit

class RoundedShadowImageView: UIImageView {

    override func awakeFromNib() {
        super.awakeFromNib()
        self.roundedShadowView(cornerRadius: 15)
    }

}

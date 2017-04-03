//
//  CustomButton.swift
//  Restaurant Base
//
//  Created by Sinisa Vukovic on 04/04/2017.
//  Copyright © 2017 Sinisa Vukovic. All rights reserved.
//

import UIKit

class CustomButton: UIButton {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = self.frame.size.height / 2
    }

}

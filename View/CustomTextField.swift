//
//  CustomTextField.swift
//  Restaurant Base
//
//  Created by Sinisa Vukovic on 04/04/2017.
//  Copyright © 2017 Sinisa Vukovic. All rights reserved.
//

import UIKit
@IBDesignable
class CustomTextField: UITextField {
    
    override func didMoveToWindow() {
        super.didMoveToWindow()
        if window != nil {
            borderStyle = .roundedRect
        }
    }
}

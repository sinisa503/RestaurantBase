//
//  CustomTableVCell.swift
//  Restaurant Base
//
//  Created by Sinisa Vukovic on 29/03/2017.
//  Copyright © 2017 Sinisa Vukovic. All rights reserved.
//

import UIKit

class CustomTableVCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var photo: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}

//TODO: Doesn't work wright - fix it for rounded image in table view
public extension UIImageView {
    public func round() {
        let mask = CAShapeLayer()
        mask.path = UIBezierPath(ovalIn: CGRect(x:bounds.minX , y: bounds.minY, width: bounds.size.width, height: bounds.size.height)).cgPath
        self.layer.mask?.borderColor = UIColor.blue.cgColor
        self.layer.mask = mask
    }
}

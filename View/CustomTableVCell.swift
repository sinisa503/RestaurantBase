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
        // Initialization code
        
    }
    
    override func layoutSubviews() {
        photo.round()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
}

/** Doesn't work wright **/
public extension UIImageView {
    public func round() {
        let mask = CAShapeLayer()
        mask.path = UIBezierPath(ovalIn: CGRect(x:bounds.minX , y: bounds.minY, width: bounds.size.width, height: bounds.size.height)).cgPath
        self.layer.mask = mask
    }
}

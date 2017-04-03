//
//  CustomAnnotation.swift
//  Restaurant Base
//
//  Created by Sinisa Vukovic on 03/04/2017.
//  Copyright © 2017 Sinisa Vukovic. All rights reserved.
//

import UIKit
import MapKit

class CustomAnnotationView: MKAnnotationView {

    // Required for MKAnnotationView
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // Called when drawing the AttractionAnnotationView
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        
    }

}

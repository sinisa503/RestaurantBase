//
//  ImagePickerVC.swift
//  Restaurant Base
//
//  Created by Sinisa Vukovic on 03/04/2017.
//  Copyright © 2017 Sinisa Vukovic. All rights reserved.
//

import UIKit

class ImagePickerVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    
    var camera: UIImagePickerController?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func viewDidAppear(_ animated: Bool) {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            camera = UIImagePickerController()
            camera?.delegate = self
            camera?.sourceType = .camera
            camera?.allowsEditing = true
        }
    }
    
    //MARK: Image picker controller delegate
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage{
                
        }
    }
}

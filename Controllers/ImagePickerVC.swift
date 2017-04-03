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
        navigationController?.navigationBar.backgroundColor = UIColor.clear
        // Do any additional setup after loading the view.
    }
    
    func startCamera () {
        if let camera = camera {
            present(camera, animated: true, completion: nil)
        }
    }
    
    //MARK: Image picker controller delegate
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage{
            if let pickedImage = UIImagePNGRepresentation(image) as Data? {
                imagePicked(data: pickedImage)
            }
        }
    }
    
    //function to overide in subclass
    func imagePicked(data: Data) {
    }
}

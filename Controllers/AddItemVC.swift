//
//  AddItemVC.swift
//  Restaurant Base
//
//  Created by Sinisa Vukovic on 01/04/2017.
//  Copyright © 2017 Sinisa Vukovic. All rights reserved.
//

import UIKit
import CoreLocation
import CoreData

class AddItemVC: ImagePickerVC, UITextFieldDelegate, CLLocationManagerDelegate {
    
    @IBOutlet weak var nameLabel: UITextField!
    @IBOutlet weak var addressLabel: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var pickLabel: UILabel!
    
    var managedContext: NSManagedObjectContext?
    private let persistance = PerstistenceManager.sharedInstance
    private var locationManager = CLLocationManager()
    private var location: CLLocationCoordinate2D? = nil
    private var selectedImagePath: String?
    private var pickedImage: NSData?
    private var restaurant: Restaurant? {
        didSet {
            if let restaurant = restaurant {
                if let image = pickedImage {
                    persistance.updateDatabaseWith(restaurant: restaurant, andImage: image as Data?)
                }else {
                    persistance.updateDatabaseWith(restaurant: restaurant, andImage: nil)
                }
                navigationController?.popToRootViewController(animated: true)
            }
        }
    }
    
    override func viewDidLoad() {
        navigationController?.navigationBar.backgroundColor = UIColor.blue
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            camera = UIImagePickerController()
            camera?.delegate = self
            camera?.sourceType = .camera
            camera?.allowsEditing = true
        }
    }
    
    @IBAction func addImage(_ sender: UIButton) {
        super.startCamera()
    }
    
    @IBAction func save(_ sender: UIButton) {
        createRestaurant()
        pickedImage = nil
    }
    
    /** Presenting Alert **/
    private func invalidAlert(title: String, messagge: String) {
        let alertView = UIAlertController(title: title, message: messagge, preferredStyle: .alert)
        alertView.addAction(UIAlertAction(title: "OK", style: .default , handler: { (action) in
            alertView.dismiss(animated: true, completion: nil)
        }))
        present(alertView, animated: true, completion: nil)
    }
    
    /** Create new restaurant if all fields are filled **/
    private func createRestaurant() {
        if  nameLabel.text == "" {
            invalidAlert(title: "Name invalid!", messagge: "You must enter restaurant's name")
        }else if addressLabel.text == ""{
            invalidAlert(title: "Address invalid!", messagge: "You must enter restaurant's address")
        } else {
            if let longitude = location?.longitude, let latitude = location?.latitude {
                restaurant = Restaurant(name: nameLabel.text!, address: addressLabel.text!, longitude: Double(longitude), latitude: Double(latitude))
            }
        }
    }
    
    /** overiden from controler model - returnes picked image **/
    override func imagePicked(data: Data) {
        let image = UIImage(data: data)
        imageView.image = image
        pickedImage = data as NSData?
        pickLabel.text = ""
        dismiss(animated: true, completion: nil)
    }
    
    //MARK: TextField delegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    //Dissable keyboard when touched somewhere else
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    //MARK: CLLocation delegate
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        location = CLLocationCoordinate2D(latitude: locations[0].coordinate.latitude, longitude: locations[0].coordinate.longitude)
    }
}

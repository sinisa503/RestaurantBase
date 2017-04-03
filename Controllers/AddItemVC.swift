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
                persistance.updateDatabaseWith(restaurant: restaurant, andImage: pickedImage as Data?)
                //updateDatabase(newRestoran: restaurant, with: pickedImage)
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
    
    @IBAction func addImage(_ sender: UIButton) {
        if let camera = camera {
            present(camera, animated: true, completion: nil)
        }
    }
    
    @IBAction func save(_ sender: UIButton) {
        createRestaurant()
    }
    
    private func invalidAlert(title: String, messagge: String) {
        let alertView = UIAlertController(title: title, message: messagge, preferredStyle: .alert)
        alertView.addAction(UIAlertAction(title: "OK", style: .default , handler: { (action) in
            alertView.dismiss(animated: true, completion: nil)
        }))
        present(alertView, animated: true, completion: nil)
    }
    
    private func updateDatabase (newRestoran: Restaurant, with imageData: NSData?) {
        managedContext?.perform({ [weak self] in
            if let restoran =  NSEntityDescription.insertNewObject(forEntityName: DataBaseConstants.ENTITY_RESTAURANT, into: (self?.managedContext!)!) as? Restoran {
                restoran.name = newRestoran.name
                restoran.address = newRestoran.address
                restoran.longitude = newRestoran.longitude
                restoran.latitude = newRestoran.latitude
                if let image = imageData {
                    restoran.image = image
                }
            }
            do {
                try self?.managedContext?.save()
            }catch let error {
                print("Error with saveing data. Messagge: \(error.localizedDescription)")
            }
        })
    }
    
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
    
    //MARK: Image picker controller delegate
    
    override func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage{
            imageView.image = image
            pickedImage = UIImagePNGRepresentation(image) as NSData?
            pickLabel.text = ""
        }
        dismiss(animated: true, completion: nil)
    }
    
    //MARK: TextField delegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        createRestaurant()
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    //MARK: CLLocation delegate
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        location = CLLocationCoordinate2D(latitude: locations[0].coordinate.latitude, longitude: locations[0].coordinate.longitude)
    }
}

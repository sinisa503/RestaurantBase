//
//  DetailViewController.swift
//  Restaurant Base
//
//  Created by Sinisa Vukovic on 28/03/2017.
//  Copyright © 2017 Sinisa Vukovic. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class MapVC: ImagePickerVC, MKMapViewDelegate, CLLocationManagerDelegate {
    
    @IBOutlet weak var map: MKMapView!
    
    private var locationManager = CLLocationManager()
    private let persistance = PerstistenceManager.sharedInstance
    private var existingRestaurants: [Restoran]? = nil
    var restaurant: Restaurant?
    private var imageForPin: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        map.delegate = self
        locationManager.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        locationAuthStatus()
    }
    
    /** After selecting restaurant go to it's location on map **/
    func configureView() {
        existingRestaurants = persistance.allRestaurantsFromDatabase()
        if let restaurant = restaurant {
            let location = CLLocationCoordinate2D(latitude: restaurant.latitude, longitude: restaurant.longitude)
            zoomMapTo(location: location)
        }
        if let restaurantArray = existingRestaurants {
            for restaurant in restaurantArray {
                addAnotationTo(restoran: restaurant)
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            map.showsUserLocation = true
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
            configureView()
        }
    }
    
    func locationAuthStatus() {
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            map.showsUserLocation = true
            self.configureView()
        } else {
            locationManager.requestWhenInUseAuthorization()
        }
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation
        {
            return nil
        }
        var annotationView = map.dequeueReusableAnnotationView(withIdentifier: "Pin")
        if annotationView == nil{
            annotationView = CustomAnnotationView(annotation: annotation, reuseIdentifier: "Pin")
            annotationView?.canShowCallout = true
            
            
            let button = UIButton(type: .detailDisclosure)
            button.addTarget(self, action: #selector(claaIt), for: .touchUpInside)
            annotationView?.rightCalloutAccessoryView = button
            
        }else{
            annotationView?.annotation = annotation
        }
        
        if let pinImage = imageForPin {
            let size = CGSize(width: 50, height: 50)
            UIGraphicsBeginImageContext(size)
            pinImage.draw(in: CGRect(x: 0, y: 0, width: 25, height: 30))
            let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            annotationView?.image = resizedImage
        }
        
        return annotationView
    }
    
    @objc private func claaIt() {

    }
    
    private func addAnotationTo(restoran: Restoran) {
        let annotation = MKPointAnnotation()
        let coordinate = CLLocationCoordinate2D(latitude: restoran.latitude, longitude: restoran.longitude)
        annotation.coordinate = coordinate
        annotation.title = restoran.name
        annotation.subtitle = restoran.address
        imageForPin = UIImage(named: "restAnnot")
        map.addAnnotation(annotation)
    }
    
    private func zoomMapTo(location: CLLocationCoordinate2D){
        let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.03)
        let region = MKCoordinateRegionMake(location, span)
        map.setRegion(region, animated: true)
    }
}


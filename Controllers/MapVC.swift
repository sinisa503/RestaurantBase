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

class MapVC: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {

    @IBOutlet weak var map: MKMapView!
    
    private var locationManager = CLLocationManager()
    var restaurant: Restaurant?
    
    override func viewWillAppear(_ animated: Bool) {
        configureView()
    }
    
    func configureView() {
        if let restaurant = restaurant {
            let location = CLLocationCoordinate2D(latitude: restaurant.latitude, longitude: restaurant.longitude)
            addAnotationTo(location: location)
            zoomMapTo(location: location)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        self.configureView()
    }
    
    private func addAnotationTo(location: CLLocationCoordinate2D) {
        let annotation = MKPointAnnotation()
        annotation.coordinate = location
        annotation.title = restaurant?.name
        annotation.subtitle = restaurant?.address
        map.addAnnotation(annotation)
    }
    
    private func zoomMapTo(location: CLLocationCoordinate2D){
        let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        let region = MKCoordinateRegionMake(location, span)
        map.setRegion(region, animated: true)
    }
}


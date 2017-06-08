//
//  MonstersMapViewController.swift
//  CatchMonsters
//
//  Created by Jorge Rebollo Jimenez on 08/06/17.
//  Copyright © 2017 personal. All rights reserved.
//

import UIKit
import MapKit

class MonstersMapViewController: UIViewController, CLLocationManagerDelegate {
    @IBOutlet weak var canvasMapView: MKMapView!

    var manager = CLLocationManager()
    var updateLocationCount = 0
    let mapDistance: CLLocationDistance = 300
    
    override func viewDidLoad() {
        super.viewDidLoad()
        manager.delegate = self
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            canvasMapView.showsUserLocation = true
            manager.startUpdatingLocation()
        } else {
            manager.requestWhenInUseAuthorization()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: CLLocationManagerDelegate
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if updateLocationCount < 4 {
            userLocation()
            updateLocationCount += 1
        } else {
            manager.stopUpdatingLocation()
        }
    }
    
    @IBAction func updateUserLocationAction(_ sender: UIButton) {
        userLocation()
    }
    
    func userLocation() {
        if (manager.location?.coordinate) != nil {
            let region = MKCoordinateRegionMakeWithDistance(manager.location!.coordinate, mapDistance, mapDistance)
            canvasMapView.setRegion(region, animated: true)
        }
    }
}


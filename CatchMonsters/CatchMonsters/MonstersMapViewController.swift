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
            let region = MKCoordinateRegionMakeWithDistance(manager.location!.coordinate, 1000, 1000)
            canvasMapView.setRegion(region, animated: true)
            updateLocationCount += 1
        } else {
            manager.stopUpdatingLocation()
        }
    }
}


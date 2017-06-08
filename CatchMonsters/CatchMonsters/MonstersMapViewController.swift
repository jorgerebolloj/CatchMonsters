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
    var monsterSpawnTimer: TimeInterval = 5
    
    override func viewDidLoad() {
        super.viewDidLoad()
        manager.delegate = self
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            canvasMapView.showsUserLocation = true
            manager.startUpdatingLocation()
            
            Timer.scheduledTimer(withTimeInterval: monsterSpawnTimer, repeats: true, block: { (timer) in
                if let coordinate = self.manager.location?.coordinate {
                    let annotation = MKPointAnnotation()
                    annotation.coordinate = coordinate
                    annotation.coordinate.latitude += (Double(arc4random_uniform(1000)) - 500.0) / 400000.0
                    annotation.coordinate.longitude += (Double(arc4random_uniform(1000)) - 500.0) / 400000.0
                    self.canvasMapView.addAnnotation(annotation)
                }
            })
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
        if let coordinate = self.manager.location?.coordinate {
            let region = MKCoordinateRegionMakeWithDistance(coordinate, mapDistance, mapDistance)
            canvasMapView.setRegion(region, animated: true)
        }
    }
}


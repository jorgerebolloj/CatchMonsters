//
//  MonstersMapViewController.swift
//  CatchMonsters
//
//  Created by Jorge Rebollo Jimenez on 08/06/17.
//  Copyright © 2017 personal. All rights reserved.
//

import UIKit
import MapKit

class MonstersMapViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    @IBOutlet weak var canvasMapView: MKMapView!

    var manager = CLLocationManager()
    var updateLocationCount = 0
    let mapDistance: CLLocationDistance = 300
    var monsterSpawnTimer: TimeInterval = 5
    var monsters : [Monster] = []
    let captureDistance: CLLocationDistance = 150
    
    override func viewDidLoad() {
        super.viewDidLoad()
        manager.delegate = self
        monsters = getAllTheMonsters()
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            canvasMapView.showsUserLocation = true
            manager.startUpdatingLocation()
            
            Timer.scheduledTimer(withTimeInterval: monsterSpawnTimer, repeats: true, block: { (timer) in
                if let coordinate = self.manager.location?.coordinate {
                    let randomPosition = Int(arc4random_uniform(UInt32(self.monsters.count)))
                    let randomMonster = self.monsters[randomPosition]
                    let annotation = MonsterAnnotation(coordinate: coordinate, monster: randomMonster)
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
    
    // MARK: MapViewDelegate
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: nil)
        if annotation is MKUserLocation {
            annotationView.image = #imageLiteral(resourceName: "ninja")
        } else {
            let monster = (annotation as! MonsterAnnotation).monster
            annotationView.image = UIImage(named: monster.imageFileName!)
        }
        var newFrame = annotationView.frame
        newFrame.size.height = 40
        newFrame.size.width = 40
        annotationView.frame = newFrame
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        mapView.deselectAnnotation(view.annotation!, animated: false)
        if view.annotation! is MKUserLocation {
            return
        }
        let region = MKCoordinateRegionMakeWithDistance(view.annotation!.coordinate, captureDistance, captureDistance)
        canvasMapView.setRegion(region, animated: true)
        if let coordinate = manager.location?.coordinate {
            if MKMapRectContainsPoint(mapView.visibleMapRect, MKMapPointForCoordinate(coordinate)) {
                print("Podemos atrapar el monster")
                let caughtViewController = CaughtViewController()
                caughtViewController.monster = (view.annotation! as! MonsterAnnotation).monster
                present(caughtViewController, animated: true, completion: nil)
            } else {
                print("No podemos atrapar el onster")
            }
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


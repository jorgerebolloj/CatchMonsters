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
    var monsterCleanTimer: TimeInterval = 30
    var monsters : [Monster] = []
    let captureDistance: CLLocationDistance = 50
    var hasStartedTheMap = false
    var totalFrequency = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        manager.delegate = self
        monsters = getAllTheMonsters()
        for monster in monsters {
            totalFrequency += Int(monster.occurrenceLevel!)!
        }
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            setupMap()
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
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            setupMap()
        }
    }
    
    func setupMap() {
        if !hasStartedTheMap {
            hasStartedTheMap = true
            canvasMapView.showsUserLocation = true
            manager.startUpdatingLocation()
            
            Timer.scheduledTimer(withTimeInterval: monsterSpawnTimer, repeats: true, block: { (timer) in
                if let coordinate = self.manager.location?.coordinate {
                    let randomFrequencyNumber = Int(arc4random_uniform(UInt32(self.totalFrequency)))
                    var monsterFrequencyAccumulation = 0
                    var randomMonster: Monster = self.monsters[0]
                    for monster in self.monsters {
                        randomMonster = monster
                        monsterFrequencyAccumulation += Int(randomMonster.frequency)
                        if monsterFrequencyAccumulation >= randomFrequencyNumber {
                            break
                        }
                    }
                    let annotation = MonsterAnnotation(coordinate: coordinate, monster: randomMonster)
                    annotation.coordinate.latitude += (Double(arc4random_uniform(1000)) - 500.0) / 400000.0
                    annotation.coordinate.longitude += (Double(arc4random_uniform(1000)) - 500.0) / 400000.0
                    self.canvasMapView.addAnnotation(annotation)
                }
            })
            Timer.scheduledTimer(withTimeInterval: monsterCleanTimer, repeats: true, block: { (timer) in
                let allAnnotations = self.canvasMapView.annotations
                self.canvasMapView.removeAnnotations(allAnnotations)
            })
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
        mapView.deselectAnnotation(view.annotation!, animated: true)
        if view.annotation! is MKUserLocation {
            return
        }
        let region = MKCoordinateRegionMakeWithDistance(view.annotation!.coordinate, captureDistance, captureDistance)
        canvasMapView.setRegion(region, animated: false)
        if let coordinate = self.manager.location?.coordinate {
            let monster = (view.annotation! as! MonsterAnnotation).monster
            if MKMapRectContainsPoint(mapView.visibleMapRect, MKMapPointForCoordinate(coordinate)) {
                let caughtViewController = CaughtViewController()
                caughtViewController.monster = monster
                present(caughtViewController, animated: true, completion: { 
                    self.canvasMapView.removeAnnotation(view.annotation!)
                })
            } else {
                let alertController = UIAlertController(title: "Fuera de alcance", message: "Acertcate a \(monster.name!) para atraparlo", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
                alertController.addAction(okAction)
                present(alertController, animated: true, completion: nil)
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


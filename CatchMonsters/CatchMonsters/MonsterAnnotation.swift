//
//  MonsterAnnotation.swift
//  CatchMonsters
//
//  Created by Jorge Rebollo Jimenez on 08/06/17.
//  Copyright © 2017 personal. All rights reserved.
//

import UIKit
import MapKit

class MonsterAnnotation: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    var monster: Monster
    
    init(coordinate: CLLocationCoordinate2D, monster: Monster) {
        self.coordinate = coordinate
        self.monster = monster
    }
}

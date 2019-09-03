//
//  LocationAnnotation.swift
//  FIT5140_Ass1
//
//  Created by 匡正 on 2/9/19.
//  Copyright © 2019 匡正. All rights reserved.
//

import UIKit
import MapKit

class LocationAnnotation: NSObject, MKAnnotation {

    var coordinate: CLLocationCoordinate2D
    var title: String?
    var subtitle: String?
    var iconName: String?
    
    init(newTitle: String, newSubtitle: String, lat: Double, long: Double, iconName: String) {
        self.title = newTitle
        self.subtitle = newSubtitle
        self.iconName = iconName
        coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
    }
 
}

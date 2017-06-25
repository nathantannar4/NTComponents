//
//  MapViewController.swift
//  NTComponents
//
//  Created by Nathan Tannar on 4/27/17.
//  Copyright © 2017 Nathan Tannar. All rights reserved.
//

import NTComponents
import MapKit
import CoreLocation

class MapViewController: NTMapViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let coord = CLLocationCoordinate2D(latitude: 37.232331410000002, longitude: -122.0312186)
        let ann = NTMapAnnotation(title: "Title", subtitle: "Subtitle", coordinate: coord)
        mapView.addAnnotation(ann)
        centerMapToUser(animated: true)
    }
}

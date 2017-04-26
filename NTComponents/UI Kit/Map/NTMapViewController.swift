//
//  NTMapViewController.swift
//  NTComponents
//
//  Copyright © 2017 Nathan Tannar.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.
//
//  Created by Nathan Tannar on 4/24/17.
//

import MapKit
import CoreLocation

open class NTMapViewController: NTViewController, MKMapViewDelegate, CLLocationManagerDelegate {

    open var mapView: NTMapView = {
        let mapView = NTMapView()
        mapView.showsCompass = true
        mapView.showsUserLocation = true
        return mapView
    }()

    open var locationManager: CLLocationManager = {
        let manager = CLLocationManager()
        manager.desiredAccuracy = kCLLocationAccuracyBest
        return manager
    }()

    open var searchBar: NTSearchBarView = {
        let searchBar = NTSearchBarView()
        return searchBar
    }()

    // MARK: - Standard Methods

    open override func viewDidLoad() {
        super.viewDidLoad()

        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()

        mapView.delegate = self
        view.addSubview(mapView)
        mapView.fillSuperview()

        mapView.addSubview(searchBar)
        
        searchBar.anchor(mapView.topAnchor, left: mapView.leftAnchor, bottom: nil, right: mapView.rightAnchor, topConstant: 60, leftConstant: 30, bottomConstant: 0, rightConstant: 30, widthConstant: 0, heightConstant: 44)
    }

    // MARK: - MKMapViewDelegate
    
    public func mapView(_ mapView: MKMapView, regionWillChangeAnimated animated: Bool) {
        searchBar.searchField.resignFirstResponder()
    }

    // MARK: - CLLocationManagerDelegate

    open func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.last
        guard let latitude = location?.coordinate.latitude, let longitude = location?.coordinate.longitude else {
            return
        }
        let center = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02))

//        mapView.setRegion(region, animated: true)
    }

    open func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        Log.write(.error, error.localizedDescription)
    }
}

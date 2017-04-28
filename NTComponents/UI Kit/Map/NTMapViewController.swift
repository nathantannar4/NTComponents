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

open class NTMapViewController: NTViewController, MKMapViewDelegate, CLLocationManagerDelegate, UITableViewDataSource, UITableViewDelegate, NTSearchBarViewDelegate {

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

    open var tableView: NTTableView = {
        let tableView = NTTableView()
        tableView.backgroundColor = Color.Default.Background.View
        tableView.contentInset.top = 10
        tableView.contentOffset = CGPoint(x: 0, y: -10)
        tableView.scrollIndicatorInsets.top = 10
        return tableView
    }()

    // MARK: - Standard Methods

    open override func viewDidLoad() {
        super.viewDidLoad()

        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()

        mapView.delegate = self
        view.addSubview(mapView)
        mapView.fillSuperview()

        searchBar.delegate = self
        view.addSubview(searchBar)
        
        if let parent = parent as? NTScrollableTabBarController, parent.tabBarPosition == .top {
            searchBar.anchor(view.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 24 + parent.tabBarHeight, leftConstant: 16, bottomConstant: 0, rightConstant: 16, widthConstant: 0, heightConstant: 38)
        } else {
            searchBar.anchor(view.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 24, leftConstant: 16, bottomConstant: 0, rightConstant: 16, widthConstant: 0, heightConstant: 38)
        }
        
        

        tableView.delegate = self
        tableView.dataSource = self
        view.insertSubview(tableView, belowSubview: searchBar)
        tableView.anchor(searchBar.bottomAnchor, left: searchBar.leftAnchor, bottom: nil, right: searchBar.rightAnchor, topConstant: -10, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        tableView.setDefaultShadow()
        tableView.layer.cornerRadius = 5
    }

    // MARK: - NTSearchBarViewDelegate

    open func searchBar(_ searchBar: NTTextField, didUpdateSearchFor query: String) -> Bool {
        Log.write(.status, "Searched for \(query)")

        let origin = tableView.frame.origin
        let bounds = tableView.bounds
        let height = (tableView.numberOfRows(inSection: 0) * 36) + 10
       
        UIView.animate(withDuration: 0.3, animations: {
            self.tableView.frame = CGRect(origin: origin, size: CGSize(width: bounds.width, height: CGFloat(height)))
        })
        return true
    }

    open func searchBarDidBeginEditing(_ searchBar: NTTextField) {

    }

    open func searchBarDidEndEditing(_ searchBar: NTTextField) {

        let origin = tableView.frame.origin
        let bounds = tableView.bounds

        UIView.animate(withDuration: 0.3) {
            self.tableView.frame = CGRect(origin: origin, size: CGSize(width: bounds.width, height: 0))
        }
    }

    // MARK: - MKMapViewDelegate

    open func mapView(_ mapView: MKMapView, regionWillChangeAnimated animated: Bool) {
        searchBar.endSearchEditing()
    }

    open func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let reuseIdentifier = "pin"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseIdentifier)

        if annotationView == nil {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: reuseIdentifier)
            annotationView?.canShowCallout = true
        } else {
            annotationView?.annotation = annotation
        }

//        let customPointAnnotation = annotation as! CustomPointAnnotation
//        annotationView?.image = UIImage(named: customPointAnnotation.pinCustomImageName)

        return annotationView
    }


    // MARK: - CLLocationManagerDelegate

    open func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.last
        guard let latitude = location?.coordinate.latitude, let longitude = location?.coordinate.longitude else {
            return
        }
        let center = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        _ = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02))

//        mapView.setRegion(region, animated: true)
    }

    open func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        Log.write(.error, error.localizedDescription)
    }
    
    public func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedAlways, .authorizedWhenInUse:
            // Location services are authorised, track the user.
            locationManager.startUpdatingLocation()
            mapView.showsUserLocation = true
            Log.write(.status, "Location use authorized")
            
        case .denied, .restricted:
            // Location services not authorised, stop tracking the user.
            locationManager.stopUpdatingLocation()
            mapView.showsUserLocation = false
            Log.write(.warning, "Location use NOT authorized")
            
        default:
            // Location services pending authorisation.
            // Alert requesting access is visible at this point.
            break
        }
    }

    // MARK: - UITableViewDataSource

    final public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 36
    }

    final public func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    open func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }

    open func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return NTTableViewCell()
    }

    // MAKR: - UITableViewDelegate

    open func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        Log.write(.status, "Selected row at index path \(indexPath)")
    }
}

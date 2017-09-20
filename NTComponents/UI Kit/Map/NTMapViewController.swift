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
    
    open var centerUserButton: NTButton = {
        let button = NTButton()
        button.trackTouchLocation = false
        button.ripplePercent = 1
        button.image = Icon.Target?.scale(to:  40)
        button.backgroundColor = .white
        button.setDefaultShadow()
        button.layer.cornerRadius = 25
        return button
    }()

    // MARK: - Initialization
    
    convenience init() {
        self.init(nibName: nil, bundle: nil)
    }
    
    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Standard Methods

    open override func viewDidLoad() {
        super.viewDidLoad()

        DispatchQueue.main.async(execute: {
            self.locationManager.startUpdatingLocation()
        })
    }
    
    
    /// Called during initialization
    open func setup() {
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        mapView.delegate = self
        view.addSubview(mapView)
        mapView.fillSuperview()
        mapView.addSubview(centerUserButton)
        centerUserButton.anchor(nil, left: nil, bottom: mapView.bottomAnchor, right: mapView.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 16, rightConstant: 16, widthConstant: 50, heightConstant: 50)
        centerUserButton.addTarget(self, action: #selector(centerMapToUser(animated:)), for: .touchUpInside)
    }

    // MARK: - MKMapViewDelegate

    open func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        guard !annotation.isKind(of: MKUserLocation.self) else {
            return nil
        }
        
        let reuseIdentifier = "PIN"

        var view: NTMapAnnotationView
        if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseIdentifier)
            as? NTMapAnnotationView {
            dequeuedView.annotation = annotation
            dequeuedView.object = (annotation as? NTMapAnnotation)?.object
            view = dequeuedView
        } else {
            view = NTMapAnnotationView(annotation: annotation, reuseIdentifier: reuseIdentifier)
            view.canShowCallout = true
            //view.calloutOffset = CGPoint(x: -5, y: 5)
            view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure) as UIView
        }
        return view
    }
    
    @objc open func centerMapToUser(animated: Bool = true) {
        guard let coordinate = currentLocation() else {
            return
        }
        Log.write(.status, "Centering map to \(coordinate)")
        let latDelta: CLLocationDegrees = 0.02
        let lonDelta: CLLocationDegrees = 0.02
        let span: MKCoordinateSpan = MKCoordinateSpanMake(latDelta, lonDelta)
        let region:MKCoordinateRegion = MKCoordinateRegionMake(coordinate, span)
        mapView.setRegion(region, animated: animated)
    }
    
    open func currentLocation() -> CLLocationCoordinate2D? {
        guard let location = locationManager.location else {
            Log.write(.error, "Failed to get the users current location. Was auth given?")
            return nil
        }
        
        let latitude = location.coordinate.latitude
        let longitude = location.coordinate.longitude
        let coordinate = CLLocationCoordinate2DMake(latitude, longitude)
        return coordinate
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
}

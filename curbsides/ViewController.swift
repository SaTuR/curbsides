//
//  ViewController.swift
//  curbsides
//
//  Created by Ihonahan Buitrago on 2/8/16.
//  Copyright © 2016 NextUniversity. All rights reserved.
//

import UIKit
import MapKit
import AddressBookUI

class ViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    @IBOutlet weak var fullContainer : UIView!
    @IBOutlet weak var mapView : MKMapView!
    @IBOutlet weak var bottomContainer : UIView!
    @IBOutlet weak var assignRegionButton: UIButton!
    @IBOutlet weak var latitudeLabel : UILabel!
    @IBOutlet weak var longitudeLabel : UILabel!
    @IBOutlet weak var radiusSlider : UISlider!
    @IBOutlet weak var addressLabel : UILabel!
    
    var regions = [CLCircularRegion]()
    let locationManager : CLLocationManager = CLLocationManager()
    var currentPoint : CLLocation!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        self.locationManager.delegate = self
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.distanceFilter = 3
        
        self.mapView.delegate = self
        self.mapView.showsUserLocation = true
        self.mapView.camera.altitude = 2000
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    @IBAction func tapUpAssign(_ sender: UIButton) {
        let currentRegionIdentifier = "CircularRegion\(self.regions.count)"
        
        let radius = CLLocationDistance(self.radiusSlider.value)
        let currentRegion = CLCircularRegion(center: self.currentPoint.coordinate, radius: radius, identifier: currentRegionIdentifier)
        self.regions.append(currentRegion)
        
        self.mapView.add(MKCircle(center: self.currentPoint.coordinate, radius: radius))
        
        self.latitudeLabel.text = "Lat.: \(self.currentPoint.coordinate.latitude)"
        self.longitudeLabel.text = "Lon.: \(self.currentPoint.coordinate.longitude)"
        
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(currentPoint, completionHandler: { (placemarks, error) in
            
            if error != nil {
                print("Error: \(error?.localizedDescription)")
            }else {
                if let placemark = placemarks?.last {
                    if let addressLine = (placemark.addressDictionary?["FormattedAddressLines"] as? [String]) {
                        self.addressLabel.text = addressLine.joined(separator: ", ")
                    }
                }
            }
        })

    }
    
    
    //MARK:- CLLocationManagerDelegate methods
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        print("Nueva autorización: \(status.rawValue)")
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            self.currentPoint = location
            self.mapView.centerCoordinate = location.coordinate
        }
    }
    
    
    
    //MARK:- MKMapViewDelegate methods
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if overlay is MKCircle {
            let renderer = MKCircleRenderer(overlay: overlay)
            renderer.lineWidth = 2
            renderer.strokeColor = UIColor.green
            renderer.fillColor = UIColor(red: 0, green: 0.9, blue: 0.5, alpha: 0.4)
            return renderer
        } else {
            return MKOverlayRenderer(overlay: overlay)
        }
    }
    

    
}


//
//  MapViewController.swift
//  Weather
//
//  Created by Jacob Roscoe on 2020/7/1.
//  Copyright © 2020 ColorTV. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController {

    // MARK: - UI Components
    @IBOutlet weak var mapView: MKMapView!
    
    // MARK: - Private Variables
    private let locationManager = CLLocationManager()
    private let geoCoder = CLGeocoder()
    private let segueIdentifier = "gotoDetail"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if  segue.identifier == segueIdentifier,
            let detailVC = segue.destination as? DetailViewController,
            let coordinate = sender as? CLLocationCoordinate2D {
            
            detailVC.lat = coordinate.latitude
            detailVC.lon = coordinate.longitude
        }
    }    

    // MARK: - Private Functions
    private func setupUI() {
        mapView.showsUserLocation = true
        
        let longpressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress))
        mapView.addGestureRecognizer(longpressGesture)
    }
    
    @objc private func handleLongPress(_ sender: UITapGestureRecognizer) {
        
        if sender.state == .began {

            mapView.removeAnnotations(mapView.annotations)
            
            let touchPoint = sender.location(in: mapView)
            let touchCoordinate = mapView.convert(touchPoint, toCoordinateFrom: self.mapView)
            let annotation = MKPointAnnotation()
            annotation.coordinate = touchCoordinate
            mapView.addAnnotation(annotation) //drops the pin
            
            print("lat:  \(touchCoordinate.latitude)")
            print("long: \(touchCoordinate.longitude)")

            performSegue(withIdentifier: segueIdentifier, sender: touchCoordinate)
        }
    }
}

//
//  MapViewController.swift
//  JeuxAESD
//
//  Created by Nicolas Gnyra on 17-04-05.
//  Copyright © 2017 Nicolas Gnyra. All rights reserved.


import UIKit
import MapKit
import Darwin
import Mapbox

class MapViewController: UIViewController, MGLMapViewDelegate, CLLocationManagerDelegate {
    @IBOutlet weak var mapView: MGLMapView!
    
    private var minLatitude:  Double =  43.92336814129912
    private var maxLatitude:  Double =  43.92806636084152
    private var minLongitude: Double = -79.22172546386719
    private var maxLongitude: Double = -79.21623229980469
    
    var selectedLocation: Location?
    
    private var locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        if CLLocationManager.locationServicesEnabled() {
            let status: CLAuthorizationStatus = CLLocationManager.authorizationStatus()
            if status == CLAuthorizationStatus.notDetermined {
                locationManager.requestWhenInUseAuthorization()
            }
        } else {
            Logger.info("Location services not enabled")
        }
        
        locationManager.startUpdatingLocation()
        
        mapView.delegate = self
        
        mapView.minimumZoomLevel = 15
        mapView.maximumZoomLevel = 17
        
        mapView.styleURL = URL(string: "mapbox://styles/mapbox/satellite-v9")!
        
        mapView.showsUserLocation = true
        
        APICommunication.onLocationsUpdated.addHandler({ (locations) -> Void in
            Logger.info("Updating Annotations")
            
            for location: Location in locations {
                Logger.verbose("Creating annotation for \(location.name)")
                
                let pointAnnotation: MKPointLocationAnnotation = MKPointLocationAnnotation(location: location)
                pointAnnotation.coordinate = CLLocationCoordinate2DMake(location.latitude, location.longitude)
                pointAnnotation.title = location.name
                
                var subtitle: [String] = [String]()
                
                for activity in location.activities {
                    subtitle.append("\u{2022} \(activity.text)")
                }
                
                pointAnnotation.subtitle = subtitle.joined(separator: "\n")
                
                DispatchQueue.main.async {
                    self.mapView.addAnnotation(pointAnnotation)
                }
            }
            
            Logger.info("Annotations updated.")
            
            DispatchQueue.main.async {
                self.mapView.setNeedsLayout()
                self.mapView.setNeedsDisplay()
            }
        })
        
        resetMapRegion()
        addAnnotationsToMap()
    }
    
    private var progChange = false
    
    func mapView(_ mapView: MGLMapView, shouldChangeFrom oldCamera: MGLMapCamera, to newCamera: MGLMapCamera) -> Bool {
        if newCamera.centerCoordinate.latitude < minLatitude || newCamera.centerCoordinate.latitude > maxLatitude {
            return false
        }
        
        if newCamera.centerCoordinate.longitude < minLongitude || newCamera.centerCoordinate.longitude > maxLongitude {
            return false
        }
        
        return true
    }
    
    private func resetMapRegion() {
        mapView.setCenter(CLLocationCoordinate2D(latitude: (minLatitude + maxLatitude) / 2, longitude: (minLongitude + maxLongitude) / 2), zoomLevel: 15, animated: false)
    }
    
    private func addAnnotationsToMap() {
        if mapView.annotations != nil {
            mapView.removeAnnotations(mapView.annotations!)
        }
        
        APICommunication.loadLocations(forceRefresh: true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if selectedLocation != nil && mapView.annotations != nil {
            // deselect any selected annotations
            for annotation in mapView.selectedAnnotations {
                mapView.deselectAnnotation(annotation, animated: false)
            }
            
            // select annotation with specified location
            for annotation in mapView.annotations! {
                if (annotation.coordinate.latitude == selectedLocation!.latitude && annotation.coordinate.longitude == selectedLocation!.longitude) {
                    mapView.setCenter(CLLocationCoordinate2D(latitude: selectedLocation!.latitude, longitude: selectedLocation!.longitude), animated: false)
                    mapView.selectAnnotation(annotation, animated: true)
                }
            }
        }
    }
    
    func mapView(_ mapView: MGLMapView, annotationCanShowCallout annotation: MGLAnnotation) -> Bool {
        return true
    }
    
    private func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MGLAnnotationView? {
        if annotation.isKind(of: MKUserLocation.self) {
            return nil
        }
        
        // TODO: Pin color
        let annotationView = MGLAnnotationView(reuseIdentifier: nil)
        
        return annotationView
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

//
//  routeMapVC.swift
//  trackerApp
//
//  Created by Asmaa on 05/08/2022.
//

import UIKit
import MapKit
import CoreLocation

class routeMapVC: UIViewController,CLLocationManagerDelegate {

    @IBOutlet weak var routeMap: MKMapView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        let intialLocation = CLLocation(latitude: 31.279246, longitude: 30.016129)
        setStartingLocation(location: intialLocation, distance: 100)
        addAnnotationMark()
        
        if isLocationServiceEnable(){
            checkAuthorization()
        }else{
            shwoAlert(massage: "Please Enable Location Service to check Your Location")
        }

    }
    
    
    func setStartingLocation(location: CLLocation, distance: CLLocationDistance){
        let region = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: distance, longitudinalMeters: distance)
        routeMap.setRegion(region, animated: true)
        routeMap.setCameraBoundary(MKMapView.CameraBoundary(coordinateRegion: region), animated: true)
        let zoomRange = MKMapView.CameraZoomRange(maxCenterCoordinateDistance: 300000)
        routeMap.setCameraZoomRange(zoomRange, animated: true)
    }
    
    func addAnnotationMark(){
        let pin = MKPointAnnotation()
        pin.coordinate = CLLocationCoordinate2D(latitude: 31.279246, longitude: 30.016129)
        pin.title = "My title"
        pin.subtitle = "Pin sub title"
        routeMap.addAnnotation(pin)
    }
    
    func isLocationServiceEnable() -> Bool{
        return CLLocationManager.locationServicesEnabled()
    }
    
    func checkAuthorization(){
        switch CLLocationManager.authorizationStatus() {
        case .notDetermined:
            break
        case .authorizedAlways:
            break
        case .denied:
            break
        case .restricted:
            break
        default:
            break
        }
        
    }
    func shwoAlert(massage: String){
        let alert = UIAlertController(title: "Alert", message: massage, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .default))
        present(alert, animated: true, completion: nil)
    }

}

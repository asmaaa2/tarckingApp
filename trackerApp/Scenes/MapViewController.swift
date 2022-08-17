//
//  MapViewController.swift
//  trackerApp
//
//  Created by Asmaa on 15/08/2022.
//

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController, CLLocationManagerDelegate{

    @IBOutlet weak var mapVC: MKMapView!
    var locationManager = CLLocationManager()
    

    override func viewDidLoad() {
        super.viewDidLoad()

//        let intialLoc = CLLocation(latitude: 24.693719, longitude: 46.723596)
//        setStartingLocation(location: intialLoc, distance: 1000)
        setUp()
//        addAnnotation()
        
        if isLocationServiceEnable(){
            checkAuthorization()
        }else{
            showAlert(massage: "Please Enable Location Service to check Your Location")
        }
        
    }
    
 
    func setUp(){
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.allowsBackgroundLocationUpdates = true

    }
    
//
//    func setStartingLocation(location: CLLocation, distance: CLLocationDistance){
//        let region = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: distance, longitudinalMeters: distance)
//        mapVC.setRegion(region, animated: true)
//        mapVC.setCameraBoundary(MKMapView.CameraBoundary(coordinateRegion: region), animated: true)
//        let zoomRange = MKMapView.CameraZoomRange(maxCenterCoordinateDistance: 30000)
//        mapVC.setCameraZoomRange(zoomRange, animated: true)
//    }
//
//    func addAnnotation(){
//        let pin = MKPointAnnotation()
//        pin.coordinate = CLLocationCoordinate2D(latitude: 24.693719, longitude: 46.723596)
//        pin.title = "MY Title"
//        pin.subtitle = "My Pin Subtitle"
//        mapVC.addAnnotation(pin)
//    }
//
    func isLocationServiceEnable() -> Bool{
        return CLLocationManager.locationServicesEnabled()
    }
    
    func checkAuthorization(){
        switch locationManager.authorizationStatus {
        case .notDetermined:
            locationManager.requestAlwaysAuthorization()
            break
        case .authorizedWhenInUse:
            locationManager.requestAlwaysAuthorization()
            locationManager.startUpdatingLocation()
//            centerViewOnUserLocation()
            mapVC.showsUserLocation = true
            break
        case .authorizedAlways:
            locationManager.startUpdatingLocation()
            mapVC.showsUserLocation = true
            break
        case .denied:
            showAlert(massage: "Please do access location")
            break
        case .restricted:
            showAlert(massage: "Authorization restricted")
            break
        default:
            print("defult option")
            break
        }
        
    }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last{
            print("location: \(location.coordinate)")
            zoomToUserLocation(location: location)
        }
        locationManager.stopUpdatingLocation()
    }
    
    
    func zoomToUserLocation(location: CLLocation){
        let region = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: 500, longitudinalMeters: 500)
        mapVC.setRegion(region, animated: true)
    }

    
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus){
        switch status {
        case .authorizedWhenInUse:
            locationManager.requestAlwaysAuthorization()
            locationManager.startUpdatingLocation()
            mapVC.showsUserLocation = true
            break
        case .authorizedAlways:
            locationManager.startUpdatingLocation()
            mapVC.showsUserLocation = true
            break
        case .denied:
            showAlert(massage: "Please do access location")
            break
        default:
            print("defult option")
            break
        }
    }
    
    func showAlert(massage: String){
        let alert = UIAlertController(title: "Alert", message: massage, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .default))
        present(alert, animated: true, completion: nil)
    }
    
    
}

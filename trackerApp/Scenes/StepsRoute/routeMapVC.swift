//
//  routeMapVC.swift
//  trackerApp
//
//  Created by Asmaa on 05/08/2022.
//

import UIKit
import MapKit
import CoreLocation

@available(iOS 14.0, *)

class CustomPin: NSObject , MKAnnotation {
    
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var subtitle: String?
    
    
    init(pinTitle: String, pinSubtitle: String, location: CLLocationCoordinate2D) {
        self.title = pinTitle
        self.subtitle = pinSubtitle
        self.coordinate = location
        
    }
}
class routeMapVC: UIViewController,CLLocationManagerDelegate, MKMapViewDelegate {

    @IBOutlet weak var routeMap: MKMapView!
    
    var locationManager = CLLocationManager()
    var startPoint = CLLocationCoordinate2D()
    var lastPoint = CLLocationCoordinate2D()
    var currentLocation : CLLocation?
    var isLocationUpdated = false
    var timer: Timer?
    var count = 5{
        didSet{
            if count == 0 {
                Timer.invalidate(timer!)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        routeMap.delegate = self
        routeMap.showsUserLocation = true
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyReduced
        
       timer =  Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateCounter), userInfo: nil, repeats: true)




        if isLocationServiceEnable(){
            checkAuthorization()
        }else{
            showAlert(massage: "Please Enable Location Service to check Your Location")
        }
        
        locationManager.allowsBackgroundLocationUpdates = true
        
    }
    
   @objc func updateCounter() {
        if(count > 0) {
            count -= 1
        }
    
    print("count: \(count)")
    }
    
    

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
            routeMap.showsUserLocation = true
            break
        case .authorizedAlways:
            locationManager.startUpdatingLocation()
            routeMap.showsUserLocation = true
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
        
        currentLocation = locations.last!
        
        if (!isLocationUpdated){
            isLocationUpdated = true
        }
        
        
        
        
        

        if let location = locations.last{
            print("location: \(location.coordinate)")
            startPoint = locations.first!.coordinate
            zoomToUserLocation(location: location)
            
            // 37.33596949585537
            // -122.00966921375925
            
            setupMapView(stLat: 37.33596949585537, stLong: -122.00966921375925, lastLat: location.coordinate.latitude, lastLong: location.coordinate.longitude)
            
//            locationManager.stopUpdatingLocation()

        }
//        locationManager.stopUpdatingLocation()
        
    }
    
    
    func zoomToUserLocation(location: CLLocation){
        let region = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: 500, longitudinalMeters: 500)
        routeMap.setRegion(region, animated: true)
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedWhenInUse:
            locationManager.requestAlwaysAuthorization()
            locationManager.startUpdatingLocation()
            routeMap.showsUserLocation = true
            break
        case .authorizedAlways:
            locationManager.startUpdatingLocation()
            routeMap.showsUserLocation = true
            break
        case .denied:
            showAlert(massage: "Please do access location")
            break
        default:
            print("defult option")
            break
        }
    }
    

    
    
    private func setupMapView(stLat: Double, stLong: Double , lastLat: Double, lastLong: Double){
            
        // 37.33596949585537
        // -122.00966921375925
            
            let sourceLocation = CLLocationCoordinate2D(latitude: stLat, longitude: stLong)
            let destinationLocation = CLLocationCoordinate2D(latitude:  lastLat, longitude: lastLong)
            
            let soursePin = CustomPin(pinTitle: " ", pinSubtitle: " ", location: sourceLocation)
            let destinationPin = CustomPin(pinTitle: " ", pinSubtitle: " ", location: destinationLocation)
            
            self.routeMap.removeAnnotations(routeMap.annotations.filter { $0 !== routeMap.userLocation })
            
            
            self.routeMap.addAnnotation(soursePin)
            self.routeMap.addAnnotation(destinationPin)
            
            let sourcePlaceMark = MKPlacemark(coordinate: sourceLocation)
            
            let destinationPlaceMark = MKPlacemark(coordinate: destinationLocation)
            
            let directionRequest = MKDirections.Request()
            directionRequest.source = MKMapItem(placemark: sourcePlaceMark)
            directionRequest.destination = MKMapItem(placemark: destinationPlaceMark)
            directionRequest.transportType = .automobile
            
            let directions = MKDirections(request: directionRequest)
            directions.calculate { (respons, err) in
                guard let diractionRespons = respons else {
                    if let err = err {
                        print("We have error getting dircation: \(err.localizedDescription)")
                    }
                    return
                }
                
                let rout = diractionRespons.routes[0]
                
                self.routeMap.removeOverlays(self.routeMap.overlays)
                self.routeMap.addOverlay(rout.polyline, level: .aboveRoads)
                let rect = rout.polyline.boundingMapRect
                
                self.routeMap.setRegion(MKCoordinateRegion(rect), animated: true)
            }
            
            
            self.routeMap.delegate = self
            
        }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
            
            let renderer =  MKPolylineRenderer(overlay: overlay)
            
            renderer.strokeColor = .systemBlue
            renderer.lineWidth = 4
            
            return renderer
        }
    
    
    
    
    
    func showAlert(massage: String){
        let alert = UIAlertController(title: "Alert", message: massage, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .default))
        present(alert, animated: true, completion: nil)
    }

}

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
    var startPoint = CLLocation()
    var lastPoint = CLLocation()
    var currentLocation : CLLocation?
    var testcoords:[CLLocationCoordinate2D] = []
    var isLocationUpdated : Bool?
    var timer: Timer?
    var countFiveMin = 5
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
        timer =  Timer.scheduledTimer(timeInterval: 60.0, target: self, selector: #selector(updateCounter), userInfo: nil, repeats: false)
        
        if isLocationServiceEnable(){
            checkAuthorization()
        }else{
            showAlert(massage: "Please Enable Location Service to check Your Location")
        }
        
        
    }
    
    func setUp(){
        routeMap.delegate = self
        routeMap.showsUserLocation = true
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
        locationManager.requestAlwaysAuthorization()
        locationManager.allowsBackgroundLocationUpdates = true
        locationManager.pausesLocationUpdatesAutomatically = false
    }
    
    @objc func updateCounter() {
        if(countFiveMin > 0) {
            countFiveMin -= 1
        }else if countFiveMin == 0{
            timer?.invalidate()
        }
        print("count: \(countFiveMin)")
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
            centerViewOnUserLocation()
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
    
    
    private func centerViewOnUserLocation(){
        if let location = locationManager.location?.coordinate{
            let region = MKCoordinateRegion(center: location, latitudinalMeters: 30000, longitudinalMeters: 30000)
            routeMap.setRegion(region, animated: true)
            
        }
    }
    
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if let location = locations.last{
            print("location: \(location.coordinate)")
            
            for location in locations{
                testcoords.append(location.coordinate)
                startPoint = locations[0]
                
            }
            
            if (lastPoint.coordinate.latitude != locations.last?.coordinate.latitude) && (lastPoint.coordinate.longitude != locations.last?.coordinate.longitude) {
                self.lastPoint = location
                print("Moveing")
                print("locations.array: \(testcoords)")
                print("zeroLoc: \(testcoords[0].latitude)")
                let locationsLine = MKPolyline(coordinates: testcoords, count: testcoords.count)
                routeMap.addOverlay(locationsLine)
                
                
            }else{
                print("Stop move")
                
                updateCounter()
                lastPoint = locations.last!
                
                locationManager.stopUpdatingLocation()
                print("zeroLoc2: \(locations[0])")
                FirebaseRequest.writeLocation(startPointValue: startPoint, endPointValue: lastPoint)
            }
        }
        
        let zoomRange = MKMapView.CameraZoomRange(minCenterCoordinateDistance: 5000)
        //        (maxCenterCoordinateDistance: 30000)
        routeMap.setCameraZoomRange(zoomRange, animated: true)
        setupMapView(stLat: testcoords[0].latitude, stLong: testcoords[0].longitude, lastLat: lastPoint.coordinate.latitude, lastLong: lastPoint.coordinate.longitude)
        
        
    }
    
    
    func zoomToUserLocation(location: CLLocation){
        let region = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: 1000, longitudinalMeters: 1000)
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
    
    
    
    
    func setupMapView(stLat: Double, stLong: Double , lastLat: Double, lastLong: Double){
        
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
        if let polyline = overlay as? MKPolyline {
            let testlineRenderer = MKPolylineRenderer(polyline: polyline)
            testlineRenderer.strokeColor = .systemGreen
            testlineRenderer.lineWidth = 10.0
            return testlineRenderer
        }
        fatalError("Something wrong during draw line...")
    }
    
    
    func showAlert(massage: String){
        let alert = UIAlertController(title: "Alert", message: massage, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .default))
        present(alert, animated: true, completion: nil)
    }
    
    
}

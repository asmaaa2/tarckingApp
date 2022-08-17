//
//  PolylineTestViewController.swift
//  trackerApp
//
//  Created by Asmaa on 16/08/2022.
//

import UIKit
import MapKit
import CoreLocation


class PolylineTestViewController: UIViewController, MKMapViewDelegate{
    
    @IBOutlet weak var polylineMap: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        let coords1 = CLLocationCoordinate2D(latitude: 52.167894, longitude: 17.077399)
        let coords2 = CLLocationCoordinate2D(latitude: 52.168776, longitude: 17.081326)
        let coords3 = CLLocationCoordinate2D(latitude: 52.167921, longitude: 17.083730)
        let testcoords:[CLLocationCoordinate2D] = [coords1,coords2,coords3]
        
        let testline = MKPolyline(coordinates: testcoords, count: testcoords.count)
        //Add `MKPolyLine` as an overlay.
        polylineMap.addOverlay(testline)
        
        polylineMap.delegate = self // done
        
//        polylineMap.centerCoordinate = coords2 // done
        polylineMap.region = MKCoordinateRegion(center: coords2, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)) //done
    }
    //done
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        //Return an `MKPolylineRenderer` for the `MKPolyline` in the `MKMapViewDelegate`s method
        if let polyline = overlay as? MKPolyline {
            let testlineRenderer = MKPolylineRenderer(polyline: polyline)
            testlineRenderer.strokeColor = .systemGreen
            testlineRenderer.lineWidth = 5.0
            return testlineRenderer
        }
        fatalError("Something wrong...")
        //return MKOverlayRenderer()
    }
    
    
    
    
}

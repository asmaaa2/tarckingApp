//
//  FirebaseRequests.swift
//  trackerApp
//
//  Created by Asmaa on 08/08/2022.
//

import Foundation
import UIKit
import FirebaseDatabase
import Firebase
import FirebaseCore
import CoreLocation
import CodableFirebase


class FirebaseRequest{

    //Write Updated Loctions on Firebase
    static func writeLocation(startPointValue: CLLocation, endPointValue: CLLocation){
        let ref = Database.database().reference().child("Locations").childByAutoId()
        let coordinateDataOfStartPoint: [String: Any] = [
            "latitude": Double(startPointValue.coordinate.latitude),
            "longitude": Double(startPointValue.coordinate.longitude)
        ]
        let coordinateDataOfEndPoint: [String: Any] = [
            "latitude": Double(endPointValue.coordinate.latitude),
            "longitude": Double(endPointValue.coordinate.longitude)
        ]
        
        ref.child("startPoint").setValue(coordinateDataOfStartPoint)
        ref.child("endPoint").setValue(coordinateDataOfEndPoint)
        { (err, ref) in
            if err == nil {
                print("Successfully Post in firebase")
                
            }
            
        }
    }
    
  
}




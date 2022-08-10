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

 class FirebaseRequest{
    
    static var locNumbers: Int?
    
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

    
    // Read Locations from Firebase
    static func readLocation(){
            
            let ref = Database.database().reference()
        ref.child("Locations").observe(.childAdded) { (snapshot) in

            print("refKeys: \(snapshot.childrenCount)")
            
            //every ID of every Trip
            let arrOfSnapshotKeys = [snapshot.key].count
            print("snapshotCount: \(arrOfSnapshotKeys)")
            
            snapshot.children.forEach { data in
                print("Data: \(data)")
                
                // End & Start Points - Details of every ID
                let snap = data as! DataSnapshot
                print("snapvalue: \(snap.key)")
                
                //Lat & Log for start and end Points
                guard let dict = snap.value as? [String: Double] else {return}
                print("dict: \(dict)")

                if snap.key == "endPoint"{
                    if let snapshotValue = snap.value as? [String: Double]{
                        
                        if let endPLat = snapshotValue["latitude"] {
                            print("endPoint latitude: \(endPLat)")
        
                        }
                        if let endPLong = snapshotValue["longitude"] {
                            print("endPoint longitude: \(endPLong)")
        
                        }
                        
                    }
                }else{
                    if let snapshotValue = snap.value as? [String: Double]{

                        if let startPLat = snapshotValue["latitude"] {
                            print("startPoint latitude : \(startPLat)")
        
                        }
                        if let startPLong = snapshotValue["longitude"] {
                            print("startPoint longitude: \(startPLong)")
        
                        }
                        
                    }
                }
            }
            
            
            
            
            
            
              
                

                
            }
            
        }
    

     
    }
    
    


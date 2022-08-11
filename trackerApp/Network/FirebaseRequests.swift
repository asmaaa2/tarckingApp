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
    
    static func getAllLocNumbere (tripNum: Int? , endPointValues: [String: Double], startPointValue: [String: Double]) -> (){
        let tripNumbers = tripNum
//        let tripLatLong = tripDetails
        print("tripNum \(tripNum)")
//        print("tripDetails \(tripDetails)")
//        return (tripNumbers, tripLatLong)
    }
    
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
    
    static var dataOfTrips: Int?
    static var snapValueEnd: [String: Double]?
    static var snapValuestart: [String: Double]?
    
    // Read Locations from Firebase

    static func readLocation(){
        
        let ref = Database.database().reference()
        
        //get Numbers of Trips which recorded
        ref.observe(.childAdded) { id in
            let tripsIDsNumbers = id.childrenCount   /////////////////// 1
            dataOfTrips = Int(tripsIDsNumbers)
            print("id: \(tripsIDsNumbers)")
        }
        
        //get all Data Details
        ref.child("Locations").observe(.childAdded) { (snapshot) in
            //every ID of Trips
            let arrOfSnapshotKeys = snapshot.key
            print("snapshotCount: \(arrOfSnapshotKeys)")
            print("snapshot: \(snapshot)")
            
            
            snapshot.children.forEach { data in
                // End & Start Points - Details of every ID
                let snap = data as! DataSnapshot
                print("snapvalue: \(snap)")
                
                
                //Lat & Log for start and end Points
                guard let dict = snap.value as? [String: Double] else {return}
                print("dict: \(dict)")
                
                if snap.key == "endPoint"{
                    if let snapshotValueEnd = snap.value as? [String: Double]{
                        snapValueEnd = snapshotValueEnd
                         print("snapshotValueEnd: \(snapshotValueEnd)")
                        
                        if let endPLat = snapshotValueEnd["latitude"] {
                            print("endPoint latitude: \(endPLat)")     //// 2 endPointLat
                            
                        }
                        if let endPLong = snapshotValueEnd["longitude"] {
                            print("endPoint longitude: \(endPLong)")    ////// 2 endPointLong
                            
                        }
                        
                    }
                }else{
                    if let snapshotValueStart = snap.value as? [String: Double]{
                        snapValuestart = snapshotValueStart
                        print("snapshotValueStart: \(snapshotValueStart)")

                        if let startPLat = snapshotValueStart["latitude"] {
                            print("startPoint latitude : \(startPLat)")    /////// 3 startPointLat
                            
                        }
                        if let startPLong = snapshotValueStart["longitude"] {
                            print("startPoint longitude: \(startPLong)")   /////// 3 startPointLong
                            
                        }
                        
                    }
                }
                if snap.exists(){
                    self.getAllLocNumbere(tripNum: dataOfTrips, endPointValues: snapValuestart!, startPointValue: snapValueEnd!)
                }
                
            }
            
        }
        
    }
    
    
    
}




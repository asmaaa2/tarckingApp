//
//  LocationsModel.swift
//  trackerApp
//
//  Created by Asmaa on 17/08/2022.
//

import Foundation

struct Locations: Codable {
    let locations : [String]?
    
    enum CodingKeys: String, CodingKey{
        case locations = "locations"
    }
}


struct AllLocations: Codable{
    
    let endPoint: [CoorditaesOfLocations]?
    let startPoint: [CoorditaesOfLocations]?
    
    enum CodingKeys: String, CodingKey {

        case endPoint = "endPoint"
        case startPoint = "startPoint"
        
    }
}


struct CoorditaesOfLocations: Codable{
    
    let latitude: Double?
    let  longitude: Double?
    
    enum CodingKeys: String, CodingKey {

        case latitude = "latitude"
        case longitude = "longitude"
        
    }
    
}

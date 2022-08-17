//
//  CLLocationextension.swift
//  trackerApp
//
//  Created by Asmaa on 05/08/2022.
//

import Foundation
import UIKit
import MapKit
import CoreLocation


extension CLLocation {
    convenience init?(_ coordinate2D: CLLocationCoordinate2D) {
        guard CLLocationCoordinate2DIsValid(coordinate2D) else { return nil }
        self.init(latitude: coordinate2D.latitude, longitude: coordinate2D.longitude)
    }
}

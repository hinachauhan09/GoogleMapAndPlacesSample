//
//  LocationManager.swift
//  GoogleMapsWithSwiftUISample
//
//  Created by Alexander Fanaian on 4/12/20.
//  Copyright © 2020 Practice. All rights reserved.
//

import Foundation
import Combine
import CoreLocation

class LocationManager: NSObject, ObservableObject {
    private let locationManager = CLLocationManager()
    @Published var lastKnownLocation: CLLocation? = nil
    
    // 1
     @Published var location: CLLocation? {
       willSet { objectWillChange.send() }
     }
    
    // 2
    var latitude: CLLocationDegrees {
        return location?.coordinate.latitude ?? 0
    }
    
    var longitude: CLLocationDegrees {
        return location?.coordinate.longitude ?? 0
    }
    
    // 3
    override init() {
      super.init()

      locationManager.delegate = self
      locationManager.desiredAccuracy = kCLLocationAccuracyBest
//      locationManager.requestWhenInUseAuthorization()
      locationManager.startUpdatingLocation()
            locationManager.requestAlwaysAuthorization()
            locationManager.distanceFilter = 50
    }
}

extension LocationManager: CLLocationManagerDelegate {
    // 4
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        guard status == .authorizedWhenInUse else {
          return
        }
   
    // 4
    locationManager.startUpdatingLocation()
      
  }
  
  // 6
  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
      // Notify listeners that the user has a new location
      self.lastKnownLocation = locations.last
      
    // 8
//    locationManager.stopUpdatingLocation()
  }
}

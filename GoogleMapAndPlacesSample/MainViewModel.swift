//
//  ContentView-ViewModel.swift
//  GoogleMapAndPlacesSample
//
//  Created by Hina Chauhan on 11/11/22.
//

import Foundation

class MainViewModel : ObservableObject{
    @Published var placeName : String = UserDefaults().value(forKey: Constants.Place.PLACE_NAME) as! String
    @Published var placeAddress : String = UserDefaults().value(forKey: Constants.Place.PLACE_NAME) as! String
    @Published var latLong : Array<Double>? = UserDefaults().array(forKey: Constants.Place.PLACE_NAME) as! [Double]
    @Published var location : (latitude : Double, longitude : Double) = (0,0)
    
    init() {
        location.latitude = latLong?[0] ?? 0
        location.longitude = latLong?[1] ?? 0
    }
    
}


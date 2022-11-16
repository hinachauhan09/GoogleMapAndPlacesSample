//
//  ContentView-ViewModel.swift
//  GoogleMapAndPlacesSample
//
//  Created by Hina Chauhan on 11/11/22.
//

import Foundation
import GoogleMaps
import Contacts

struct Location{
    var latitude : Double = 0.0
    var longitude : Double = 0.0
}
class MainViewModel : ObservableObject{
    @Published var placeName : String = UserDefaults().value(forKey: Constants.Place.PLACE_NAME) as! String
    @Published var placeAddress : String = ""
    @Published var latLong : Array<Double>? = UserDefaults().array(forKey: Constants.Place.PLACE_CO_ORDINATES) as! [Double]
    @Published var location : Location = Location(latitude: 18.52, longitude: 73.853)
    
    init() {
        location.latitude = latLong?[0] ?? 0
        location.longitude = latLong?[1] ?? 0
    }
    
    func fetchAddress()  {
        //        print("hello")
        let geoCoder = CLGeocoder()
        let location = CLLocation(latitude: location.latitude , longitude: location.longitude)
        geoCoder.reverseGeocodeLocation(location, completionHandler: { (placemarks, error) -> Void in
            
            var placeMark: CLPlacemark!
            placeMark = placemarks?[0]
            
            var addressString : String = ""
            
            if placeMark.subThoroughfare != nil {
                addressString = addressString + placeMark.subThoroughfare! + ", "
            }
            if placeMark.thoroughfare != nil {
                addressString = addressString + placeMark.thoroughfare! + ", "
            }
            if placeMark.subLocality != nil {
                addressString = addressString + placeMark.subLocality! + ", "
            }
            
            if placeMark.locality != nil {
                addressString = addressString + placeMark.locality! + ", "
            }
            if placeMark.administrativeArea != nil {
                addressString = addressString + placeMark.administrativeArea! + ", "
            }
            if placeMark.country != nil {
                addressString = addressString + placeMark.country! + ", "
            }
            if placeMark.postalCode != nil {
                addressString = addressString + placeMark.postalCode! + " "
            }
            
            print("\n",addressString,"\n")
            self.placeAddress = addressString
            
            //            print("address1:", placeMark.thoroughfare ?? "")
            //                   print("address2:", placeMark.subThoroughfare ?? "")
            //                   print("city:",     placeMark.locality ?? "")
            //            print("state:",    placeMark.postalAddress?.state ?? "")
            //                   print("zip code:", placeMark.postalCode ?? "")
            //                   print("country:",  placeMark.country ?? "")
            
            
            
            //            // Country
            //            if let country = placeMark.country as? String {
            //                print("Country :- \(country)")
            //                // City
            //                if let city = placeMark.postalAddress?.city as? String {
            //                    print("City :- \(city)")
            //                    // State
            //                    if let state = placeMark.postalAddress?.state as? String{
            //                        print("State :- \(state)")
            //                        // Street
            //                        if let street = placeMark.postalAddress?.street as? String{
            //                            print("Street :- \(street)")
            //                            let str = street
            //                            let streetNumber = str.components(
            //                                separatedBy: NSCharacterSet.decimalDigits.inverted).joined(separator: "")
            //                            print("streetNumber :- \(streetNumber)" as Any)
            //
            //                            // ZIP
            //                            if let zip = placeMark.postalCode as? String{
            //                                print("ZIP :- \(zip)")
            //                                // Location name
            //                                if let locationName = placeMark?.name as? String {
            //                                    print("Location Name :- \(locationName)")
            //                                    // Street address
            //                                    if let thoroughfare = placeMark?.thoroughfare as? NSString {
            //                                    print("Thoroughfare :- \(thoroughfare)")
            //
            //                                    }
            //                                }
            //                            }
            //                        }
            //                    }
            //                }
            //            }
        })
    }
}


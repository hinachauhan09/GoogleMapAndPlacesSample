//
//  GoogleMapsView.swift
//  GoogleMapAndPlacesSample
//
//  Created by Hina Chauhan on 10/11/22.
//

import SwiftUI
import GoogleMaps
import Combine

struct GoogleMapsView: UIViewRepresentable {
    
    // Listen to changes on the locationManager
    @ObservedObject var locationManager = LocationManager()
    
    
    //    var camera = GMSCameraUpdate()
    @Binding var zoom: Float
    @Binding var location : Location
    @Binding var showCurrentLocation : Bool
    @Binding var placeAddress : String
    
    func makeUIView(context: Self.Context) -> GMSMapView {
        
        let camera = GMSCameraPosition.camera(withTarget: CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude), zoom: 15.0)
        
        var mapView = GMSMapView(frame: CGRect.zero, camera: camera)
        //        mapView.frame = CGRect.zero
        //        mapView.camera = camera
        mapView.settings.compassButton = true
        mapView.isMyLocationEnabled = true
        mapView.settings.scrollGestures = true
        mapView.settings.zoomGestures = true
        mapView.settings.rotateGestures = true
        mapView.settings.tiltGestures = true
        mapView.delegate = context.coordinator
        
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
        marker.map = mapView
        
        return mapView
    }
    
    func updateUIView(_ mapView: GMSMapView, context: Self.Context) {
        
        mapView.clear()
        
        let tappedLocation = CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
        
        let tappedLocationCam = GMSCameraUpdate.setTarget(tappedLocation)
        mapView.animate(with: tappedLocationCam)
        
        mapView.animate(toZoom: zoom)
        
        let marker = GMSMarker()
        marker.position = tappedLocation
        marker.map = mapView
        
        if(showCurrentLocation){
            mapView.settings.myLocationButton.toggle()
            mapView.settings.myLocationButton = false
            showCurrentLocation = false
        }
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }
    
    final class Coordinator: NSObject, GMSMapViewDelegate {
        var parent: GoogleMapsView
        
        init(_ parent: GoogleMapsView) {
            self.parent = parent
        }
        
        func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
            print("You tapped at \(coordinate.latitude), \(coordinate.longitude)")
            
            parent.location.latitude = coordinate.latitude
            parent.location.longitude = coordinate.longitude
            fetchAddressFromLatLong(lat: coordinate.latitude, long: coordinate.longitude)
            
            
        }
        func fetchAddressFromLatLong(lat: Double,long: Double) {
            
            var addressString : String = ""
            let geoCoder = CLGeocoder()
            let location = CLLocation(latitude: lat , longitude: long)
            geoCoder.reverseGeocodeLocation(location, completionHandler: { (placemarks, error) -> Void in
                
                //                print("Response GeoLocation : \(placemarks?[0])")
                var placeMark: CLPlacemark!
                placeMark = placemarks?[0]
                
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
                self.parent.placeAddress = addressString
                
                // Country
                //            if let country = placeMark.addressDictionary!["Country"] as? String {
                //                print("Country :- \(country)")
                //                // City
                //                if let city = placeMark.addressDictionary!["City"] as? String {
                //                    print("City :- \(city)")
                //                    // State
                //                    if let state = placeMark.addressDictionary!["State"] as? String{
                //                        print("State :- \(state)")
                //                        // Street
                //                        if let street = placeMark.addressDictionary!["Street"] as? String{
                //                            print("Street :- \(street)")
                //                            let str = street
                //                            let streetNumber = str.components(
                //                                separatedBy: NSCharacterSet.decimalDigits.inverted).joined(separator: "")
                //                            print("streetNumber :- \(streetNumber)" as Any)
                //
                //                            // ZIP
                //                            if let zip = placeMark.addressDictionary!["ZIP"] as? String{
                //                                print("ZIP :- \(zip)")
                //                                // Location name
                //                                if let locationName = placeMark?.addressDictionary?["Name"] as? String {
                //                                    print("Location Name :- \(locationName)")
                //                                    // Street address
                //                                    if let thoroughfare = placeMark?.addressDictionary!["Thoroughfare"] as? NSString {
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
}

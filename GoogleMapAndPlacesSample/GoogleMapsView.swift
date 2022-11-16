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
    var mapView = GMSMapView()
    let marker = GMSMarker()
//    var camera = GMSCameraUpdate()
    @Binding var zoom: Float
    @Binding var location : (latitude : Double, longitude : Double)
    @Binding var showCurrentLocation : Bool
    
    func makeUIView(context: Self.Context) -> GMSMapView {
        
        var camera = GMSCameraPosition.camera(withTarget: CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude), zoom: zoom)
        
        mapView.frame = CGRect.zero
        mapView.camera = camera
        mapView.settings.compassButton = true
        mapView.isMyLocationEnabled = true
        mapView.settings.scrollGestures = true
        mapView.settings.zoomGestures = true
        mapView.settings.rotateGestures = true
        mapView.settings.tiltGestures = true
        mapView.delegate = context.coordinator
        
        
        marker.position = CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
        marker.map = mapView
        
        
        
        return mapView
    }
    
    func updateUIView(_ mapView: GMSMapView, context: Self.Context) {
//        mapView.animate(toLocation:  mapView.selectedMarker?.position ?? CLLocationCoordinate2D(latitude: latitute, longitude: longitute))
        
//        mapView.clear()
        
        let tappedLocation = CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
        
        let tappedLocationCam = GMSCameraUpdate.setTarget(tappedLocation)
        mapView.animate(with: tappedLocationCam)
        mapView.animate(toZoom: zoom)
        marker.position = tappedLocation
        print("Marker \(marker.position)")
        
        marker.map = mapView
        if(showCurrentLocation){
            mapView.settings.myLocationButton.toggle()
            mapView.settings.myLocationButton = false
            showCurrentLocation = false
        }
        
        latLong(lat: location.latitude, long: location.longitude)
        
        
    }
    
    func latLong(lat: Double,long: Double)  {

        let geoCoder = CLGeocoder()
        let location = CLLocation(latitude: lat , longitude: long)
        geoCoder.reverseGeocodeLocation(location, completionHandler: { (placemarks, error) -> Void in

            print("Response GeoLocation : \(placemarks?[0])")
            var placeMark: CLPlacemark!
            placeMark = placemarks?[0]

            // Country
            if let country = placeMark.addressDictionary!["Country"] as? String {
                print("Country :- \(country)")
                // City
                if let city = placeMark.addressDictionary!["City"] as? String {
                    print("City :- \(city)")
                    // State
                    if let state = placeMark.addressDictionary!["State"] as? String{
                        print("State :- \(state)")
                        // Street
                        if let street = placeMark.addressDictionary!["Street"] as? String{
                            print("Street :- \(street)")
                            let str = street
                            let streetNumber = str.components(
                                separatedBy: NSCharacterSet.decimalDigits.inverted).joined(separator: "")
                            print("streetNumber :- \(streetNumber)" as Any)

                            // ZIP
                            if let zip = placeMark.addressDictionary!["ZIP"] as? String{
                                print("ZIP :- \(zip)")
                                // Location name
                                if let locationName = placeMark?.addressDictionary?["Name"] as? String {
                                    print("Location Name :- \(locationName)")
                                    // Street address
                                    if let thoroughfare = placeMark?.addressDictionary!["Thoroughfare"] as? NSString {
                                    print("Thoroughfare :- \(thoroughfare)")

                                    }
                                }
                            }
                        }
                    }
                }
            }
        })
    }
    
    //@State var coordinator = Coordinator()
    
    
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

        }
    }
}

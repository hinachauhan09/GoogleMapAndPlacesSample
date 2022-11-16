////
////  PlaceAutocompleteViewController.swift
////  GoogleMapAndPlacesSample
////
////  Created by Hina Chauhan on 10/11/22.
////
//

import GooglePlaces
import UIKit
import SwiftUI

class PlaceAutocompleteViewController: UIViewController{
    
    
    var resultsViewController: GMSAutocompleteResultsViewController?
    var searchController: UISearchController?
    var resultView: UITextView?
    var delegate : GMSAutocompleteResultsViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        resultsViewController = GMSAutocompleteResultsViewController()
        resultsViewController?.delegate = delegate
        searchController = UISearchController(searchResultsController: resultsViewController)
        searchController?.searchResultsUpdater = resultsViewController
        
        let subView = UIView(frame: CGRect(x: 0, y: 0.0, width: 350.0, height: 45.0))
        
        subView.addSubview((searchController?.searchBar)!)
        view.addSubview(subView)
        searchController?.searchBar.sizeToFit()
        searchController?.hidesNavigationBarDuringPresentation = false
        
        // When UISearchController presents the results view, present it in
        // this view controller, not one further up the chain.
        definesPresentationContext = true
    }
    
    func goBack(){
        print("go-back")
//        _ = navigationController?.popViewController(animated: true)
//        self.dismiss(animated: true, completion: nil)
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
        self.navigationItem.backBarButtonItem?.isEnabled = true
//        }
    }
}

struct PlaceAutoCompleteView : UIViewControllerRepresentable{
    @Binding var dissmiss : Bool
    @Binding var location : (latitude : Double, longitude : Double)
    
    let autocompleteController = PlaceAutocompleteViewController()
    func makeUIViewController(context: Self.Context) -> PlaceAutocompleteViewController {
        
        autocompleteController.delegate = context.coordinator
        //        autocompleteController.resultsViewController?.delegate = context.coordinator
        
        return autocompleteController
    }
    
    func updateUIViewController(_ autocompleteController: PlaceAutocompleteViewController, context: Context) {
        autocompleteController.searchController?.isActive = false
        
    }
    func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }
    
    func goBack(){
        autocompleteController.goBack()
    }
    
    
    class Coordinator : NSObject, GMSAutocompleteResultsViewControllerDelegate{
        
        var parent: PlaceAutoCompleteView
        
        init(_ parent: PlaceAutoCompleteView) {
            self.parent = parent
        }
        func resultsController(_ resultsController: GMSAutocompleteResultsViewController, didAutocompleteWith place: GMSPlace) {
            parent.autocompleteController.searchController?.isActive = false
            print("Place name: \(place.name ?? "")")
            print("Place address: \(place.formattedAddress ?? "")")
            print("Place attributions: \(place.coordinate)")
            UserDefaults().set(place.name, forKey: Constants.Place.PLACE_NAME)
            UserDefaults().set(place.formattedAddress, forKey: Constants.Place.PLACE_FORMATTED_ADDR)
            UserDefaults().set([place.coordinate.latitude,place.coordinate.longitude], forKey: Constants.Place.PLACE_CO_ORDINATES)
            parent.location.latitude = place.coordinate.latitude
            parent.location.longitude = place.coordinate.longitude
            parent.goBack()
//            parent.presentationMode.wrappedValue.dismiss()
            parent.dissmiss.toggle()
           
            print("dismiss", parent.dissmiss)
        }
        
        func resultsController(_ resultsController: GMSAutocompleteResultsViewController, didFailAutocompleteWithError error: Error) {
            parent.autocompleteController.searchController?.isActive = false
            print("Error: ", error.localizedDescription)
        }
        
        
    }
}

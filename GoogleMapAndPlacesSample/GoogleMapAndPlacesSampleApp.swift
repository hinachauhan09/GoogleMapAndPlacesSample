//
//  GoogleMapAndPlacesSampleApp.swift
//  GoogleMapAndPlacesSample
//
//  Created by Hina Chauhan on 10/11/22.
//

import SwiftUI
import GoogleMaps
import GooglePlaces

final class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        GMSServices.provideAPIKey(Keys.GoogleMapKey)
        GMSPlacesClient.provideAPIKey(Keys.GooglePlacesKey)
        return true
    }
}

@main
struct GoogleMapAndPlacesSampleApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

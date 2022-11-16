//
//  PlaceView.swift
//  GoogleMapAndPlacesSample
//
//  Created by Hina Chauhan on 10/11/22.
//

import SwiftUI

struct PlaceView: View {
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @State private var dismissView : Bool  = false
    @Binding var location : Location
    
    var body: some View {
        NavigationView{
            //        AutocompleteResultsView(search : $searchText)
            //            .searchable(text: $searchText)
            PlaceAutoCompleteView( dissmiss : $dismissView,location : $location)
                .onChange(of: dismissView){ newValue in
                    if(newValue){
                        print("dismiss view now")
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            presentationMode.wrappedValue.dismiss()
                        }
                        
                    }
                }
        }
        
    }
}

//struct PlaceView_Previews: PreviewProvider {
//    static var previews: some View {
//        //PlaceView(location: (0.0,0.0))
//    }
//}

//
//  ContentView.swift
//  GoogleMapAndPlacesSample
//
//  Created by Hina Chauhan on 10/11/22.
//

import SwiftUI

struct ContentView: View {
    @State var zoom : Float = 15.0
    @ObservedObject private var viewModel = MainViewModel()
    //    @State var location : Location =  Location(latitude: 18.52, longitude: 73.853)
    @State var currentLocation : Bool = false
    @State var address : (text : String,location : String) = ("","")
    var body: some View {
        NavigationView{
            GeometryReader{ geometry in
                VStack {
                    ZStack(alignment: .topTrailing){
                        GoogleMapsView(zoom : $zoom,location: $viewModel.location, showCurrentLocation: $currentLocation, placeAddress: $viewModel.placeAddress)
                            .frame(width: geometry.size.width, height: geometry.size.height*0.8)
                            .onAppear{
                                viewModel.fetchAddress()
                            }
                        
                        
                        
                        VStack(alignment: .trailing){
                            NavigationLink(destination: PlaceView(location: $viewModel.location)) {
                                HStack{
                                    Image("search")
                                    Text("Search Places")
                                }
                                .padding(10)
                                .background(.white)
                                .clipShape(RoundedRectangle(cornerRadius: 20))
                                
                            }
                            
                            Spacer()
                            Button{
                                currentLocation.toggle()
                                currentLocation = true
                                //                                print("GPS")
                            }label: {
                                
                                Image("gps")
                                    .padding(10)
                                    .background(.orange)
                                
                                    .frame(alignment: .trailing)
                            }.clipShape(Circle())
                            
                            VStack{
                                Button{
                                    if(zoom<10){
                                        zoom = 13
                                    }
                                    zoom = zoom + 1
                                    //                                    print("add ",zoom)
                                }label: {
                                    Image("add")
                                } .padding(10)
                                Button{
                                    //                                    print("minus",zoom)
                                    if(zoom>22){
                                        zoom = 21
                                    }
                                    if(zoom >= 10){
                                        zoom = zoom - 1
                                    }
                                }label: {
                                    Image("minus")
                                } .padding(10)
                            }
                            .padding(.top,10)
                            .background(.white)
                            .clipShape(RoundedRectangle(cornerRadius: 20))
                            //Spacer(minLength: 50)
                        }
                        .padding(15)
                    }
                    .frame(width: geometry.size.width, height: geometry.size.height*0.8)
                    
                    Text("Address")
                        .bold()
                        .padding()
                    Text(viewModel.placeAddress)
                        .padding()
                        .foregroundColor(.black)
                        .frame(width: geometry.size.width, height: geometry.size.height*0.2, alignment: .topLeading)
                    
                }
                .frame(width: geometry.size.width,height: geometry.size.height)
                //            .background(.red)
            }
            
        }
        .navigationViewStyle(.stack)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

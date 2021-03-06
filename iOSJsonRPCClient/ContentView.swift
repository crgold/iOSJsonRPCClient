/*
 * ContentView.swift
 * iOSJsonRPCClient
 *
 * Created by Christopher Gold on 11/20/21.
 *
 *
 * Copyright 2020 Christopher Gold,
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 *
 * Purpose: Example Swift Client for a Java student collection JsonRPC server.
 *
 * Ser423 Mobile Applications
 * 
 * @author Christopher Gold crgold@asu.edu
 * @version November, 26, 2021
 */

import SwiftUI

struct ViewManager: View {
    @State var showHome: Bool = true
    
    var body: some View {
        TabView {
            ContentView()
                .tabItem {
                    VStack{
                        Image(systemName: "list.dash")
                        Text("Locations")
                    }
                }
            AddLocation()
                .tabItem {
                    VStack{
                        Image(systemName: "plus")
                        Text("Add Location")
                    }
                }
        }
    }
}

struct AddLocation: View {
    @ObservedObject var viewModel = ViewModel()
    
    @State var image: String = ""
    @State var name: String = ""
    @State var addressTitle: String = ""
    @State var description: String = ""
    @State var addressStreet: String = ""
    @State var category: String = ""
    @State var elevation: Double = 0.0
    @State var latitude: Double = 0.0
    @State var longitude: Double = 0.0
    
    let formatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        
        return formatter
    }()

    var body: some View {
        NavigationView {
            Form {
                TextField("Image Text", text: $image)
                TextField("Location Name", text: $name)
                TextField("Address Title", text: $addressTitle)
                TextField("Description", text: $description)
                TextField("Street Address", text: $addressStreet)
                TextField("Category", text: $category)

                HStack {
                    Text("Elevation:")
                    Spacer()
                    TextField("", value: $elevation, formatter: formatter)
                    .fixedSize()
                    .keyboardType(.decimalPad)
                }
                HStack {
                    Text("Latitude:")
                    Spacer()
                    TextField("", value: $latitude, formatter: formatter)
                    .fixedSize()
                    .keyboardType(.decimalPad)
                }
                HStack {
                    Text("Longitude:")
                    Spacer()
                    TextField("", value: $longitude, formatter: formatter)
                    .fixedSize()
                    .keyboardType(.decimalPad)
                }
                Section {
                    HStack {
                        Spacer()
                        Button("Add Location", action: {
                            self.viewModel.addLocation(
                            addressTitle: self.addressTitle,
                            addressStreet: self.addressStreet,
                            elevation: self.elevation,
                            image: self.image,
                            lat: self.latitude,
                            lng: self.longitude,
                            name: self.name,
                            desc: self.description,
                            cat: self.category
                            )
                      })
                        Spacer()
                        Button("Cancel", action: {} )
                            .foregroundColor(.red)
                        Spacer()
                    }
                }
            }
            .navigationBarTitle("Add New Location")
        }
    }
}

struct LocationDetail: View {
    var location: String
    var tempDbl: Double = 0.0
    @ObservedObject var viewModel = ViewModel()
    
    var body: some View {
        VStack {
            List{
                Text("Image Value: " + (viewModel.locationDetails?.result.image ?? "") )
                Text(viewModel.locationDetails?.result.name ?? "")
                Text(viewModel.locationDetails?.result.addressTitle ?? "")
                Text(viewModel.locationDetails?.result.description ?? "")
                Text(viewModel.locationDetails?.result.addressStreet ?? "")
                Text(viewModel.locationDetails?.result.category ?? "")
                Text("Elevation: \(viewModel.locationDetails?.result.elevation ?? tempDbl)")
                Text("Latitude: \(viewModel.locationDetails?.result.latitude ?? tempDbl)")
                Text("Longitude: \(viewModel.locationDetails?.result.longitude ?? tempDbl)")
            }
        }
        .navigationBarTitle(location.description.uppercased())
        .onAppear {
        self.viewModel.getDetails(location: self.location)
        }
    }
}

struct ContentView: View {
    @ObservedObject var viewModel = ViewModel()
    
    var body: some View {
        VStack {
            NavigationView {
                List {
                    ForEach(viewModel.locations?.result ?? [""], id: \.self) { name in
                        NavigationLink(name, destination: LocationDetail(location: name))
                    }
                    .onDelete(perform: delete)
                }
                .navigationBarTitle("Locations")
            
                .onAppear {
                    self.viewModel.getNames()
                }
            }
        }
    }
    func delete(at offsets: IndexSet) {
        viewModel.delete(index: offsets.first!)
        viewModel.locations!.result.remove(atOffsets: offsets)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

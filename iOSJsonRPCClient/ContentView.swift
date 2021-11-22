//
//  ContentView.swift
//  iOSJsonRPCClient
//
//  Created by  on 11/20/21.
//

import SwiftUI

struct AddLocation: View {
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
                }            }
            .navigationBarTitle("Add New Location")
        }
    }
}

struct LocationDetail: View {
    var location: String
    var tempFloat: Float = 0.0
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
                Text("Elevation: \(viewModel.locationDetails?.result.elevation ?? tempFloat)")
                Text("Latitude: \(viewModel.locationDetails?.result.latitude ?? tempFloat)")
                Text("Longitude: \(viewModel.locationDetails?.result.longitude ?? tempFloat)")
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
                    NavigationLink("Add Location", destination: AddLocation())
                }
                .navigationBarTitle("Locations")
            
                .onAppear {
                    self.viewModel.getNames()
                }
            }
            Button("Add Location", action: {
                self.viewModel.addLocation(
                    addressTitle: "cebu",
                    addressStreet: "515 some road",
                    elevation: 101.5,
                    image: "Some Image",
                    lat: 15.2,
                    lng: 42.9,
                    name: "Philippines",
                    desc: "a lovely place indeed",
                    cat: "island"
                    )
                }
            )
        }
    }
    func delete(at offsets: IndexSet) {
        //print(offsets.first!)
        viewModel.delete(index: offsets.first!)
        viewModel.locations!.result.remove(atOffsets: offsets)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

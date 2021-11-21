//
//  ContentView.swift
//  iOSJsonRPCClient
//
//  Created by  on 11/20/21.
//

import SwiftUI

struct Locations: Codable {
    var result: [String]
    
    init?(result: [String]) {
        self.result = result
    }
}

struct Details: Codable {
    var elevation: Float = 0.0
    var image: String
    var latitude: Float = 0.0
    var name: String
    var addressTitle: String
    var description: String
    var addressStreet: String
    var category: String
    var longitude: Float = 0.0
}

struct LocationDetails: Codable {
    var result: Details
}

class ViewModel: ObservableObject {
    @Published var locations: Locations?
    var locationDetails : LocationDetails?
    
    func delete(index: Int) {
        guard let url = URL(string: "http://127.0.0.1:8080") else {
            return
        }
        
        print(locations!.result[index])
        
        var request = URLRequest(url: url)
        let json: [String: Any] = [
            "jsonrpc": "2.0",
            "method" : "remove",
            "params" : [locations?.result[index]],
            "id": 3
        ]
        
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.httpBody = try? JSONSerialization.data(withJSONObject: json)
        let task = URLSession.shared.dataTask(with: request as URLRequest) { data, _, error in guard let _ = data, error == nil else {
            return
            }
        }
        task.resume()
    }
    
    func getDetails(location: String) {
        guard let url = URL(string: "http://127.0.0.1:8080") else {
            return
        }
        
        var request = URLRequest(url: url)
        let json: [String: Any] = [
            "jsonrpc": "2.0",
            "method" : "get",
            "params" : [location],
            "id": 3
        ]
        
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.httpBody = try? JSONSerialization.data(withJSONObject: json)
        let task = URLSession.shared.dataTask(with: request as URLRequest) { data, _, error in guard let data = data, error == nil else {
            return
            }
            
            do {
                let locationDetails = try JSONDecoder().decode(LocationDetails.self, from: data)
                DispatchQueue.main.async {
                    print(locationDetails)
                }
            }
            catch {
                print(error)
            }
        }
        task.resume()
    }

    func getNames() {
        guard let url = URL(string: "http://127.0.0.1:8080") else {
            return
        }
        
        var request = URLRequest(url: url)
        let json: [String: Any] = [
            "jsonrpc": "2.0",
            "method" : "getNames",
            "params" : [],
            "id": 3
        ]
        
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.httpBody = try? JSONSerialization.data(withJSONObject: json)
        let task = URLSession.shared.dataTask(with: request as URLRequest) { [weak self] data, _, error in guard let data = data, error == nil else {
            return
            }
            
            do {
                let locations = try JSONDecoder().decode(Locations.self, from: data)
                DispatchQueue.main.async {
                    self?.locations = locations
                }
            }
            catch {
                print(error)
            }
        }
        task.resume()
    }
}

struct LocationDetail: View {
    var location: String
    var tempFloat: Float = 0.0
    @ObservedObject var viewModel = ViewModel()
    
    var body: some View {
        VStack {
            List{
                Text("Image Value: " + (viewModel.locationDetails?.result.image ?? "") ?? "")
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
                }
                .navigationBarTitle("Locations")
                .onAppear {
                    self.viewModel.getNames()
                }
            }
            Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/) {
                Text("Add Location")
            }
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

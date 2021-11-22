//
//  ViewModel.swift
//  iOSJsonRPCClient
//
//  Created by  on 11/22/21.
//

import Foundation

struct Locations: Codable {
    var result: [String]
    
    init?(result: [String]) {
        self.result = result
    }
}

struct Details: Codable {
    var elevation: Float
    var image: String
    var latitude: Float
    var name: String
    var addressTitle: String
    var description: String
    var addressStreet: String
    var category: String
    var longitude: Float
}

struct LocationDetails: Codable {
    var result: Details
}

class ViewModel: ObservableObject {
    @Published var locations: Locations?
    @Published var locationDetails : LocationDetails?
    
    func delete(index: Int) {
        guard let url = URL(string: "http://127.0.0.1:8080") else {
            return
        }
        
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
    
    func addLocation(addressTitle: String, addressStreet: String, elevation: Double, image: String, lat: Double, lng: Double, name: String, desc: String, cat: String) {
        
        struct LocationJSON: Encodable {
            var jsonrpc: String
            var method: String
            var params: [Location]
            var id: Int
        }
        
        struct Location: Encodable {
            var addressTitle: String
            var addressStreet: String
            var elevation: Double
            var image: String
            var latitude: Double
            var longitude: Double
            var name: String
            var description: String
            var category: String
        }
        
        let location = Location(
            addressTitle: addressTitle,
            addressStreet: addressStreet,
            elevation: elevation,
            image: image,
            latitude: lat,
            longitude: lng,
            name: name,
            description: desc,
            category: cat
        )
        
        let json = LocationJSON(jsonrpc: "2.0", method: "add", params: [location], id: 3)
        print(json)
        
        let data = try? JSONEncoder().encode(json)
        
        guard let url = URL(string: "http://127.0.0.1:8080") else {
                return
            }
            
            var request = URLRequest(url: url)
            
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.setValue("application/json", forHTTPHeaderField: "Accept")
            request.httpBody = data
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
                    self.locationDetails = locationDetails
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

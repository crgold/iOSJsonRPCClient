/*
 *  ViewModel.swift
 *  iOSJsonRPCClient
 *
 *  Created by  on 11/22/21.
 *
 *
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
import Foundation

struct Locations: Codable {
    var result: [String]
    
    init?(result: [String]) {
        self.result = result
    }
}

struct Details: Codable {
    var elevation: Double
    var image: String
    var latitude: Double
    var name: String
    var addressTitle: String
    var description: String
    var addressStreet: String
    var category: String
    var longitude: Double
    
    enum CodingKeys: String, CodingKey {
        case elevation
        case image
        case latitude
        case name
        case addressTitle = "address-title"
        case description
        case addressStreet = "address-street"
        case category
        case longitude
    }
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

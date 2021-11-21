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

class ViewModel: ObservableObject {
    @Published var locations: Locations?
    
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
    
    func getdetails() {
        guard let url = URL(string: "http://127.0.0.1:8080") else {
            return
        }
        
        var request = URLRequest(url: url)
        let json: [String: Any] = [
            "jsonrpc": "2.0",
            "method" : "getName",
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
    }}

struct LocationDetail: View {
    
    var location: [String: String] = [:]
    
    var text: String
    var viewModel: ViewModel
    
    
    
    var body: some View {
        VStack {
            Text(text)
                .navigationBarTitle(text.description.uppercased())
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
                        NavigationLink(name, destination: LocationDetail(text: name, viewModel: self.viewModel))
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

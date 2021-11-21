//
//  ContentView.swift
//  iOSJsonRPCClient
//
//  Created by  on 11/20/21.
//

import SwiftUI

struct Location: Hashable, Codable {
    let addressTitle: String
    let addressStreet: String
    let elevation: Float
    let image: String
    let latitude: Float
    let longitude: Float
    let name: String
    let description: String
    let category: String
    let id: Int
}

struct LocationDetail: View {
    var text: String
    
    var body: some View {
        Text(text)
            .navigationBarTitle(text.description.uppercased())
    }
}

class ViewModel: ObservableObject {
    @Published var locations: [Location] = []
    
    func fetch() {
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
                let locations = try JSONDecoder().decode([Location].self, from: data)
                DispatchQueue.main.async {
                    self?.locations = locations
                    print(self!.locations)
                }
            }
            catch {
                print(error)
            }
        }
        task.resume()
    }
}

struct ContentView: View {
    var viewModel = ViewModel()
    
    var body: some View {
        VStack {
            NavigationView {
                List {
                    ForEach(viewModel.locations, id: \.self) { location in
                        NavigationLink(location.name, destination: LocationDetail(text: location.name))
                    }
                }
                .navigationBarTitle("Locations")
                .onAppear {
                    self.viewModel.fetch()
                    
                }
            }
            Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/) {
                Text("Add Location")
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

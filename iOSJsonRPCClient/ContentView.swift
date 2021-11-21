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
    
    func fetch() {
        guard let url = URL(string: "http://127.0.0.1:8080") else {
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, _, error in guard let data = data, error == nil else {
            return
            }
        }
    }
}

struct ContentView: View {
    var body: some View {
        VStack {
            NavigationView {
                List {
                    NavigationLink("ASU",destination: LocationDetail(text: "ASU"))
                    .navigationBarTitle("Locations")
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

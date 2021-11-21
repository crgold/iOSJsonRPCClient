//
//  ContentView.swift
//  iOSJsonRPCClient
//
//  Created by  on 11/20/21.
//

import SwiftUI

struct LocationDetail: View {
    var text: String
    
    var body: some View {
        Text(text)
            .navigationBarTitle(text.description.uppercased())
    }
}

struct ContentView: View {
    var body: some View {
        NavigationView {
            List {
                NavigationLink("ASU",destination: LocationDetail(text: "ASU"))
                .navigationBarTitle("Locations")
                .toolbar {
                    ToolbarItem(placement: .bottomBar) {
                            Button(action: {
                                
                            }, label: {
                                Text("Soem Button")
                                })
                    }
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

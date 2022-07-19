//
//  ContentView.swift
//  Champion
//
//  Created by Nirvan Nagar on 7/8/22.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView {
            TournamentsListView()
        }
        .navigationViewStyle(.stack) 
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

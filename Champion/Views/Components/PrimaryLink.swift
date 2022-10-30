//
//  PrimaryLink.swift
//  Champion
//
//  Created by Nirvan Nagar on 10/29/22.
//

import SwiftUI

struct PrimaryLink<Destination: View, Label: View>: View {
    let destination: Destination
    let label: Label
    
    init(@ViewBuilder destination: () -> Destination, @ViewBuilder label: () -> Label) {
        self.destination = destination()
        self.label = label()
    }
    
    var body: some View {
        NavigationLink {
            destination
        } label: {
            label
        }
        .buttonStyle(PrimaryButtonStyle())
    }
}

struct PrimaryLink_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            PrimaryLink {
                Text("Destination")
            } label: {
                Text("Label")
            }
            .padding(.horizontal)
        }
    }
}

//
//  SecondaryLink.swift
//  Champion
//
//  Created by Nirvan Nagar on 10/29/22.
//

import SwiftUI

struct SecondaryLink<Destination: View, Label: View>: View {
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
        .buttonStyle(SecondaryButtonStyle())
    }
}

struct SecondaryLink_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            SecondaryLink {
                Text("Destination")
            } label: {
                Text("Link")
            }
            .padding(.horizontal)
        }
    }
}

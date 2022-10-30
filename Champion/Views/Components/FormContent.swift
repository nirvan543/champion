//
//  FormContent.swift
//  Champion
//
//  Created by Nirvan Nagar on 10/29/22.
//

import SwiftUI

struct FormContent<Content: View>: View {
    let content: Content
    
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    var body: some View {
        HStack {
            content
                .frame(maxWidth: .infinity)
        }
        .padding()
        .background()
        .overlay(overlay)
    }
    
    private var overlay: some View {
        Design.defaultShape2.strokeBorder(.quaternary, lineWidth: 1)
    }
}

struct FormContent_Previews: PreviewProvider {
    static var previews: some View {
        FormContent {
            Text("Hello")
        }
        .padding(.horizontal)
    }
}

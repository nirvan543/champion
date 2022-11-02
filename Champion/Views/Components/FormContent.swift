//
//  FormContent.swift
//  Champion
//
//  Created by Nirvan Nagar on 10/29/22.
//

import SwiftUI

struct FormContent<Content: View>: View {
    let content: Content
    let backgroundColor: Color
    
    init(backgroundColor: Color = Color.background, @ViewBuilder content: () -> Content) {
        self.backgroundColor = backgroundColor
        self.content = content()
    }
    
    var body: some View {
        HStack {
            content
                .frame(maxWidth: .infinity)
        }
        .padding()
        .background(backgroundColor)
        .overlay(overlay)
    }
    
    private var overlay: some View {
        Design.defaultShape2.strokeBorder(.quaternary, lineWidth: 1)
    }
}

struct FormContent_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            VStack {
                FormContent {
                    Text("Hello")
                }
                FormContent(backgroundColor: Color.gold) {
                    Text("Hello")
                }
                FormContent {
                    Text("Hello")
                }
                .environment(\.colorScheme, .dark)
            }
        }
        .padding(.horizontal)
    }
}

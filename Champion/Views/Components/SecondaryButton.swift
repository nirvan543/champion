//
//  SecondaryButton.swift
//  Champion
//
//  Created by Nirvan Nagar on 10/29/22.
//

import SwiftUI

struct SecondaryButton: View {
    private let title: String
    private let action: () -> Void
    
    init(_ title: String, action: @escaping () -> Void) {
        self.title = title
        self.action = action
    }
    
    var body: some View {
        Button(title, action: action)
            .buttonStyle(SecondaryButtonStyle())
    }
}

struct SecondaryButtonStyle: ButtonStyle {
    
    func makeBody(configuration: Configuration) -> some View {
        HStack {
            Spacer()
            configuration.label
                .font(.title2)
                .foregroundColor(Design.themeColor)
                .padding(.vertical, Design.buttonPadding)
            Spacer()
        }
        .overlay(buttonOverlay)
    }
    
    private var buttonOverlay: some View {
        Design.defaultShape2.strokeBorder(Design.themeColor, lineWidth: 5)
    }
}

struct SecondaryButton_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            SecondaryButton("Secondary Button") {
                //
            }
            SecondaryButton("Secondary Button") {
                //
            }
            .disabled(true)
        }
        .padding(.horizontal)
    }
}

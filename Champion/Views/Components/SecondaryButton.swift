//
//  SecondaryButton.swift
//  Champion
//
//  Created by Nirvan Nagar on 10/29/22.
//

import SwiftUI

struct SecondaryButton: View {
    private let title: LocalizedStringKey
    private let action: () -> Void
    
    init(_ title: LocalizedStringKey, action: @escaping () -> Void) {
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
        shape.strokeBorder(Design.themeColor, lineWidth: 5)
    }
    
    private var shape: RoundedRectangle {
        RoundedRectangle(cornerRadius: Design.buttonCornerRadius)
    }
}

struct SecondaryButton_Previews: PreviewProvider {
    static var previews: some View {
        SecondaryButton("Secondary Button") {
            //
        }
        .padding(.horizontal)
    }
}

//
//  PrimaryButton.swift
//  Champion
//
//  Created by Nirvan Nagar on 10/29/22.
//

import SwiftUI

struct PrimaryButton: View {
    private let title: LocalizedStringKey
    private let action: () -> Void
    
    init(_ title: LocalizedStringKey, action: @escaping () -> Void) {
        self.title = title
        self.action = action
    }
    
    var body: some View {
        Button(title, action: action)
            .buttonStyle(PrimaryButtonStyle())
    }
}

struct PrimaryButtonStyle: ButtonStyle {
    
    func makeBody(configuration: Configuration) -> some View {
        HStack {
            Spacer()
            configuration.label
                .font(.title2)
                .foregroundColor(.white)
                .padding(.vertical, Design.buttonPadding)
            Spacer()
        }
        .background(backgroundColor)
        .overlay(buttonOverlay)
    }
    
    private var backgroundColor: some View {
        Design.themeColor
            .clipShape(shape)
    }
    
    private var buttonOverlay: some View {
        shape.strokeBorder(Design.themeColor, lineWidth: 5)
    }
    
    private var shape: RoundedRectangle {
        RoundedRectangle(cornerRadius: Design.buttonCornerRadius)
    }
}

struct PrimaryButton_Previews: PreviewProvider {
    static var previews: some View {
        PrimaryButton("Button Title") {
            //
        }
        .padding(.horizontal)
    }
}

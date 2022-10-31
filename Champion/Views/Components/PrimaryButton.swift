//
//  PrimaryButton.swift
//  Champion
//
//  Created by Nirvan Nagar on 10/29/22.
//

import SwiftUI

struct PrimaryButton: View {
    private let title: String
    private let action: () -> Void
    
    init(_ title: String, action: @escaping () -> Void) {
        self.title = title
        self.action = action
    }
    
    var body: some View {
        Button(title, action: action)
            .buttonStyle(PrimaryButtonStyle())
    }
}

struct PrimaryButtonStyle: ButtonStyle {
    @Environment(\.isEnabled) var isEnabled
    
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
            .clipShape(Design.defaultShape2)
    }
    
    @ViewBuilder
    private var buttonOverlay: some View {
        if isEnabled {
            Design.defaultShape2.strokeBorder(Design.themeColor, lineWidth: 5)
        } else {
            EmptyView()
        }
    }
}

struct PrimaryButton_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            PrimaryButton("Button Title") {
                //
            }
            PrimaryButton("Button Title") {
                //
            }
            .disabled(true)
        }
        .padding(.horizontal)
    }
}

//
//  CustomTextField.swift
//  Champion
//
//  Created by Nirvan Nagar on 10/30/22.
//

import SwiftUI

struct CustomTextField: View {
    let title: String
    var text: Binding<String>
    
    init(_ title: String, text: Binding<String>) {
        self.title = title
        self.text = text
    }
    
    var body: some View {
        TextField(title, text: text)
            .textFieldStyle(CustomTextFieldStyle())
    }
}

struct CustomTextFieldStyle: TextFieldStyle {
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .padding(Design.buttonPadding)
            .background()
            .overlay(Design.defaultShape2.strokeBorder(.quaternary, lineWidth: 1))
        
    }
}

struct CustomTextField_Previews: PreviewProvider {
    @State private static var text = ""
    
    static var previews: some View {
        CustomTextField("TextField Title", text: $text)
            .padding(.horizontal)
    }
}

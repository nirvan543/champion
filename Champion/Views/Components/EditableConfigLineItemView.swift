//
//  EditableConfigLineItemView.swift
//  Champion
//
//  Created by Nirvan Nagar on 8/15/22.
//

import SwiftUI

struct EditableConfigLineItemView: View {
    let labelText: String
    @Binding var value: Int
    
    private let shape = Capsule()
    
    var body: some View {
        HStack {
            Text(labelText)
                .font(.title3)
            Spacer()
            TextField("",
                      value: $value,
                      formatter: NumberFormatter())
            .keyboardType(.numberPad)
            .multilineTextAlignment(.center)
            .font(.title3)
            .padding(.horizontal)
            .padding(.vertical, 2)
            .background()
            .frame(maxWidth: 75)
            .clipShape(shape)
            .overlay(shape.strokeBorder(.quaternary, lineWidth: 1))
        }
    }
}

struct EditableConfigLineItemView_Previews: PreviewProvider {
    @State private static var someInt = 1
    
    static var previews: some View {
        EditableConfigLineItemView(labelText: "Label Text", value: $someInt)
    }
}

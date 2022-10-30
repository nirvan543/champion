//
//  DesignValues.swift
//  Champion
//
//  Created by Nirvan Nagar on 7/9/22.
//

import SwiftUI

struct Design {
    static let pageColor = Color(uiColor: .secondarySystemBackground)
    static let themeColor = Color.accentColor
    
    static let defaultShape = Rectangle()
    static let defaultShape2 = RoundedRectangle(cornerRadius: Self.buttonCornerRadius)
    static let defaultCornerRadius = 10
    
    static let buttonCornerRadius: CGFloat = 4.0
    static let buttonPadding: CGFloat = 18.0
}

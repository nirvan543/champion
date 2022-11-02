//
//  ColorExtensions.swift
//  Champion
//
//  Created by Nirvan Nagar on 10/4/22.
//

import SwiftUI

extension Color {
    static let gold = Color(red: 255.0/255.0, green: 215.0/255.0, blue: 0.0/255.0)
    static let silver = Color(red: 192.0/255.0, green: 192.0/255.0, blue: 192.0/255.0)
    static let bronze = Color(red: 176.0/255.0, green: 141.0/255.0, blue: 87.0/255.0)
    
#if os(macOS)
    static let background = Color(NSColor.windowBackgroundColor)
#else
    static let background = Color(UIColor.systemBackground)
#endif
}

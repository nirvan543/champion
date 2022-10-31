//
//  PageSection.swift
//  Champion
//
//  Created by Nirvan Nagar on 7/9/22.
//

import SwiftUI

struct PageSection<Content: View>: View {
    let headerText: String?
    let content: Content
    
    init(_ headerText: String? = nil, @ViewBuilder content: () -> Content) {
        self.headerText = headerText
        self.content = content()
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            if let headerText = headerText {
                HeaderLabelView(text: headerText)
            }
            content
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal)
    }
}

private struct HeaderLabelView: View {
    let text: String
    
    var body: some View {
        Text(text)
            .font(.title2)
            .fontWeight(.bold)
            .foregroundStyle(.secondary)
            .foregroundColor(Design.themeColor)
    }
}

struct PageSection_Previews: PreviewProvider {
    static var previews: some View {
        PageSection("Some header") {
            Text("Yo dawg")
        }
    }
}

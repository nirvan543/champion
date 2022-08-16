//
//  PageView.swift
//  Champion
//
//  Created by Nirvan Nagar on 8/15/22.
//

import SwiftUI

struct PageView<Content: View>: View {
    let content: Content
    
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 42) {
                content
            }
        }
        .frame(maxWidth: .infinity)
        .background(DesignValues.pageColor.ignoresSafeArea())
    }
}

struct PageView_Previews: PreviewProvider {
    static var previews: some View {
        PageView() {
            Text("Suh dude")
        }
    }
}

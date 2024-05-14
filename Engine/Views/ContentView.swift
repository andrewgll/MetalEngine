//
//  ContentView.swift
//  Engine
//
//  Created by Andrii on 18.04.2024.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        MetalView()
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
            .edgesIgnoringSafeArea(.all)
    }
}

#Preview {
    ContentView()
}

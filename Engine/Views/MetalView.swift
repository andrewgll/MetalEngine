//
//  MetalView.swift
//  Engine
//
//  Created by Andrii on 18.04.2024.
//

import SwiftUI
import MetalKit

struct MetalView: View{
    @State private var metalView = MTKView()
    @State private var gameController: GameController?
    
    var body: some View{
        MetalViewRepresentable(
            gameController: gameController,
            metalView: $metalView
        ).onAppear{
            gameController = GameController(metalView: metalView)
        }
    }
}

typealias ViewRepresentable = NSViewRepresentable

struct MetalViewRepresentable: ViewRepresentable{
    let gameController: GameController?
    @Binding var metalView: MTKView
    func makeNSView(context: Context) -> some NSView {
        metalView
    }
    func updateNSView(_ nsView: NSViewType, context: Context) {
        updateMetalView()
    }
    func updateMetalView(){
        
    }
}
#Preview {
  VStack {
    MetalView()
    Text("Metal View")
  }
}

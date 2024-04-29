//
//  GameController.swift
//  Engine
//
//  Created by Andrii on 19.04.2024.
//

import MetalKit

class GameController: NSObject {
    var scene: GameScene
    var renderer: Renderer
    var fps: Double = 0
    var deltaTime: Double = 0
    var lastTime = Date()
    
    init(metalView: MTKView) {
        renderer = Renderer(metalView: metalView)
        scene = GameScene()
        super.init()
        metalView.delegate = self
        fps = Double(metalView.preferredFramesPerSecond)
        mtkView(metalView, drawableSizeWillChange: metalView.drawableSize)
    }
}

extension GameController: MTKViewDelegate {
    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
        scene.update(size: size)
        renderer.mtkView(view, drawableSizeWillChange: size)
    }
    func draw(in view: MTKView) {
//        let currentTime = CFAbsoluteTimeGetCurrent()
        
        let currentTime = Date()
//        let deltaTime = (currentTime - lastTime)
        let deltaTime = currentTime.timeIntervalSince(lastTime)
        lastTime = currentTime
        scene.timer = currentTime.timeIntervalSince1970
        renderer.uniforms.timer = Float(sin(currentTime.timeIntervalSince1970))
        scene.update(deltaTime: Float(deltaTime))
        renderer.draw(scene: scene, in: view)
    }
}

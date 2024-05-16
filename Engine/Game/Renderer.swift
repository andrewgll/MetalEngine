//
//  Renderer.swift
//  Engine
//
//  Created by Andrii on 18.04.2024.
//

import MetalKit

class Renderer: NSObject{
    static var device: MTLDevice!
    static var commandQueue: MTLCommandQueue!
    static var library: MTLLibrary!
    
    var uniforms = Uniforms()
    var params = Params()
    
    var forwardRenderPass: ForwardRenderPass
    var objectIdRenderPass: ObjectIdRenderPass
    
    init(metalView: MTKView){
        guard
            let device = MTLCreateSystemDefaultDevice(),
            let commandQueue = device.makeCommandQueue()
        else {
            fatalError("GPU not available")
        }
        Self.device = device
        Self.commandQueue = commandQueue
        metalView.device = device
        
        let library = device.makeDefaultLibrary()
        Self.library = library
        
        forwardRenderPass = ForwardRenderPass(view: metalView)
        objectIdRenderPass = ObjectIdRenderPass()
        
        super.init()

        metalView.clearColor = MTLClearColor(
          red: 0.93,
          green: 0.97,
          blue: 1.0,
          alpha: 1.0)
        metalView.depthStencilPixelFormat = .depth32Float
        
        mtkView(metalView, drawableSizeWillChange: metalView.drawableSize)
#if os(macOS)
        params.scaleFactor = Float(NSScreen.main?.backingScaleFactor ?? 1)
#elseif os(iOS)
        params.scaleFactor = Float(UIScreen.main.scale)
#endif
    }
}

extension Renderer {
    
    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
        objectIdRenderPass.resize(view: view, size: size)
        forwardRenderPass.resize(view: view, size: size)
    }
    func updateUniforms(scene: GameScene){
        uniforms.viewMatrix = scene.camera.viewMatrix
        uniforms.projectionMatrix = scene.camera.projectionMatrix
        params.lightCount = UInt32(scene.lighting.lights.count)
        params.timer = Float(sin(scene.timer))
        params.cameraPosition = scene.camera.position
        
    }
    func draw(scene: GameScene, in view: MTKView) {
        guard
            let commandBuffer = Self.commandQueue.makeCommandBuffer(),
            let descriptor = view.currentRenderPassDescriptor else {
            return
        }
        
        updateUniforms(scene: scene)
        objectIdRenderPass.draw(commandBuffer: commandBuffer, scene: scene, uniforms: uniforms, params: params)
        forwardRenderPass.descriptor = descriptor
        forwardRenderPass.draw(
            commandBuffer: commandBuffer,
            scene: scene,
            uniforms: uniforms,
            params: params)
        forwardRenderPass.idTexture = objectIdRenderPass.idTexture
        guard let drawable = view.currentDrawable else {
            return
        }
        commandBuffer.present(drawable)
        commandBuffer.commit()
    }
}

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
    
    static var shaderLibraryManager: ShaderLibraryManager!
    
    var pipelineState: MTLRenderPipelineState!
    let depthStencilState: MTLDepthStencilState?
    
    var uniforms = Uniforms()
    var params = Params()
    var lastTime: Double = CFAbsoluteTimeGetCurrent()
        
    init(metalView: MTKView){
        guard
            let device = MTLCreateSystemDefaultDevice(),
            let commandQueue = device.makeCommandQueue()
        else {
            fatalError("GPU not available")
        }
        Self.device = device
        Self.commandQueue = commandQueue
        Self.shaderLibraryManager = ShaderLibraryManager(device: device)
        
        metalView.device = device
        
        let vertexFunction = ShaderLibraryManager.makeFunction(name: "vertex_main")
        let fragmentFunction = ShaderLibraryManager.makeFunction(name: "fragment_main")
        
        self.pipelineState = Renderer.setupPipelineState(
            with: metalView,
            vertexFunction: vertexFunction,
            fragmentFunction: fragmentFunction
        )
        
        self.depthStencilState = Renderer.buildDepthStencilState()
        
        super.init()

        metalView.clearColor = MTLClearColor(
          red: 0.93,
          green: 0.97,
          blue: 1.0,
          alpha: 1.0)
        metalView.depthStencilPixelFormat = .depth32Float
        
        mtkView(metalView, drawableSizeWillChange: metalView.drawableSize)

    }
    static func setupPipelineState(with metalView: MTKView, vertexFunction: MTLFunction?, fragmentFunction: MTLFunction?) -> any MTLRenderPipelineState{
        let pipelineDescriptor = MTLRenderPipelineDescriptor()
        pipelineDescriptor.vertexFunction = vertexFunction
        pipelineDescriptor.fragmentFunction = fragmentFunction
        pipelineDescriptor.colorAttachments[0].pixelFormat = metalView.colorPixelFormat
        pipelineDescriptor.depthAttachmentPixelFormat = .depth32Float
        pipelineDescriptor.vertexDescriptor = MTLVertexDescriptor.defaultLayout
        
        do {
            return try Renderer.device.makeRenderPipelineState(descriptor: pipelineDescriptor)
        }
        catch {
            fatalError(error.localizedDescription)
        }
    }
    static func buildDepthStencilState() -> MTLDepthStencilState? {
        let depthStencilDescriptor = MTLDepthStencilDescriptor()
        depthStencilDescriptor.depthCompareFunction = .less
        depthStencilDescriptor.isDepthWriteEnabled = true
        return Renderer.device.makeDepthStencilState(descriptor: depthStencilDescriptor)
    }
}

extension Renderer {
    
    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
    }
    func updateUniforms(scene: GameScene){
        uniforms.viewMatrix = scene.camera.viewMatrix
        uniforms.projectionMatrix = scene.camera.projectionMatrix
        params.lightCount = UInt32(scene.lighting.lights.count)
        params.timer = Float(sin(scene.timer))
        params.cameraPosition = scene.camera.position

    }
    func draw(scene: GameScene, in view: MTKView){
        guard
            let commandBuffer = Self.commandQueue.makeCommandBuffer(),
            let descriptor = view.currentRenderPassDescriptor,
            let renderEncoder = commandBuffer.makeRenderCommandEncoder(descriptor: descriptor)
        else { 
            return
        }
        
        updateUniforms(scene: scene)
        
        renderEncoder.setDepthStencilState(depthStencilState)
        renderEncoder.setRenderPipelineState(pipelineState)
        renderEncoder.setTriangleFillMode(scene.renderFillMode)
        uniforms.viewMatrix = scene.camera.viewMatrix
        uniforms.projectionMatrix = scene.camera.projectionMatrix
        var lights = scene.lighting.lights
        renderEncoder.setFragmentBytes(&lights, length: MemoryLayout<Light>.stride * lights.count, index: LightBuffer.index)
        for model in scene.models {
            model.render(
                encoder: renderEncoder,
                uniforms: uniforms,
                params: params
            )
        }
//        DebugLights.draw(lights: scene.lighting.lights, encoder: renderEncoder, uniforms: uniforms)
        renderEncoder.endEncoding()
        guard let drawable = view.currentDrawable else {
            return
        }
        commandBuffer.present(drawable)
        commandBuffer.commit()
    }
}

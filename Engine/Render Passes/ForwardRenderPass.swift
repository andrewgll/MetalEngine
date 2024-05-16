//
//  ForwardRenderPass.swift
//  Engine
//
//  Created by Andrii on 12.05.2024.
//

import MetalKit

struct ForwardRenderPass: RenderPass {
    let label = "Forward Render Pass"
    var descriptor: MTLRenderPassDescriptor?
    
    var pipelineState: MTLRenderPipelineState
    let depthStencilState: MTLDepthStencilState?
    
    weak var idTexture: MTLTexture?
    weak var shadowTexture: MTLTexture?
    
    init(view: MTKView) {
        pipelineState = PipelineStates.createForwardPSO(colorPixelFormat: view.colorPixelFormat)
        depthStencilState = Self.buildDepthStencilState()
    }
    
    mutating func resize(view: MTKView, size: CGSize) {
        
    }
    func draw(commandBuffer: MTLCommandBuffer, scene: GameScene, uniforms: Uniforms, params: Params){
        guard let descriptor = descriptor,
        let renderEncoder = commandBuffer.makeRenderCommandEncoder(descriptor: descriptor) else {
            return
        }
        renderEncoder.label = label
        renderEncoder.setDepthStencilState(depthStencilState)
        renderEncoder.setRenderPipelineState(pipelineState)
        
        var lights = scene.lighting.lights
        renderEncoder.setFragmentBytes(&lights, length: MemoryLayout<Light>.stride * lights.count, index: LightBuffer.index )
        renderEncoder.setFragmentTexture(idTexture, index: IdTexture.index)
        renderEncoder.setFragmentTexture(shadowTexture, index: ShadowTexture.index)
        let input = InputController.shared
        var params = params
        params.touchX = UInt32(input.touchLocation?.x ?? 0)
        params.touchY = UInt32(input.touchLocation?.y ?? 0)
        for model in scene.models {
            model.render(encoder: renderEncoder, uniforms: uniforms, params: params)
        }
        renderEncoder.endEncoding()
    }
}

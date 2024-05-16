//
//  ObjectIdRenderPass.swift
//  Engine
//
//  Created by Andrii on 14.05.2024.
//

import MetalKit

struct ObjectIdRenderPass: RenderPass {
    let label = "Object ID Render Pass"
    var descriptor: MTLRenderPassDescriptor?
    var pipelineState: MTLRenderPipelineState
    var idTexture: MTLTexture?
    var depthTexture: MTLTexture?
    var depthStencilState: MTLDepthStencilState?
    
    init() {
        pipelineState = PipelineStates.createObjectIdPSO()
        descriptor = MTLRenderPassDescriptor()
        depthStencilState = Self.buildDepthStencilState()
    }
    
    mutating func resize(view: MTKView, size: CGSize) {
        idTexture = Self.makeTexture(size: size, pixelFormat: .r32Uint, label: "ID Texture")
        depthTexture = Self.makeTexture(size: size, pixelFormat: .depth32Float, label: "ID Depth Texture")
    }
    
    func draw(commandBuffer: any MTLCommandBuffer, scene: GameScene, uniforms: Uniforms, params: Params) {
        guard let descriptor = descriptor else {
            return
        }
        descriptor.colorAttachments[0].texture = idTexture
        descriptor.colorAttachments[0].loadAction = .clear
        descriptor.colorAttachments[0].storeAction = .store
        descriptor.depthAttachment.texture = depthTexture
        guard let renderEncoder = commandBuffer.makeRenderCommandEncoder(descriptor: descriptor)
        else {
            return
        }
        renderEncoder.label = label
        renderEncoder.setRenderPipelineState(pipelineState)
        renderEncoder.setDepthStencilState(depthStencilState)
        for model in scene.models {
            model.render(encoder: renderEncoder, uniforms: uniforms, params: params)
        }
        renderEncoder.endEncoding()
    }
}

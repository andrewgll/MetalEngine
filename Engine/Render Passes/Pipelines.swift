//
//  Pipelines.swift
//  Engine
//
//  Created by Andrii on 12.05.2024.
//

import MetalKit

enum PipelineStates {
    static func createPSO(descriptor: MTLRenderPipelineDescriptor)
    -> MTLRenderPipelineState {
        let pipelineState: MTLRenderPipelineState
        do {
            pipelineState =
            try Renderer.device.makeRenderPipelineState(
                descriptor: descriptor)
        } catch {
            fatalError(error.localizedDescription)
        }
        return pipelineState
    }
    static func createForwardPSO(colorPixelFormat: MTLPixelFormat) -> MTLRenderPipelineState {
        let vertexFunction = Renderer.library?.makeFunction(name: "vertex_main")
        let fragmentFunction = Renderer.library?.makeFunction(name: "fragment_main")
        let pipelineDescriptor = MTLRenderPipelineDescriptor()
        pipelineDescriptor.vertexFunction = vertexFunction
        pipelineDescriptor.fragmentFunction = fragmentFunction
        pipelineDescriptor.colorAttachments[0].pixelFormat = colorPixelFormat
        pipelineDescriptor.depthAttachmentPixelFormat = .depth32Float
        pipelineDescriptor.vertexDescriptor = MTLVertexDescriptor.defaultLayout
        return createPSO(descriptor: pipelineDescriptor)
    }
}

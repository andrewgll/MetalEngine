//
//  ShadowRenderPass.swift
//  Engine
//
//  Created by Andrii on 16.05.2024.
//

import MetalKit

struct ShadowRenderPass: RenderPass {
  let label: String = "Shadow Render Pass"
  var descriptor: MTLRenderPassDescriptor?
    = MTLRenderPassDescriptor()
  var depthStencilState: MTLDepthStencilState?
    = Self.buildDepthStencilState()
  var pipelineState: MTLRenderPipelineState
  var shadowTexture: MTLTexture?

  init() {
    pipelineState =
      PipelineStates.createShadowPSO()
    shadowTexture = Self.makeTexture(
      size: CGSize(
      width: 2048,
      height: 2048),
    pixelFormat: .depth32Float,
    label: "Shadow Depth Texture")
  }

  mutating func resize(view: MTKView, size: CGSize) {
  }

  func draw(
    commandBuffer: MTLCommandBuffer,
    scene: GameScene,
    uniforms: Uniforms,
    params: Params
  ) {
    guard let descriptor = descriptor else { return }
    descriptor.depthAttachment.texture = shadowTexture
    descriptor.depthAttachment.loadAction = .clear
    descriptor.depthAttachment.storeAction = .store

    guard let renderEncoder =
      commandBuffer.makeRenderCommandEncoder(descriptor: descriptor) else {
      return
    }
    renderEncoder.label = "Shadow Encoder"
    renderEncoder.setDepthStencilState(depthStencilState)
    renderEncoder.setRenderPipelineState(pipelineState)
    for model in scene.models {
      renderEncoder.pushDebugGroup(model.name)
      model.render(
        encoder: renderEncoder,
        uniforms: uniforms,
        params: params)
      renderEncoder.popDebugGroup()
    }
    renderEncoder.endEncoding()
  }
}


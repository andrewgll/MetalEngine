//
//  RenderPass.swift
//  Engine
//
//  Created by Andrii on 14.05.2024.
//

import MetalKit

protocol RenderPass {
    var label: String { get }
    var descriptor: MTLRenderPassDescriptor? { get set }
    mutating func resize(view: MTKView, size: CGSize)
    func draw(
        commandBuffer: MTLCommandBuffer,
        scene: GameScene,
        uniforms: Uniforms,
        params: Params
    )
}

extension RenderPass {
    static func buildDepthStencilState() -> MTLDepthStencilState? {
        let descriptor = MTLDepthStencilDescriptor()
        descriptor.depthCompareFunction = .less
        descriptor.isDepthWriteEnabled = true
        return Renderer.device.makeDepthStencilState(descriptor: descriptor)
    }
    static func makeTexture(
        size: CGSize,
        pixelFormat: MTLPixelFormat,
        label: String,
        storageMode: MTLStorageMode = .private,
        usage: MTLTextureUsage = [.shaderRead, .renderTarget]
    ) -> MTLTexture? {
        let width = Int(size.width)
        let height = Int(size.height)
        guard width > 0 && height > 0 else {
            return nil
        }
        let textureDesc = MTLTextureDescriptor.texture2DDescriptor(pixelFormat: pixelFormat, width: width, height: height, mipmapped: false)
        textureDesc.storageMode = storageMode
        textureDesc.usage = usage
        guard let texture = Renderer.device.makeTexture(descriptor: textureDesc) else {
            fatalError("Failed to create texture")
        }
        texture.label = label
        return texture
    }
}

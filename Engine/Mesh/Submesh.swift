//
//  Submesh.swift
//  Engine
//
//  Created by Andrii on 18.04.2024.
//

import MetalKit

struct Submesh{
    struct Textures {
        var baseColor: MTLTexture?
        var roughness: MTLTexture?
    }
    
    var textures: Textures
    var material: Material
    let indexBuffer: MTLBuffer
    let indexCount: Int
    let indexType: MTLIndexType
    let indexBufferOffset: Int

    
}

extension Submesh {
    init(mdlSubmesh: MDLSubmesh, mtkSubmesh: MTKSubmesh) {
        indexCount = mtkSubmesh.indexCount
        indexType = mtkSubmesh.indexType
        indexBuffer = mtkSubmesh.indexBuffer.buffer
        indexBufferOffset = mtkSubmesh.indexBuffer.offset
        textures = Textures(material: mdlSubmesh.material)
        material = Material(material: mdlSubmesh.material)
    }
}

private extension Submesh.Textures {
    init(material: MDLMaterial?) {
        baseColor = material?.texture(type: .baseColor)
        roughness = material?.texture(type: .roughness)

    }
}

private extension MDLMaterialProperty{
    var textureName: String{
        stringValue ?? UUID().uuidString
    }
}

private extension MDLMaterial {
    func texture(type semantic: MDLMaterialSemantic) -> MTLTexture? {
        if let property = property(with: semantic),
           property.type == .texture,
           let mdlTexture = property.textureSamplerValue?.texture {
            return TextureController.loadTexture(texture: mdlTexture, name: property.textureName)
        }
        return nil
    }
}

private extension Material {
    init(material: MDLMaterial?){
        self.init()
        if let baseColor = material?.property(with: .baseColor),
           baseColor.type == .float3 {
            self.baseColor = baseColor.float3Value
        }
        ambientOcclusion = 1
        if let roughness = material?.property(with: .roughness),
            roughness.type == .float {
            self.roughness = roughness.floatValue
        }

    }
}

//
//  Model.swift
//  Engine
//
//  Created by Andrii on 18.04.2024.
//

import MetalKit

class Model: Transformable{
    var transform = Transform()
    var meshes: [Mesh] = []
    var name: String = "Untitled"
    var tiling: UInt32 = 1
    var objectId: UInt32 = 0
    
    init() {}
    
    init(name: String, objectId: UInt32 = 0) {
        guard let assertUrl = Bundle.main.url(
            forResource: name,
            withExtension: nil
        ) else {
            fatalError("Model: \(name) not found")
        }
        self.objectId = objectId
        let allocator = MTKMeshBufferAllocator(device: Renderer.device)
        let asset = MDLAsset(
            url: assertUrl,
            vertexDescriptor: .defaultLayout,
            bufferAllocator: allocator
        )
        asset.loadTextures()
        
        var mtkMeshes: [MTKMesh] = []
        let mdlMeshes =
          asset.childObjects(of: MDLMesh.self) as? [MDLMesh] ?? []
        _ = mdlMeshes.map { mdlMesh in
            
            mdlMesh.addTangentBasis(
              forTextureCoordinateAttributeNamed:
                MDLVertexAttributeTextureCoordinate,
              tangentAttributeNamed: MDLVertexAttributeTangent,
              bitangentAttributeNamed: MDLVertexAttributeBitangent)

            mtkMeshes.append(
              try! MTKMesh(
                mesh: mdlMesh,
                device: Renderer.device))
          }
        
        

        meshes = zip(mdlMeshes, mtkMeshes).map {
            Mesh(mdlMesh: $0.0, mtkMesh: $0.1)
        }
        self.name = name
    }
}

extension Model {
    func render(
        encoder: MTLRenderCommandEncoder,
        uniforms vertex: Uniforms,
        params fragment: Params
    ){

        var uniforms = vertex
        var params = fragment
        params.tiling = tiling
        params.objectId = objectId
        
        uniforms.modelMatrix = transform.modelMatrix
        uniforms.normalMatrix = uniforms.modelMatrix.upperLeft
        
        encoder.setVertexBytes(&uniforms,
                                   length: MemoryLayout<Uniforms>.stride,
                                   index: UniformsBuffer.index)

        encoder.setFragmentBytes(&params,
                                 length: MemoryLayout<Params>.stride,
                                 index: ParamsBuffer.index)

        for mesh in meshes {
            for (index, vertexBuffer) in mesh.vertexBuffer.enumerated() {
                encoder.setVertexBuffer(
                    vertexBuffer,
                    offset: 0,
                    index: index)
            }
            for submesh in mesh.submeshes {
                var material = submesh.material
                
                encoder.setFragmentBytes(&material, length: MemoryLayout<Material>.stride, index: MaterialBuffer.index)
                
                encoder.setFragmentTexture(submesh.textures.baseColor, index: BaseColor.index)
                
                encoder.setFragmentTexture(submesh.textures.normal, index: NormalTexture.index)
                
                encoder.setFragmentTexture(
                  submesh.textures.roughness,
                  index: RoughnessTexture.index)
                
                encoder.setFragmentTexture(
                    submesh.textures.metallic,
                  index: MetallicTexture.index)
                
                encoder.setFragmentTexture(
                    submesh.textures.ambientOcclusion,
                  index: AOTexture.index)

                encoder.drawIndexedPrimitives(
                  type: .triangle,
                  indexCount: submesh.indexCount,
                  indexType: submesh.indexType,
                  indexBuffer: submesh.indexBuffer,
                  indexBufferOffset: submesh.indexBufferOffset)
            }
        }
    }
}

extension Model {
    func setTexture(name: String, type: TextureIndices) {
        if let texture = TextureController.loadTexture(name: name){
            switch type {
            case BaseColor:
                meshes[0].submeshes[0].textures.baseColor = texture
            default: break
            }
        }
    }
}

//
//  Mesh.swift
//  Engine
//
//  Created by Andrii on 18.04.2024.
//

import MetalKit

struct Mesh{
    var vertexBuffer: [MTLBuffer]
    var submeshes: [Submesh]
}

extension Mesh{
    init(mdlMesh: MDLMesh, mtkMesh: MTKMesh){
        var vertexBuffer: [MTLBuffer] = []
        for mtkMeshBuffer in mtkMesh.vertexBuffers {
            vertexBuffer.append(mtkMeshBuffer.buffer)
        }
        self.vertexBuffer = vertexBuffer
        submeshes = zip(mdlMesh.submeshes!, mtkMesh.submeshes).map{
            mesh in Submesh(mdlSubmesh: mesh.0 as! MDLSubmesh, mtkSubmesh: mesh.1)
        }
    }
}

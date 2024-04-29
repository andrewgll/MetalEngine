
import MetalKit

enum Primitive {
  case plane, sphere
}

extension Model {
    convenience init(name: String, primitiveType: Primitive) {
        let mdlMesh = Self.createMesh(primitiveType: primitiveType)
        mdlMesh.vertexDescriptor = MDLVertexDescriptor.defaultLayout
        let mtkMesh = try! MTKMesh(mesh: mdlMesh, device: Renderer.device)
        let mesh = Mesh(mdlMesh: mdlMesh, mtkMesh: mtkMesh)
        self.init()
        self.meshes = [mesh]
        self.name = name
    }

    static func createMesh(primitiveType: Primitive) -> MDLMesh {
        let allocator = MTKMeshBufferAllocator(device: Renderer.device)
        switch primitiveType {
        case .plane:
            return MDLMesh(
            planeWithExtent: [1, 1, 1],
            segments: [4, 4],
            geometryType: .triangles,
            allocator: allocator)
        case .sphere:
            return MDLMesh(
            sphereWithExtent: [1, 1, 1],
            segments: [30, 30],
            inwardNormals: false,
            geometryType: .triangles,
            allocator: allocator)
        }
    }
}


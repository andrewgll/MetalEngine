//
//  GameScene.swift
//  Engine
//
//  Created by Andrii on 19.04.2024.
//

import MetalKit

struct GameScene{
    static var objectId: UInt32 = 1
    
    var renderFillMode: MTLTriangleFillMode = .fill
    
    
    lazy var ground: Model = {
        let ground = Model(name: "ground", primitiveType: .plane)
        ground.setTexture(name: "Desert", type: BaseColor)
        ground.tiling = 64
        ground.transform.scale = 400
        ground.transform.rotation.z = Float(-90).degreesToRadians
        return ground
    }()
    
    lazy var sun: Model = {
        var sun = Model(name: "sun", primitiveType: .sphere)
        sun.scale = 0.2
        sun.rotation.z = Float(270).degreesToRadians
        sun.meshes[0].submeshes[0].material.baseColor = [0.9, 0.9, 0]
        return sun
    }()
    
    lazy var toy_model: Model = {
        let toy = createModel(name: "toy.usdz")
        
        toy.transform.position = [0,0,0]
        toy.transform.scale = 0.2
        toy.transform.rotation.y = Float(-120).degreesToRadians
        
        return toy
    }()
    
    var models: [Model] = []
    var camera = ArcballCamera()
    
    var defaultView: Transform {
        Transform(
            position: [3.2, 3.1, 1.0],
            rotation: [-0.6, 10.7, 0.0])
    }
    
    var lighting = SceneLighting()

    var debugMainCamera: ArcballCamera?
    var debugShadowCamera: OrthographicCamera?

    var shouldDrawMainCamera = false
    var shouldDrawLightCamera = false
    var shouldDrawBoundingSphere = false
    
    var timer: Double = 0
    
    var isPaused = false
    
    init(){
        camera.far = 30
        camera.transform = defaultView
        
        models.append(toy_model)
        models.append(ground)
        models.append(sun)
        
        let numberOfModels = 5
        let radius: Float = 5.0
        let angleStep = 360.0 / Float(numberOfModels)
        let names = ["teapot.usdz"]
        for i in 0..<numberOfModels {
            
            let model = createModel(name: names[i%names.count])
            let angle = Float(i) * angleStep.degreesToRadians
            
            model.transform.position.x = cos(angle) * radius
            model.transform.position.z = sin(angle) * radius
            model.transform.position.y = 0
            model.transform.rotation.y = sin(angle) * radius
            
            model.transform.scale = 0.1
            
            models.append(model)
        }
        
    }
    func createModel(name: String) -> Model {
        let model = Model(name: name, objectId: Self.objectId)
        Self.objectId += 1
        return model
    }
    
    mutating func update(size: CGSize) {
        camera.update(size: size)
    }
    
    mutating func update(deltaTime: Float) {
        updateInput()
        camera.update(deltaTime: deltaTime)
        if isPaused { return }
        
        let rotationMatrix = float4x4(rotation: [0, deltaTime * 0.4, 0])
        let position = lighting.lights[0].position
        lighting.lights[0].position =
        (rotationMatrix * float4(position.x, position.y, position.z, 1)).xyz
        sun.position = lighting.lights[0].position
    }
    mutating func updateInput() {
        let input = InputController.shared
        if input.keysPressed.contains(.one) ||
            input.keysPressed.contains(.two) {
            camera.distance = 4
            if let mainCamera = debugMainCamera {
                camera = mainCamera
                debugMainCamera = nil
                debugShadowCamera = nil
            }
            shouldDrawMainCamera = false
            shouldDrawLightCamera = false
            shouldDrawBoundingSphere = false
            isPaused = false
        }
        if input.keysPressed.contains(.one) {
            camera.transform = Transform()
        }
        if input.keysPressed.contains(.two) {
            camera.transform = defaultView
        }
        if input.keysPressed.contains(.three) {
            shouldDrawMainCamera.toggle()
        }
        if input.keysPressed.contains(.four) {
            shouldDrawLightCamera.toggle()
        }
        if input.keysPressed.contains(.five) {
            shouldDrawBoundingSphere.toggle()
        }
        input.keysPressed.removeAll()
    }
}

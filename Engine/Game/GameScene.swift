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
    
    let lighting = SceneLighting()
    
    lazy var ground: Model = {
        let ground = Model(name: "ground", primitiveType: .plane)
        ground.setTexture(name: "Desert", type: BaseColor)
        ground.tiling = 64
        ground.transform.scale = 400
        ground.transform.rotation.z = Float(-90).degreesToRadians
        return ground
    }()
    
    lazy var toy_model: Model = {
        let toy = createModel(name: "toy.usdz")
        
        toy.transform.position = [0,0,0]
        toy.transform.scale = 0.2
        toy.transform.rotation.y = Float(-120).degreesToRadians
        
        return toy
    }()
    
    var models: [Model] = []
    var camera = PlayerCamera()
    
    var defaultView: Transform {
      Transform(
        position: [3.2, 3.1, 1.0],
        rotation: [-0.6, 10.7, 0.0])
    }
    
    var timer: Double = 0
    
    init(){
        camera.transform.position = [0, 1, 0]
//        camera.target = [0, 1, 0]
//        camera.distance = 4
        
        models.append(toy_model)
        models.append(ground)
        let numberOfModels = 5
        let radius: Float = 5.0
        let angleStep = 360.0 / Float(numberOfModels)
        let names = ["sphere.usdz"]
        for i in 0..<numberOfModels {
            
            let model = createModel(name: names[i%names.count])
            let angle = Float(i) * angleStep.degreesToRadians
            
            model.transform.position.x = cos(angle) * radius
            model.transform.position.z = sin(angle) * radius
            model.transform.position.y = 0.8
            model.transform.rotation.y = sin(angle) * radius
            
            model.transform.scale = 1

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
    
    mutating func update(deltaTime: Float){
        
        camera.update(deltaTime: deltaTime)
        let rotationSpeed: Float = 0.5 * deltaTime // Adjust speed as necessary
        for i in 0..<models.count {
            if(models[i].name != "ground"){
                models[i].rotation.y += rotationSpeed
            }
        }
        if InputController.shared.keyJustPressed(.keyH) {
            if renderFillMode == .fill{
                renderFillMode = .lines
            }
            else{
                renderFillMode = .fill
                
            }
        }
    }
}

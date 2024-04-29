//
//  GameScene.swift
//  Engine
//
//  Created by Andrii on 19.04.2024.
//

import MetalKit

struct GameScene{
    var renderFillMode: MTLTriangleFillMode = .fill
    
    let lighting = SceneLighting()
    
    lazy var ground: Model = {
        let ground = Model(name: "ground", primitiveType: .plane)
        ground.setTexture(name: "Desert", type: BaseColor)
        ground.tiling = 16
        ground.transform.scale = 40
        ground.transform.rotation.z = Float(-90).degreesToRadians
        return ground
    }()
    
    var models: [Model] = []
    var camera = PlayerCamera()
    
    var timer: Double = 0
    
    init(){
        camera.position = [0, 1.5, -4.0]
        
        models.append(ground)
        let numberOfModels = 20
        let radius: Float = 5.0
        let angleStep = 360.0 / Float(numberOfModels)

        for i in 0..<numberOfModels {
            
            let skull = Model(name: "better_skull.usdz")
            let angle = Float(i) * angleStep.degreesToRadians
            
            skull.transform.position.x = cos(angle) * radius
            skull.transform.position.z = sin(angle) * radius
            skull.transform.position.y = 0.8
//            skull.transform.rotation.x = Float(90).degreesToRadians
            
            skull.transform.scale = 0.5

            models.append(skull)
         }
        
    }
    
    mutating func update(size: CGSize) {
        camera.update(size: size)
    }
    
    mutating func update(deltaTime: Float){
        
        camera.update(deltaTime: deltaTime)
        let rotationSpeed: Float = 1.0 * deltaTime // Adjust speed as necessary
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

//
//  SceneLighting.swift
//  Engine
//
//  Created by Andrii on 20.04.2024.
//

import Foundation

struct SceneLighting {
    var lights: [Light] = []
    let sunLight: Light = {
        var light = Self.buildDefaultLigth()
        light.position = [1, 2, -10]
        return light
    }()
    let ambientLight: Light = {
        var light = Self.buildDefaultLigth()
        light.color = [0.05, 0.1, 0]
        light.type = Ambient
        return light
    }()
    let redLight: Light = {
        var light = Self.buildDefaultLigth()
        light.type = Point
        light.position = [-0.8, 0.76, -5]
        light.color = [1, 0, 0]
        light.attenuation = [0.2, 0.2, 0.2]
        return light
    }()
    lazy var spotlight: Light = {
        var light = Self.buildDefaultLigth()
        light.type = Spot
        light.position = [-1, 2, -7]
        light.color = [1, 0, 1]
        light.attenuation = [1, 0.5, 0]
        light.coneAngle = Float(90).degreesToRadians
        light.coneDirection = [0.5, -0.7, 1]
        light.coneAttenuation = 15
        return light
    }()
    init(){
        lights.append(sunLight)
        lights.append(ambientLight)
//        lights.append(redLight)
//        lights.append(spotlight)
    }
    static func buildDefaultLigth() -> Light {
        var light = Light()
        light.position = [0, 0, 0]
        light.color = [1, 1, 1]
        light.specularColor = [0.6, 0.6, 0.6]
        light.attenuation = [1, 0, 0]
        light.type = Sun
        return light
    }
}

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
        var light = Self.buildDefaultLight()
        light.position = [1, 4, -10]
        return light
    }()
    let ambientLight: Light = {
        var light = Self.buildDefaultLight()
        light.color = [0.05, 0.1, 0]
        light.type = Ambient
        return light
    }()
    let redLight: Light = {
        var light = Self.buildDefaultLight()
        light.type = Point
        light.position = [-0.8, 0.76, -5]
        light.color = [1, 0, 0]
        light.attenuation = [0.2, 0.2, 0.2]
        return light
    }()
    lazy var spotlight: Light = {
        var light = Self.buildDefaultLight()
        light.type = Spot
        light.position = [-1, 2, -7]
        light.color = [1, 1, 1]
        light.attenuation = [0.5, 0.5, 0]
        light.coneAngle = Float(90).degreesToRadians
        light.coneDirection = [0.5, -0.7, 1]
        light.coneAttenuation = 15
        return light
    }()

    lazy var fillLight: Light = {
      var light = Self.buildDefaultLight()
      light.position = [-5, 1, 3]
      light.color = float3(repeating: 0.6)
      return light
    }()
    
    init(){
        lights = [sunLight]
    }
    static func buildDefaultLight() -> Light {
        var light = Light()
        light.position = [0, 0, 0]
        light.color = [1, 1, 1]
        light.specularColor = [0.6, 0.6, 0.6]
        light.attenuation = [1, 0, 0]
        light.type = Sun
        return light
    }
}

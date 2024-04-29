//
//  Transform.swift
//  Engine
//
//  Created by Andrii on 18.04.2024.
//

import Foundation

struct Transform {
    var position: SIMD3<Float> = [0, 0, 0]
    var rotation: SIMD3<Float> = [0, 0, 0]
    var scale: Float = 1
}

extension Transform {
    var modelMatrix: matrix_float4x4 {
        let translation = float4x4(translation: position)
        let rotation = float4x4(rotation:rotation)
        let scale = float4x4(scaling: scale)
        let modelMatrix = translation * rotation * scale
        return modelMatrix
    }
}

protocol Transformable {
    var transform: Transform { get set }
}

extension Transformable {
    var position : SIMD3<Float> {
        get { transform.position }
        set { transform.position = newValue}
    }
    var rotation: SIMD3<Float>{
        get { transform.rotation }
        set { transform.rotation = newValue }
    }
    var scale: Float{
        get { transform.scale }
        set { transform.scale = newValue }
    }
}

//
//  Movement.swift
//  Engine
//
//  Created by Andrii on 19.04.2024.
//
import Foundation
import simd

enum Settings {
    static var rotationSpeed: Float { 2.0 }
    static var translationSpeed: Float { 5.0 }
    static var verticalSpeed: Float { 5.0 }
    static var mouseScrollSensitivity: Float { 0.1 }
    static var mousePanSensitivity: Float { 0.008 }
    static var touchZoomSensitivity: Float { 10 }
}

protocol Movement where Self: Transformable {}

extension Movement {
    var forwardVector: float3 {
        normalize([sin(rotation.y), 0, cos(rotation.y)])
    }
    var rightVector: float3 {
        [forwardVector.z, forwardVector.y, -forwardVector.x]
    }
    func updateInput(deltaTime: Float) -> Transform {
        var transform = Transform()
        let rotationAmount = deltaTime * Settings.rotationSpeed
        let input = InputController.shared
        
        if input.keyPressed(.leftArrow) {
            transform.rotation.y -= rotationAmount
        }
        if input.keyPressed(.rightArrow) {
            transform.rotation.y += rotationAmount
        }

        var direction: float3 = .zero
        if input.keyPressed(.keyW) {
            direction.z += 1
        }
        if input.keyPressed(.keyS) {
            direction.z -= 1
        }
        if input.keyPressed(.keyA) {
            direction.x -= 1
        }
        if input.keyPressed(.keyD) {
            direction.x += 1
        }
        
        if input.keyPressed(.spacebar) {
            direction.y += 1
        }
        if input.keyPressed(.leftShift) || input.keyPressed(.rightShift) {
            direction.y -= 1
        }
        
        // Apply translation
        let translationAmount = deltaTime * Settings.translationSpeed
        let verticalTranslationAmount = deltaTime * Settings.verticalSpeed
        if direction != .zero {
            direction = normalize(direction)
            transform.position += direction.x * rightVector * translationAmount
                              + direction.z * forwardVector * translationAmount
                              + float3(0, direction.y, 0) * verticalTranslationAmount
        }

        return transform
    }
}

//
//  ShadowCamera.swift
//  Engine
//
//  Created by Andrii on 16.05.2024.
//


import CoreGraphics

struct FrustumPoints {
    var viewMatrix = float4x4.identity
    var upperLeft = float3.zero
    var upperRight = float3.zero
    var lowerRight = float3.zero
    var lowerLeft = float3.zero
}

extension Camera {
    static func createShadowCamera(using camera: Camera, lightPosition: float3) -> OrthographicCamera {
        guard let camera = camera as? ArcballCamera else { return OrthographicCamera() }
        let nearPoints = calculatePlane(camera: camera, distance: camera.near)
        let farPoints = calculatePlane(camera: camera, distance: camera.far)
        
        // calculate bounding sphere of camera
        let radius1 = distance(nearPoints.lowerLeft, farPoints.upperRight) * 0.5
        let radius2 = distance(farPoints.lowerLeft, farPoints.upperRight) * 0.5
        var center: float3
        if radius1 > radius2 {
            center = simd_mix(nearPoints.lowerLeft, farPoints.upperRight, [0.5, 0.5, 0.5])
        } else {
            center = simd_mix(farPoints.lowerLeft, farPoints.upperRight, [0.5, 0.5, 0.5])
        }
        let radius = max(radius1, radius2)
        
        // create shadow camera using bounding sphere
        var shadowCamera = OrthographicCamera()
        let direction = normalize(lightPosition)
        shadowCamera.position = center + direction * radius
        shadowCamera.far = radius * 2
        shadowCamera.near = 0.01
        shadowCamera.viewSize = CGFloat(shadowCamera.far)
        shadowCamera.center = center
        return shadowCamera
    }
    
    static func calculatePlane(camera: ArcballCamera, distance: Float) -> FrustumPoints {
        let halfFov = camera.fov * 0.5
        let halfHeight = tan(halfFov) * distance
        let halfWidth = halfHeight * camera.aspect
        return calculatePlanePoints(
            matrix: camera.viewMatrix,
            halfWidth: halfWidth,
            halfHeight: halfHeight,
            distance: distance,
            position: camera.position)
    }
    
    static func calculatePlane(camera: OrthographicCamera, distance: Float) -> FrustumPoints {
        let aspect = Float(camera.aspect)
        let halfHeight = Float(camera.viewSize * 0.5)
        let halfWidth = halfHeight * aspect
        let matrix = float4x4(
            eye: camera.position,
            center: camera.center,
            up: [0, 1, 0])
        return calculatePlanePoints(
            matrix: matrix,
            halfWidth: halfWidth,
            halfHeight: halfHeight,
            distance: distance,
            position: camera.position)
    }
    
    private static func calculatePlanePoints(
        matrix: float4x4,
        halfWidth: Float,
        halfHeight: Float,
        distance: Float,
        position: float3
    ) -> FrustumPoints {
        let forwardVector: float3 = [matrix.columns.0.z, matrix.columns.1.z, matrix.columns.2.z]
        let rightVector: float3 = [matrix.columns.0.x, matrix.columns.1.x, matrix.columns.2.x]
        let upVector = cross(forwardVector, rightVector)
        let centerPoint = position + forwardVector * distance
        let moveRightBy = rightVector * halfWidth
        let moveDownBy = upVector * halfHeight
        
        let upperLeft = centerPoint - moveRightBy + moveDownBy
        let upperRight = centerPoint + moveRightBy + moveDownBy
        let lowerRight = centerPoint + moveRightBy - moveDownBy
        let lowerLeft = centerPoint - moveRightBy - moveDownBy
        let points = FrustumPoints(
            viewMatrix: matrix,
            upperLeft: upperLeft,
            upperRight: upperRight,
            lowerRight: lowerRight,
            lowerLeft: lowerLeft)
        return points
    }
}

//
//  ShaderManager.swift
//  Engine
//
//  Created by Andrii on 18.04.2024.
//

import MetalKit

class ShaderLibraryManager{
    static var device: MTLDevice!
    static var library: MTLLibrary!
    
    init(device: MTLDevice){
        Self.device = device
        Self.library = ShaderLibraryManager.createLibrary()
    }
    
    private static func createLibrary() -> MTLLibrary {
        guard let library = device.makeDefaultLibrary() else {
            fatalError("Failed to create shader library")
        }
        return library
    }
    
    static func makeFunction(name: String) -> MTLFunction? {
        return library.makeFunction(name: name)
    }
}

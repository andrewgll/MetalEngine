//
//  Shadow.metal
//  Engine
//
//  Created by Andrii on 16.05.2024.
//

#import "Common.h"

struct VertexIn {
    float4 position [[attribute(0)]];
};

vertex float4 vertex_depth(const VertexIn in [[stage_in]], constant Uniforms &uniforms [[buffer((UniformsBuffer))]]){
    matrix_float4x4 mvp =
    uniforms.shadowProjectionMatrix * uniforms.shadowViewMatrix
    * uniforms.modelMatrix;
    return mvp * in.position;
}

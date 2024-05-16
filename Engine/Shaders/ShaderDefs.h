//
//  ShaderDefs.h
//  Engine
//
//  Created by Andrii on 18.04.2024.
//

#ifndef ShaderDefs_h
#define ShaderDefs_h

#include <metal_stdlib>
using namespace metal;

struct VertexIn {
    float4 position [[attribute(Position)]];
    float3 normal [[attribute(Normal)]];
    float2 uv [[attribute(UV)]];
    float3 tangent [[attribute(Tangent)]];
    float3 bitangent [[attribute(Bitangent)]];
};

struct VertexOut {
    float4 position [[position]];
    float3 normal;
    float2 uv;
    float3 worldPosition;
    float3 worldNormal;
    float3 worldTangent;
    float3 worldBitangent;
    float4 shadowPosition;
};


#endif /* ShaderDefs_h */

//
//  Common.h
//  Engine
//
//  Created by Andrii on 18.04.2024.
//

#ifndef Common_h
#define Common_h

#import <simd/simd.h>

typedef enum {
    BaseColor = 0,
    NormalTexture = 1,
    RoughnessTexture = 2,
    MetallicTexture = 3,
    AOTexture = 4
} TextureIndices;

typedef struct {
    matrix_float4x4 modelMatrix;
    matrix_float4x4 viewMatrix;
    matrix_float4x4 projectionMatrix;
    matrix_float3x3 normalMatrix;
    float timer;
} Uniforms;

typedef struct {
    uint width;
    uint height;
    uint tiling;
    float timer;
    uint lightCount;
    vector_float3 cameraPosition;
    uint objectId;
    uint touchX;
    uint touchY;
    float scaleFactor;
} Params;

typedef struct{
    vector_float3 baseColor;
    float roughness;
    float metallic;
    float ambientOcclusion;
} Material;

typedef enum {
    VertexBuffer = 0,
    UVBuffer = 1,
    TangentBuffer = 2,
    BitangentBuffer = 3,
    UniformsBuffer = 11,
    ParamsBuffer = 12,
    LightBuffer = 13,
    MaterialBuffer = 14,
    TimerBuffer = 15
} BufferIndices;

typedef enum {
    Position = 0,
    Normal = 1,
    UV = 2,
    Tangent = 3,
    Bitangent = 4
} Attributes;

typedef enum {
    unused = 0,
    Sun = 1,
    Spot = 2,
    Point = 3,
    Ambient = 4
} LightType;

typedef struct {
    LightType type;
    vector_float3 position;
    vector_float3 color;
    vector_float3 specularColor;
    float radius;
    vector_float3 attenuation;
    float coneAngle;
    vector_float3 coneDirection;
    float coneAttenuation;
}Light;

#endif /* Common_h */

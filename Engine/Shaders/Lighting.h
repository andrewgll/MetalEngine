//
//  Lighting.h
//  Engine
//
//  Created by Andrii on 20.04.2024.
//

#ifndef Lighting_h
#define Lighting_h
#import "Common.h"

float3 phongLighting(float3 normal, float3 position, constant Params &params, constant Light *lights, float3 baseColor);

float3 computeSpecular(constant Light *lights, constant Params &params, Material material, float3 normal);

float3 computeDiffuse(constant Light *lights, constant Params &params, Material material, float3 normal);

#endif /* Lighting_h */

//
//  Fragment.metal
//  Engine
//
//  Created by Andrii on 18.04.2024.
//

#include <metal_stdlib>
using namespace metal;
#import "Lighting.h"
#import "ShaderDefs.h"


fragment float4 fragment_main(
    constant Params &params [[buffer(ParamsBuffer)]],
    VertexOut in [[stage_in]],
    constant Light *lights [[buffer(LightBuffer)]],
    texture2d<float> baseColorTexture [[texture(BaseColor)]],
    constant Material &_material [[buffer(MaterialBuffer)]],
    texture2d<float> roughnessTexture [[texture(RoughnessTexture)]],
    texture2d<float> normalTexture [[texture((NormalTexture))]],
    texture2d<float> metallicTexture [[texture((MetallicTexture))]],
    texture2d<float> ambientOcclusionTexture [[texture((AOTexture))]],
    texture2d<uint> idTexture [[texture(IdTexture)]]
)
    {
        Material material = _material;
        constexpr sampler textureSampler(
            filter::linear,
            mip_filter::linear,
            max_anisotropy(8),
            address::repeat);
        
        if (!is_null_texture(baseColorTexture)) {
            material.baseColor = baseColorTexture.sample(
            textureSampler,
            in.uv * params.tiling).rgb;
        }
        if (!is_null_texture(idTexture)) {
            uint2 coord = uint2(params.touchX * params.scaleFactor, params.touchY * params.scaleFactor);
            uint objectID = idTexture.read(coord).r;
            if (params.objectId != 0 && objectID == params.objectId) {
                material.baseColor = float3(0.9, 0.5, 0);
            }
        }
        if (!is_null_texture(roughnessTexture)) {
          material.roughness = roughnessTexture.sample(
            textureSampler,
            in.uv * params.tiling).r;
        }
        if (!is_null_texture(metallicTexture)) {
          material.metallic = metallicTexture.sample(
            textureSampler,
            in.uv * params.tiling).r;
        }
        if (!is_null_texture(ambientOcclusionTexture)) {
          material.ambientOcclusion = ambientOcclusionTexture.sample(
            textureSampler,
            in.uv * params.tiling).r;
        }

        float3 normal;
        if (is_null_texture(normalTexture)){
            normal = in.worldNormal;
        } else {
            normal = normalTexture.sample(textureSampler, in.uv * params.tiling).rgb;
            normal = normal * 2 - 1;
            normal = float3x3(
              in.worldTangent,
              in.worldBitangent,
              in.worldNormal) * normal;

        }
        normal = normalize(normal);
        
        float3 diffuseColor = computeDiffuse(lights, params, material, normal);
        float3 specularColor = computeSpecular(lights, params, material, normal);

        return float4(diffuseColor + specularColor, 1);
}

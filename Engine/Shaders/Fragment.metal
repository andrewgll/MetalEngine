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
        texture2d<float> roughnessTexture [[texture(RoughnessTexture)]]
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
        if (!is_null_texture(roughnessTexture)) {
          material.roughness = roughnessTexture.sample(
            textureSampler,
            in.uv * params.tiling).r;
        }

        float3 normal = normalize(in.worldNormal);
        float3 diffuseColor = computeDiffuse(lights, params, material, normal);
        float3 specularColor = computeDiffuse(lights, params, material, normal);

        return float4(diffuseColor + specularColor, 1);
}

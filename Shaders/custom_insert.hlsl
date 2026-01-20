void ApplyCustomFresnel(inout lilFragData fd)
{
    if (!_AlphaFresnelEnabled)
    {
        return;
    }

    float fresnel = pow(1.0 - fd.nv, _AlphaFresnelPower);
    // fresnel = smoothstep(_AlphaFresnelMin, _AlphaFresnelMax, fresnel);

    fresnel = lilTooningScale(1, fresnel, _AlphaFresnelBorder, _AlphaFresnelBlur);

    float4 fresnelCol = _AlphaFresnelColor;
    fresnelCol.rgb *= lerp(1, fd.lightColor, _AlphaFresnelLigting);
    fresnelCol.a *= fresnel;
    
    fd.col.rgb = lerp(fd.col.rgb, fresnelCol.rgb, fresnelCol.a);
    fd.col.a = lerp(fd.col.a, 1, fresnelCol.a);
}

float3 GetCustomSpecular(lilFragData fd, float3 L, float Blur, float Border)
{
    L = normalize(L);
    float3 N = fd.N;
    float3 H = normalize(fd.V + L);
    float nh = saturate(dot(N, H));

    float nv = saturate(dot(N, fd.V));
    float nl = saturate(dot(N, L));
    float lh = saturate(dot(L, H));

    float perceptualRoughness = 1.0 - Blur;
    float roughness = perceptualRoughness * perceptualRoughness;
    float roughness2 = max(roughness, 0.002);
    float lambdaV = nl * (nv * (1.0 - roughness2) + roughness2);
    float lambdaL = nv * (nl * (1.0 - roughness2) + roughness2);

    float r2 = roughness2 * roughness2;
    float d = (nh * r2 - nh) * nh + 1.0;
    float ggx = r2 / (d * d + 1e-7f);
        
    float spec = saturate(dot(H, fd.N));
    return lilTooningScale(1, spec, sqrt(Border), Blur*Blur);
}

void ApplyCustomSpecular(inout lilFragData fd)
{
    if (!_CustomSpecularEnabled)
    {
        return;
    }
    
    float spec0Alpha = GetCustomSpecular(fd, _CustomSpecularDir0, _CustomSpecularBlur0, _CustomSpecularBorder0) * _CustomSpecularColor0.a;
    float spec1Alpha = GetCustomSpecular(fd, _CustomSpecularDir1, _CustomSpecularBlur1, _CustomSpecularBorder1) * _CustomSpecularColor1.a;
    float3 spec = 0;

    float3 spec0 = spec0Alpha * _CustomSpecularColor0.rgb;
    float3 spec1 = spec1Alpha * _CustomSpecularColor1.rgb;

    [flatten]
    if (_CustomSpecularBlend == 0)
    {
        spec = spec0 + spec1;
    }
    else if (_CustomSpecularBlend == 1)
    {
        spec = lerp(spec0, spec0 * _CustomSpecularColor1.rgb, spec1Alpha);
    }
    else if (_CustomSpecularBlend == 2)
    {
        spec = lerp(spec0, _CustomSpecularColor1.rgb, spec1Alpha);
    }

    fd.col.rgb += spec;
    // fd.col.rgb += spec0 * _CustomSpecularColor0.rgb;
    // fd.col.rgb = spec0.rrr;

}
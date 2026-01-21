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


    float spec = saturate(dot(H, N));
    // float NoL = saturate(dot(N, L));
    return lilTooningScale(1, spec, sqrt(Border), Blur*Blur);
}

void ApplyCustomSpecular(inout lilFragData fd)
{
    if (!_CustomSpecularEnabled)
    {
        return;
    }

    float3 dir0 = fd.L;
    float3 dir1 = fd.L;
    if (_CustomSpecularUseOverride0)
    {
        dir0 = _CustomSpecularDir0;
    }
    if (_CustomSpecularUseOverride1)
    {
        dir1 = _CustomSpecularDir1;
    }
    
    float spec0Alpha = GetCustomSpecular(fd, dir0, _CustomSpecularBlur0, _CustomSpecularBorder0) * _CustomSpecularColor0.a;
    float spec1Alpha = GetCustomSpecular(fd, dir1, _CustomSpecularBlur1, _CustomSpecularBorder1) * _CustomSpecularColor1.a;
    float3 spec = 0;


    float mask0 = LIL_SAMPLE_2D(_CustomSpecularMask0, sampler_MainTex, fd.uvMain).r;
    float mask1 = LIL_SAMPLE_2D(_CustomSpecularMask1, sampler_MainTex, fd.uvMain).r;

    float3 spec0 = spec0Alpha * _CustomSpecularColor0.rgb * mask0;
    float3 spec1 = spec1Alpha * _CustomSpecularColor1.rgb * mask1;

    [flatten]
    if (_CustomSpecularBlend == 0)
    {
        spec = spec0 + spec1;
    }
    else if (_CustomSpecularBlend == 1)
    {
        spec = lerp(spec0, spec0 * _CustomSpecularColor1.rgb, spec1Alpha);
    }
    else// if (_CustomSpecularBlend == 2)
    {
        spec = lerp(spec0, _CustomSpecularColor1.rgb, spec1Alpha);
    }

    spec *= lerp(1, fd.lightColor, _CustomSpecularEnableLighting);

    fd.col.rgb += spec;
}
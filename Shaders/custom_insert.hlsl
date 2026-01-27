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

float3 StretchHalfVector(float3 H, float3 T, float3 B, float3 N, float tangentScale, float bitangentScale)
{
    float hT = dot(H, T);
    float hB = dot(H, B);
    float hN = dot(H, N);

    hT *= tangentScale;
    hB *= bitangentScale;

    return normalize(hT * T + hB * B + hN * N);
}

float3 GetCustomSpecular(lilFragData fd, float3 L, float Blur, float Border, float tangentScale, float bitangentScale)
{
    L = normalize(L);

    float3 N = fd.N;
    float3 H = normalize(fd.V * _CustomSpecularViewIntensity + L);

    H = StretchHalfVector(H, normalize(fd.TBN[0]), normalize(fd.TBN[1]), fd.N, tangentScale, bitangentScale);

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
    
    float spec0Alpha = GetCustomSpecular(fd, dir0, _CustomSpecularBlur0, _CustomSpecularBorder0, _CustomSpecularTangentWidth0, _CustomSpecularBitangentWidth0) * _CustomSpecularColor0.a;
    float spec1Alpha = GetCustomSpecular(fd, dir1, _CustomSpecularBlur1, _CustomSpecularBorder1, _CustomSpecularTangentWidth1 , _CustomSpecularBitangentWidth1) * _CustomSpecularColor1.a;
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


void lilGetMatCap3rd(inout lilFragData fd LIL_SAMP_IN_FUNC(samp))
{
    if (_UseMatCap3rd)
    {
        // Normal
        float3 N = fd.N;
        N = lerp(fd.origN, fd.N, _MatCap3rdNormalStrength);

        // UV
        float2 mat3rdUV = lilCalcMatCapUV(fd.uv1, N, fd.V, fd.headV, _MatCap3rdTex_ST, _MatCap3rdBlendUV1.xy, _MatCap3rdZRotCancel, _MatCap3rdPerspective, _MatCap3rdVRParallaxStrength);

        // Color
        float4 matCap3rdColor = _MatCap3rdColor;
            matCap3rdColor *= LIL_SAMPLE_2D_LOD(_MatCap3rdTex, lil_sampler_linear_repeat, mat3rdUV, _MatCap3rdLod);

        #if !defined(LIL_PASS_FORWARDADD)
            matCap3rdColor.rgb = lerp(matCap3rdColor.rgb, matCap3rdColor.rgb * fd.lightColor, _MatCap3rdEnableLighting);
            matCap3rdColor.a = lerp(matCap3rdColor.a, matCap3rdColor.a * fd.shadowmix, _MatCap3rdShadowMask);
        #else
            if(_MatCap3rdBlendMode < 3) matCap3rdColor.rgb *= fd.lightColor * _MatCap3rdEnableLighting;
            matCap3rdColor.a = lerp(matCap3rdColor.a, matCap3rdColor.a * fd.shadowmix, _MatCap3rdShadowMask);
        #endif
        #if LIL_RENDER == 2 && !defined(LIL_REFRACTION)
            if(_MatCap3rdApplyTransparency) matCap3rdColor.a *= fd.col.a;
        #endif
        matCap3rdColor.a = fd.facing < (_MatCap3rdBackfaceMask-1.0) ? 0.0 : matCap3rdColor.a;

        float3 matCapMask = 1.0;
        matCapMask = LIL_SAMPLE_2D_ST(_MatCap3rdBlendMask, samp, fd.uvMain).rgb;

        // Blend
        matCap3rdColor.rgb = lerp(matCap3rdColor.rgb, matCap3rdColor.rgb * fd.albedo, _MatCap3rdMainStrength);
        fd.col.rgb = lilBlendColor(fd.col.rgb, matCap3rdColor.rgb, _MatCap3rdBlend * matCap3rdColor.a * matCapMask, _MatCap3rdBlendMode);
    }
}

void lilGetMatCap4th(inout lilFragData fd LIL_SAMP_IN_FUNC(samp))
{
    if (_UseMatCap4th)
    {
        // Normal
        float3 N = fd.N;
        N = lerp(fd.origN, fd.N, _MatCap4thNormalStrength);

        // UV
        float2 mat4thUV = lilCalcMatCapUV(fd.uv1, N, fd.V, fd.headV, _MatCap4thTex_ST, _MatCap4thBlendUV1.xy, _MatCap4thZRotCancel, _MatCap4thPerspective, _MatCap4thVRParallaxStrength);

        // Color
        float4 matCap4thColor = _MatCap4thColor;
            matCap4thColor *= LIL_SAMPLE_2D_LOD(_MatCap4thTex, lil_sampler_linear_repeat, mat4thUV, _MatCap4thLod);

        #if !defined(LIL_PASS_FORWARDADD)
            matCap4thColor.rgb = lerp(matCap4thColor.rgb, matCap4thColor.rgb * fd.lightColor, _MatCap4thEnableLighting);
            matCap4thColor.a = lerp(matCap4thColor.a, matCap4thColor.a * fd.shadowmix, _MatCap4thShadowMask);
        #else
            if(_MatCap4thBlendMode < 3) matCap4thColor.rgb *= fd.lightColor * _MatCap4thEnableLighting;
            matCap4thColor.a = lerp(matCap4thColor.a, matCap4thColor.a * fd.shadowmix, _MatCap4thShadowMask);
        #endif
        #if LIL_RENDER == 2 && !defined(LIL_REFRACTION)
            if(_MatCap4thApplyTransparency) matCap4thColor.a *= fd.col.a;
        #endif
        matCap4thColor.a = fd.facing < (_MatCap4thBackfaceMask-1.0) ? 0.0 : matCap4thColor.a;

        float3 matCapMask = 1.0;
        matCapMask = LIL_SAMPLE_2D_ST(_MatCap4thBlendMask, samp, fd.uvMain).rgb;

        // Blend
        matCap4thColor.rgb = lerp(matCap4thColor.rgb, matCap4thColor.rgb * fd.albedo, _MatCap4thMainStrength);
        fd.col.rgb = lilBlendColor(fd.col.rgb, matCap4thColor.rgb, _MatCap4thBlend * matCap4thColor.a * matCapMask, _MatCap4thBlendMode);
    }
}
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
    
    // fd.col = saturate(fd.col + fresnel * fresnelCol);
    fd.col.rgb = lerp(fd.col.rgb, fresnelCol.rgb, fresnelCol.a);
    // fd.col.a = lerp(fd.col.a, max(fd.col.a, fresnelCol.a), fresnelCol.a);
    fd.col.a = lerp(fd.col.a, 1, fresnelCol.a);
}
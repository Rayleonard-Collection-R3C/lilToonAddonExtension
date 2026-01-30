//----------------------------------------------------------------------------------------------------------------------
// Macro

// Custom variables
#define LIL_CUSTOM_PROPERTIES \
    float4 _AlphaFresnelColor; \
    float _AlphaFresnelBorder; \
    float _AlphaFresnelBlur; \
    float _AlphaFresnelEnabled; \
    float _AlphaFresnelPower; \
    float _AlphaFresnelLigting; \
    float _AlphaFresnelIntensity; \
    float _CustomSpecularEnabled; \
    float3 _CustomSpecularDir0; \
    float3 _CustomSpecularDir1; \
    float4 _CustomSpecularColor0; \
    float4 _CustomSpecularColor1; \
    float _CustomSpecularBlur0; \
    float _CustomSpecularBlur1; \
    float _CustomSpecularBorder0; \
    float _CustomSpecularBorder1; \
    uint _CustomSpecularBlend; \
    float _CustomSpecularEnableLighting; \
    float _CustomSpecularUseOverride0; \
    float _CustomSpecularUseOverride1; \
    float _CustomSpecularTangentWidth0; \
    float _CustomSpecularTangentWidth1; \
    float _CustomSpecularBitangentWidth0; \
    float _CustomSpecularBitangentWidth1; \
    float _CustomSpecularViewIntensity; \
    int _UseMatCap3rd; \
    float4 _MatCap3rdColor; \
    float _MatCap3rdMainStrength; \
    float4 _MatCap3rdBlendUV1; \
    int _MatCap3rdZRotCancel; \
    int _MatCap3rdPerspective; \
    float4 _MatCap3rdTex_ST; \
    float4 _MatCap3rdBlendMask_ST; \
    float _MatCap3rdVRParallaxStrength; \
    float _MatCap3rdBlend; \
    float _MatCap3rdEnableLighting; \
    float _MatCap3rdShadowMask; \
    int _MatCap3rdBackfaceMask; \
    float _MatCap3rdLod; \
    int _MatCap3rdBlendMode; \
    int _MatCap3rdApplyTransparency; \
    float _MatCap3rdNormalStrength; \
    int _UseMatCap4th; \
    float4 _MatCap4thColor; \
    float _MatCap4thMainStrength; \
    float4 _MatCap4thBlendUV1; \
    int _MatCap4thZRotCancel; \
    int _MatCap4thPerspective; \
    float4 _MatCap4thTex_ST; \
    float4 _MatCap4thBlendMask_ST; \
    float _MatCap4thVRParallaxStrength; \
    float _MatCap4thBlend; \
    float _MatCap4thEnableLighting; \
    float _MatCap4thShadowMask; \
    int _MatCap4thBackfaceMask; \
    float _MatCap4thLod; \
    int _MatCap4thBlendMode; \
    int _MatCap4thApplyTransparency; \
    float _MatCap4thNormalStrength; \
    int _CustomSpecularAniso0Enabled; \
    int _CustomSpecularAniso1Enabled; \
    


// Custom textures
#define LIL_CUSTOM_TEXTURES \
    TEXTURE2D(_CustomSpecularMask0); \
    TEXTURE2D(_CustomSpecularMask1); \
    TEXTURE2D(_MatCap3rdTex); \
    TEXTURE2D(_MatCap3rdBlendMask); \
    TEXTURE2D(_MatCap4thTex); \
    TEXTURE2D(_MatCap4thBlendMask); \

// Add vertex shader input
//#define LIL_REQUIRE_APP_POSITION
//#define LIL_REQUIRE_APP_TEXCOORD0
//#define LIL_REQUIRE_APP_TEXCOORD1
//#define LIL_REQUIRE_APP_TEXCOORD2
//#define LIL_REQUIRE_APP_TEXCOORD3
//#define LIL_REQUIRE_APP_TEXCOORD4
//#define LIL_REQUIRE_APP_TEXCOORD5
//#define LIL_REQUIRE_APP_TEXCOORD6
//#define LIL_REQUIRE_APP_TEXCOORD7
//#define LIL_REQUIRE_APP_COLOR
//#define LIL_REQUIRE_APP_NORMAL
//#define LIL_REQUIRE_APP_TANGENT
//#define LIL_REQUIRE_APP_VERTEXID

// Add vertex shader output
//#define LIL_V2F_FORCE_TEXCOORD0
//#define LIL_V2F_FORCE_TEXCOORD1
//#define LIL_V2F_FORCE_POSITION_OS
//#define LIL_V2F_FORCE_POSITION_WS
//#define LIL_V2F_FORCE_POSITION_SS
//#define LIL_V2F_FORCE_NORMAL
//#define LIL_V2F_FORCE_TANGENT
//#define LIL_V2F_FORCE_BITANGENT
//#define LIL_CUSTOM_V2F_MEMBER(id0,id1,id2,id3,id4,id5,id6,id7)

// Add vertex copy
#define LIL_CUSTOM_VERT_COPY

// Inserting a process into the vertex shader
//#define LIL_CUSTOM_VERTEX_OS
//#define LIL_CUSTOM_VERTEX_WS

// Inserting a process into pixel shader
//#define BEFORE_xx
//#define OVERRIDE_xx

#define BEFORE_OUTPUT ApplyCustomFresnel(fd); \
                      ApplyCustomSpecular(fd); \
                      lilGetMatCap3rd(fd LIL_SAMP_IN(sampler_MainTex)); \
                      lilGetMatCap4th(fd LIL_SAMP_IN(sampler_MainTex)); \


//----------------------------------------------------------------------------------------------------------------------
// Information about variables
//----------------------------------------------------------------------------------------------------------------------

//----------------------------------------------------------------------------------------------------------------------
// Vertex shader inputs (appdata structure)
//
// Type     Name                    Description
// -------- ----------------------- --------------------------------------------------------------------
// float4   input.positionOS        POSITION
// float2   input.uv0               TEXCOORD0
// float2   input.uv1               TEXCOORD1
// float2   input.uv2               TEXCOORD2
// float2   input.uv3               TEXCOORD3
// float2   input.uv4               TEXCOORD4
// float2   input.uv5               TEXCOORD5
// float2   input.uv6               TEXCOORD6
// float2   input.uv7               TEXCOORD7
// float4   input.color             COLOR
// float3   input.normalOS          NORMAL
// float4   input.tangentOS         TANGENT
// uint     vertexID                SV_VertexID

//----------------------------------------------------------------------------------------------------------------------
// Vertex shader outputs or pixel shader inputs (v2f structure)
//
// The structure depends on the pass.
// Please check lil_pass_xx.hlsl for details.
//
// Type     Name                    Description
// -------- ----------------------- --------------------------------------------------------------------
// float4   output.positionCS       SV_POSITION
// float2   output.uv01             TEXCOORD0 TEXCOORD1
// float2   output.uv23             TEXCOORD2 TEXCOORD3
// float3   output.positionOS       object space position
// float3   output.positionWS       world space position
// float3   output.normalWS         world space normal
// float4   output.tangentWS        world space tangent

//----------------------------------------------------------------------------------------------------------------------
// Variables commonly used in the forward pass
//
// These are members of `lilFragData fd`
//
// Type     Name                    Description
// -------- ----------------------- --------------------------------------------------------------------
// float4   col                     lit color
// float3   albedo                  unlit color
// float3   emissionColor           color of emission
// -------- ----------------------- --------------------------------------------------------------------
// float3   lightColor              color of light
// float3   indLightColor           color of indirectional light
// float3   addLightColor           color of additional light
// float    attenuation             attenuation of light
// float3   invLighting             saturate((1.0 - lightColor) * sqrt(lightColor));
// -------- ----------------------- --------------------------------------------------------------------
// float2   uv0                     TEXCOORD0
// float2   uv1                     TEXCOORD1
// float2   uv2                     TEXCOORD2
// float2   uv3                     TEXCOORD3
// float2   uvMain                  Main UV
// float2   uvMat                   MatCap UV
// float2   uvRim                   Rim Light UV
// float2   uvPanorama              Panorama UV
// float2   uvScn                   Screen UV
// bool     isRightHand             input.tangentWS.w > 0.0;
// -------- ----------------------- --------------------------------------------------------------------
// float3   positionOS              object space position
// float3   positionWS              world space position
// float4   positionCS              clip space position
// float4   positionSS              screen space position
// float    depth                   distance from camera
// -------- ----------------------- --------------------------------------------------------------------
// float3x3 TBN                     tangent / bitangent / normal matrix
// float3   T                       tangent direction
// float3   B                       bitangent direction
// float3   N                       normal direction
// float3   V                       view direction
// float3   L                       light direction
// float3   origN                   normal direction without normal map
// float3   origL                   light direction without sh light
// float3   headV                   middle view direction of 2 cameras
// float3   reflectionN             normal direction for reflection
// float3   matcapN                 normal direction for reflection for MatCap
// float3   matcap2ndN              normal direction for reflection for MatCap 2nd
// float    facing                  VFACE
// -------- ----------------------- --------------------------------------------------------------------
// float    vl                      dot(viewDirection, lightDirection);
// float    hl                      dot(headDirection, lightDirection);
// float    ln                      dot(lightDirection, normalDirection);
// float    nv                      saturate(dot(normalDirection, viewDirection));
// float    nvabs                   abs(dot(normalDirection, viewDirection));
// -------- ----------------------- --------------------------------------------------------------------
// float4   triMask                 TriMask (for lite version)
// float3   parallaxViewDirection   mul(tbnWS, viewDirection);
// float2   parallaxOffset          parallaxViewDirection.xy / (parallaxViewDirection.z+0.5);
// float    anisotropy              strength of anisotropy
// float    Blur              Blur
// float    roughness               roughness
// float    perceptualRoughness     perceptual roughness
// float    shadowmix               this variable is 0 in the shadow area
// float    audioLinkValue          volume acquired by AudioLink
// -------- ----------------------- --------------------------------------------------------------------
// uint     renderingLayers         light layer of object (for URP / HDRP)
// uint     featureFlags            feature flags (for HDRP)
// uint2    tileIndex               tile index (for HDRP)
#if UNITY_EDITOR
using System.Collections.Generic;
using System.Linq;
using System.Reflection;
using UnityEditor;
using UnityEngine;

namespace lilToon
{
    public class AddonExtensionInspector : lilToonInspector
    {
        private static bool isShowCustomProperties;
        private const string shaderName = "AddonExtension";

        protected override void LoadCustomProperties(MaterialProperty[] props, Material material)
        {
            isCustomShader = true;

            // If you want to change rendering modes in the editor, specify the shader here
            ReplaceToCustomShaders();
            isShowRenderMode = !material.shader.name.Contains("Optional");

            // If not, set isShowRenderMode to false
            //isShowRenderMode = false;

            //LoadCustomLanguage("");

            var fieldInfos = GetType().GetFields(BindingFlags.NonPublic | BindingFlags.Instance).Where(x => x.FieldType == typeof(MaterialProperty)).ToArray();

            for (int i = 0; i < fieldInfos.Length; i++)
            {
                fieldInfos[i].SetValue(this, FindProperty(fieldInfos[i].Name, props));
            }
        }


        MaterialProperty _AlphaFresnelEnabled;
        MaterialProperty _AlphaFresnelPower;
        MaterialProperty _AlphaFresnelIntensity;
        MaterialProperty _AlphaFresnelBorder;
        MaterialProperty _AlphaFresnelBlur;
        MaterialProperty _AlphaFresnelColor;
        MaterialProperty _AlphaFresnelLigting;

        MaterialProperty _CustomSpecularEnabled;
        MaterialProperty _CustomSpecularDir0;
        MaterialProperty _CustomSpecularDir1;
        MaterialProperty _CustomSpecularColor0;
        MaterialProperty _CustomSpecularColor1;
        MaterialProperty _CustomSpecularBlur0;
        MaterialProperty _CustomSpecularBlur1;
        MaterialProperty _CustomSpecularBorder0;
        MaterialProperty _CustomSpecularBorder1;
        MaterialProperty _CustomSpecularBlend;
        MaterialProperty _CustomSpecularEnableLighting;
        MaterialProperty _CustomSpecularUseOverride0;
        MaterialProperty _CustomSpecularUseOverride1;
        MaterialProperty _CustomSpecularMask0;
        MaterialProperty _CustomSpecularMask1;
        MaterialProperty _CustomSpecularTangentWidth0;
        MaterialProperty _CustomSpecularTangentWidth1;
        MaterialProperty _CustomSpecularBitangentWidth0;
        MaterialProperty _CustomSpecularBitangentWidth1;
        MaterialProperty _CustomSpecularViewIntensity;

        MaterialProperty _UseMatCap3rd;
        MaterialProperty _MatCap3rdTex;
        MaterialProperty _MatCap3rdColor;
        MaterialProperty _MatCap3rdMainStrength;
        MaterialProperty _MatCap3rdBlendUV1;
        MaterialProperty _MatCap3rdZRotCancel;
        MaterialProperty _MatCap3rdPerspective;
        MaterialProperty _MatCap3rdVRParallaxStrength;
        MaterialProperty _MatCap3rdBlend;
        MaterialProperty _MatCap3rdBlendMask;
        MaterialProperty _MatCap3rdEnableLighting;
        MaterialProperty _MatCap3rdShadowMask;
        MaterialProperty _MatCap3rdBackfaceMask;
        MaterialProperty _MatCap3rdLod;
        MaterialProperty _MatCap3rdBlendMode;
        MaterialProperty _MatCap3rdApplyTransparency;
        MaterialProperty _MatCap3rdNormalStrength;

        protected override void DrawCustomProperties(Material material)
        {
            isShowCustomProperties = Foldout("Addon Extension", " Addon Extension", isShowCustomProperties);
            if (isShowCustomProperties)
            {

                EditorGUILayout.BeginVertical(boxOuter);
                m_MaterialEditor.ShaderProperty(_AlphaFresnelEnabled, _AlphaFresnelEnabled.displayName);
                if (_AlphaFresnelEnabled.floatValue > 0)
                {
                    EditorGUILayout.BeginVertical(boxInnerHalf);
                    m_MaterialEditor.ShaderProperty(_AlphaFresnelColor, _AlphaFresnelColor.displayName);
                    m_MaterialEditor.ShaderProperty(_AlphaFresnelPower, _AlphaFresnelPower.displayName);
                    m_MaterialEditor.ShaderProperty(_AlphaFresnelBorder, _AlphaFresnelBorder.displayName);
                    m_MaterialEditor.ShaderProperty(_AlphaFresnelBlur, _AlphaFresnelBlur.displayName);
                    m_MaterialEditor.ShaderProperty(_AlphaFresnelLigting, _AlphaFresnelLigting.displayName);
                    EditorGUILayout.EndVertical();
                }
                EditorGUILayout.EndVertical();


                EditorGUILayout.BeginVertical(boxOuter);
                m_MaterialEditor.ShaderProperty(_CustomSpecularEnabled, _CustomSpecularEnabled.displayName);
                if (_CustomSpecularEnabled.floatValue > 0)
                {
                    EditorGUILayout.BeginVertical(boxInnerHalf);
                    m_MaterialEditor.ShaderProperty(_CustomSpecularEnableLighting, _CustomSpecularEnableLighting.displayName);

                    EditorGUILayout.Space();
                    EditorGUILayout.LabelField("Specular 1");
                    lilEditorGUI.DrawColorAsAlpha(_CustomSpecularColor0, "Alpha");
                    m_MaterialEditor.ShaderProperty(_CustomSpecularColor0, _CustomSpecularColor0.displayName);
                    m_MaterialEditor.TexturePropertySingleLine(new GUIContent(_CustomSpecularMask0.displayName), _CustomSpecularMask0);
                    m_MaterialEditor.ShaderProperty(_CustomSpecularUseOverride0, _CustomSpecularUseOverride0.displayName);
                    m_MaterialEditor.ShaderProperty(_CustomSpecularDir0, _CustomSpecularDir0.displayName);
                    m_MaterialEditor.ShaderProperty(_CustomSpecularBlur0, _CustomSpecularBlur0.displayName);
                    m_MaterialEditor.ShaderProperty(_CustomSpecularBorder0, _CustomSpecularBorder0.displayName);

                    m_MaterialEditor.ShaderProperty(_CustomSpecularTangentWidth0, _CustomSpecularTangentWidth0.displayName);
                    m_MaterialEditor.ShaderProperty(_CustomSpecularBitangentWidth0, _CustomSpecularBitangentWidth0.displayName);

                    EditorGUILayout.Space();

                    EditorGUILayout.LabelField("Specular 2");
                    lilEditorGUI.DrawColorAsAlpha(_CustomSpecularColor1, "Alpha");
                    m_MaterialEditor.ShaderProperty(_CustomSpecularColor1, _CustomSpecularColor1.displayName);
                    m_MaterialEditor.TexturePropertySingleLine(new GUIContent(_CustomSpecularMask1.displayName), _CustomSpecularMask1);
                    m_MaterialEditor.ShaderProperty(_CustomSpecularBlend, _CustomSpecularBlend.displayName);
                    m_MaterialEditor.ShaderProperty(_CustomSpecularUseOverride1, _CustomSpecularUseOverride0.displayName);
                    m_MaterialEditor.ShaderProperty(_CustomSpecularDir1, _CustomSpecularDir1.displayName);
                    m_MaterialEditor.ShaderProperty(_CustomSpecularBlur1, _CustomSpecularBlur1.displayName);
                    m_MaterialEditor.ShaderProperty(_CustomSpecularBorder1, _CustomSpecularBorder1.displayName);

                    m_MaterialEditor.ShaderProperty(_CustomSpecularTangentWidth1, _CustomSpecularTangentWidth0.displayName);
                    m_MaterialEditor.ShaderProperty(_CustomSpecularBitangentWidth1, _CustomSpecularBitangentWidth0.displayName);

                    EditorGUILayout.Space();
                    m_MaterialEditor.ShaderProperty(_CustomSpecularViewIntensity, _CustomSpecularViewIntensity.displayName);
                    EditorGUILayout.EndVertical();
                }
                EditorGUILayout.EndVertical();


                EditorGUILayout.BeginVertical(boxOuter);
                m_MaterialEditor.ShaderProperty(_UseMatCap3rd, _UseMatCap3rd.displayName);
                if (_UseMatCap3rd.floatValue > 0)
                {
                    EditorGUILayout.BeginVertical(boxInnerHalf);
                    m_MaterialEditor.TexturePropertySingleLine(new GUIContent(_MatCap3rdTex.displayName), _MatCap3rdTex);

                    m_MaterialEditor.ShaderProperty(_MatCap3rdColor, _MatCap3rdColor.displayName);
                    m_MaterialEditor.ShaderProperty(_MatCap3rdMainStrength, _MatCap3rdMainStrength.displayName);
                    m_MaterialEditor.ShaderProperty(_MatCap3rdBlendUV1, _MatCap3rdBlendUV1.displayName);
                    m_MaterialEditor.ShaderProperty(_MatCap3rdZRotCancel, _MatCap3rdZRotCancel.displayName);
                    m_MaterialEditor.ShaderProperty(_MatCap3rdPerspective, _MatCap3rdPerspective.displayName);
                    m_MaterialEditor.ShaderProperty(_MatCap3rdVRParallaxStrength, _MatCap3rdVRParallaxStrength.displayName);
                    m_MaterialEditor.ShaderProperty(_MatCap3rdBlend, _MatCap3rdBlend.displayName);
                    m_MaterialEditor.TexturePropertySingleLine(new GUIContent(_MatCap3rdBlendMask.displayName), _MatCap3rdBlendMask);

                    m_MaterialEditor.ShaderProperty(_MatCap3rdEnableLighting, _MatCap3rdEnableLighting.displayName);
                    m_MaterialEditor.ShaderProperty(_MatCap3rdShadowMask, _MatCap3rdShadowMask.displayName);
                    m_MaterialEditor.ShaderProperty(_MatCap3rdBackfaceMask, _MatCap3rdBackfaceMask.displayName);
                    m_MaterialEditor.ShaderProperty(_MatCap3rdLod, _MatCap3rdLod.displayName);
                    m_MaterialEditor.ShaderProperty(_MatCap3rdBlendMode, _MatCap3rdBlendMode.displayName);
                    m_MaterialEditor.ShaderProperty(_MatCap3rdApplyTransparency, _MatCap3rdApplyTransparency.displayName);
                    m_MaterialEditor.ShaderProperty(_MatCap3rdNormalStrength, _MatCap3rdNormalStrength.displayName);
                    EditorGUILayout.EndVertical();
                }
                EditorGUILayout.EndVertical();


            }


            // GUIStyles Name   Description
            // ---------------- ------------------------------------
            // boxOuter         outer box
            // boxInnerHalf     inner box
            // boxInner         inner box without label
            // customBox        box (similar to unity default box)
            // customToggleFont label for box
        }

        protected override void ReplaceToCustomShaders()
        {
            lts = Shader.Find(shaderName + "/lilToon");
            ltsc = Shader.Find("Hidden/" + shaderName + "/Cutout");
            ltst = Shader.Find("Hidden/" + shaderName + "/Transparent");
            ltsot = Shader.Find("Hidden/" + shaderName + "/OnePassTransparent");
            ltstt = Shader.Find("Hidden/" + shaderName + "/TwoPassTransparent");

            ltso = Shader.Find("Hidden/" + shaderName + "/OpaqueOutline");
            ltsco = Shader.Find("Hidden/" + shaderName + "/CutoutOutline");
            ltsto = Shader.Find("Hidden/" + shaderName + "/TransparentOutline");
            ltsoto = Shader.Find("Hidden/" + shaderName + "/OnePassTransparentOutline");
            ltstto = Shader.Find("Hidden/" + shaderName + "/TwoPassTransparentOutline");

            ltsoo = Shader.Find(shaderName + "/[Optional] OutlineOnly/Opaque");
            ltscoo = Shader.Find(shaderName + "/[Optional] OutlineOnly/Cutout");
            ltstoo = Shader.Find(shaderName + "/[Optional] OutlineOnly/Transparent");

            ltstess = Shader.Find("Hidden/" + shaderName + "/Tessellation/Opaque");
            ltstessc = Shader.Find("Hidden/" + shaderName + "/Tessellation/Cutout");
            ltstesst = Shader.Find("Hidden/" + shaderName + "/Tessellation/Transparent");
            ltstessot = Shader.Find("Hidden/" + shaderName + "/Tessellation/OnePassTransparent");
            ltstesstt = Shader.Find("Hidden/" + shaderName + "/Tessellation/TwoPassTransparent");

            ltstesso = Shader.Find("Hidden/" + shaderName + "/Tessellation/OpaqueOutline");
            ltstessco = Shader.Find("Hidden/" + shaderName + "/Tessellation/CutoutOutline");
            ltstessto = Shader.Find("Hidden/" + shaderName + "/Tessellation/TransparentOutline");
            ltstessoto = Shader.Find("Hidden/" + shaderName + "/Tessellation/OnePassTransparentOutline");
            ltstesstto = Shader.Find("Hidden/" + shaderName + "/Tessellation/TwoPassTransparentOutline");

            ltsl = Shader.Find(shaderName + "/lilToonLite");
            ltslc = Shader.Find("Hidden/" + shaderName + "/Lite/Cutout");
            ltslt = Shader.Find("Hidden/" + shaderName + "/Lite/Transparent");
            ltslot = Shader.Find("Hidden/" + shaderName + "/Lite/OnePassTransparent");
            ltsltt = Shader.Find("Hidden/" + shaderName + "/Lite/TwoPassTransparent");

            ltslo = Shader.Find("Hidden/" + shaderName + "/Lite/OpaqueOutline");
            ltslco = Shader.Find("Hidden/" + shaderName + "/Lite/CutoutOutline");
            ltslto = Shader.Find("Hidden/" + shaderName + "/Lite/TransparentOutline");
            ltsloto = Shader.Find("Hidden/" + shaderName + "/Lite/OnePassTransparentOutline");
            ltsltto = Shader.Find("Hidden/" + shaderName + "/Lite/TwoPassTransparentOutline");

            ltsref = Shader.Find("Hidden/" + shaderName + "/Refraction");
            ltsrefb = Shader.Find("Hidden/" + shaderName + "/RefractionBlur");
            ltsfur = Shader.Find("Hidden/" + shaderName + "/Fur");
            ltsfurc = Shader.Find("Hidden/" + shaderName + "/FurCutout");
            ltsfurtwo = Shader.Find("Hidden/" + shaderName + "/FurTwoPass");
            ltsfuro = Shader.Find(shaderName + "/[Optional] FurOnly/Transparent");
            ltsfuroc = Shader.Find(shaderName + "/[Optional] FurOnly/Cutout");
            ltsfurotwo = Shader.Find(shaderName + "/[Optional] FurOnly/TwoPass");
            ltsgem = Shader.Find("Hidden/" + shaderName + "/Gem");
            ltsfs = Shader.Find(shaderName + "/[Optional] FakeShadow");

            ltsover = Shader.Find(shaderName + "/[Optional] Overlay");
            ltsoover = Shader.Find(shaderName + "/[Optional] OverlayOnePass");
            ltslover = Shader.Find(shaderName + "/[Optional] LiteOverlay");
            ltsloover = Shader.Find(shaderName + "/[Optional] LiteOverlayOnePass");

            ltsm = Shader.Find(shaderName + "/lilToonMulti");
            ltsmo = Shader.Find("Hidden/" + shaderName + "/MultiOutline");
            ltsmref = Shader.Find("Hidden/" + shaderName + "/MultiRefraction");
            ltsmfur = Shader.Find("Hidden/" + shaderName + "/MultiFur");
            ltsmgem = Shader.Find("Hidden/" + shaderName + "/MultiGem");
        }

        // You can create a menu like this
        /*
        [MenuItem("Assets/TemplateFull/Convert material to custom shader", false, 1100)]
        private static void ConvertMaterialToCustomShaderMenu()
        {
            if(Selection.objects.Length == 0) return;
            TemplateFullInspector inspector = new TemplateFullInspector();
            for(int i = 0; i < Selection.objects.Length; i++)
            {
                if(Selection.objects[i] is Material)
                {
                    inspector.ConvertMaterialToCustomShader((Material)Selection.objects[i]);
                }
            }
        }
        */
    }
}
#endif
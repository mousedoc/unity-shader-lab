using System.Collections.Generic;
using UnityEditor;
using UnityEngine;

public class MaterialRefCleaner : EditorWindow
{
    private SerializedObject serializedObject;
    private Material selectedMaterial;

    [MenuItem("Tools/Optimization/Material/Ref Cleaner", priority = 51)]
    private static void ShowWindow()
    {
        var window = GetWindow<MaterialRefCleaner>("MatRef. Cleaner");
        window.Show();
    }

    [MenuItem("Tools/Optimization/Material/Clean all ref", priority = 52)]
    private static void CleanAll()
    {
        foreach (var guid in AssetDatabase.FindAssets("t:Material"))
        {
            var path = AssetDatabase.GUIDToAssetPath(guid);
            var material = AssetDatabase.LoadAssetAtPath<Material>(path);
            var serializedObj = new SerializedObject(material);

            var properties = new List<SerializedProperty>()
            {
                GetSerializedProperty(serializedObj, "m_SavedProperties.m_TexEnvs"),
                GetSerializedProperty(serializedObj, "m_SavedProperties.m_Floats"),
                GetSerializedProperty(serializedObj, "m_SavedProperties.m_Colors"),
            };

            foreach (var property in properties)
            {
                RemoveAllOldReference(material, serializedObj, property);
            }
        }

        AssetDatabase.SaveAssets();
        AssetDatabase.Refresh();
    }

    protected virtual void OnEnable()
    {
        UpdateSelectedMaterial();
    }

    protected virtual void OnSelectionChange()
    {
        UpdateSelectedMaterial();
    }

    protected virtual void OnProjectChange()
    {
        UpdateSelectedMaterial();
    }

    private Vector2 scrollPos = Vector2.zero;
    protected virtual void OnGUI()
    {
        EditorGUIUtility.labelWidth = 200f;

        if (selectedMaterial == null)
        {
            EditorGUILayout.LabelField("No material selected");
        }
        else
        {
            var propertyMap = new Dictionary<string, SerializedProperty>()
            {
                { "Textures", GetSerializedProperty(serializedObject, "m_SavedProperties.m_TexEnvs") },
                { "Floats", GetSerializedProperty(serializedObject, "m_SavedProperties.m_Floats") },
                { "Colors", GetSerializedProperty(serializedObject, "m_SavedProperties.m_Colors") },
            };

            EditorGUILayout.Space();
            EditorGUILayout.LabelField("Selected material:", selectedMaterial.name);
            EditorGUILayout.LabelField("Shader:", selectedMaterial.shader.name);

            #region Quick behaviour

            EditorGUILayout.BeginHorizontal();

            Color originColor = GUI.backgroundColor;
            GUI.backgroundColor = Color.red;
            if (GUILayout.Button("Remove all"))
            {
                RemoveAllOldReference(selectedMaterial, serializedObject, propertyMap["Textures"]);
                RemoveAllOldReference(selectedMaterial, serializedObject, propertyMap["Floats"]);
                RemoveAllOldReference(selectedMaterial, serializedObject, propertyMap["Colors"]);
            }

            GUI.backgroundColor = Color.cyan;
            if (GUILayout.Button("Save"))
            {
                AssetDatabase.SaveAssets();
                AssetDatabase.Refresh();
            }

            GUI.backgroundColor = originColor;
            EditorGUILayout.EndHorizontal();

            #endregion

            EditorGUILayout.LabelField("", GUI.skin.horizontalSlider);

            scrollPos = EditorGUILayout.BeginScrollView(scrollPos);
            EditorGUILayout.LabelField("Properties");

            serializedObject.Update();

            EditorGUI.indentLevel++;

            foreach (var pair in propertyMap)
            {
                EditorGUILayout.LabelField(pair.Key);
                EditorGUI.indentLevel++;
                ProcessProperties(pair.Value);
                EditorGUI.indentLevel--;
            }

            EditorGUI.indentLevel--;
            EditorGUILayout.EndScrollView();
            EditorGUILayout.Space();
        }

        EditorGUIUtility.labelWidth = 0;
    }

    private static SerializedProperty GetSerializedProperty(SerializedObject serializedObj, string path)
    {
        return serializedObj.FindProperty(path);
    }

    private void ProcessProperties(SerializedProperty properties)
    {
        if (properties != null && properties.isArray)
        {
            for (int i = 0; i < properties.arraySize; i++)
            {
                string name = properties.GetArrayElementAtIndex(i).displayName;
                bool exist = selectedMaterial.HasProperty(name);

                if (exist)
                {
                    EditorGUILayout.LabelField(name, "Exist");
                }
                else
                {
                    using (new EditorGUILayout.HorizontalScope())
                    {
                        EditorGUILayout.LabelField(name, "Old reference", "CN StatusWarn");
                        if (GUILayout.Button("Remove", GUILayout.Width(80f)))
                        {
                            properties.DeleteArrayElementAtIndex(i);
                            serializedObject.ApplyModifiedProperties();
                            GUIUtility.ExitGUI();
                        }
                    }
                }
            }
        }
    }

    private static void RemoveAllOldReference(Material material, SerializedObject serializedObj, SerializedProperty property)
    {
        if (property != null && property.isArray)
        {
            for (int i = 0; i < property.arraySize; i++)
            {
                string name = property.GetArrayElementAtIndex(i).displayName;
                bool exist = material.HasProperty(name);

                if (exist == false)
                {
                    property.DeleteArrayElementAtIndex(i);
                    serializedObj.ApplyModifiedProperties();
                    i--;
                }
            }
        }
    }

    private void UpdateSelectedMaterial()
    {
        selectedMaterial = Selection.activeObject as Material;
        if (selectedMaterial != null)
        {
            serializedObject = new SerializedObject(selectedMaterial);
        }

        Repaint();
    }
}

using System.Collections.Generic;
using UnityEditor;
using UnityEngine;

public class MaterialRefCleaner : EditorWindow
{
    private SerializedObject serializedObject;
    private Material selectedMaterial;

    [MenuItem("Tools/Optimization/MaterialRefCleaner", priority = 51)]
    private static void Init()
    {
        GetWindow<MaterialRefCleaner>("Ref. Cleaner");
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
                { "Textures", GetSerializedProperty("m_SavedProperties.m_TexEnvs") },
                { "Floats", GetSerializedProperty("m_SavedProperties.m_Floats") },
                { "Colors", GetSerializedProperty("m_SavedProperties.m_Colors") },
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
                RemoveAllOldReference(propertyMap["Textures"]);
                RemoveAllOldReference(propertyMap["Floats"]);
                RemoveAllOldReference(propertyMap["Colors"]);
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

    private SerializedProperty GetSerializedProperty(string path)
    {
        return serializedObject.FindProperty(path);
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

    private void RemoveAllOldReference(SerializedProperty properties)
    {
        if (properties != null && properties.isArray)
        {
            for (int i = 0; i < properties.arraySize; i++)
            {
                string name = properties.GetArrayElementAtIndex(i).displayName;
                bool exist = selectedMaterial.HasProperty(name);

                if (exist == false)
                {
                    properties.DeleteArrayElementAtIndex(i);
                    serializedObject.ApplyModifiedProperties();
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

using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using System;
using UnityEditor;
using UnityEditor.Build;
using UnityEditor.Build.Reporting;

public class FailBuildOnWarnings : IPreprocessBuildWithReport, IPostprocessBuildWithReport
{
    public int callbackOrder
    {
        get { return 0; }
    }

    public void OnPostprocessBuild(BuildReport report)
    {
        if (UnityEditorInternal.InternalEditorUtility.inBatchMode)
            Application.logMessageReceived -= CheckLogForWarning;
    }

    public void OnPreprocessBuild(BuildReport report)
    {
        if (UnityEditorInternal.InternalEditorUtility.inBatchMode)
            Application.logMessageReceived += CheckLogForWarning;
    }

    private void CheckLogForWarning(string condition, string stackTrace, LogType type)
    {
        //Unable to throw a BuildFailedException() as it doesn't give a non-zero exit code
        if(type == LogType.Warning)
            EditorApplication.Exit(1);
    }
}

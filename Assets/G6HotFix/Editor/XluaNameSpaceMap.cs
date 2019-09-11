using System;
using System.IO;
using System.Text;
using System.Collections.Generic;
using UnityEditor;
using UnityEngine;
using ICSharpCode.SharpZipLib.Zip;
using XLua;
using CSObjectWrapEditor;

public class XluaNameSpaceMap : Editor {

	private const string FILE_NAME = "NameSpaceMap";

	[MenuItem("XLua/Generate NameSpaceMap", false, -100)]
	public static void GenAll()
	{
		HashSet<string> nameSpaceSet = new HashSet<string>();
		List<string> nameSpaceList = new List<string>(nameSpaceSet);
		HashSet<string> noNameSpaceTypeSet = new HashSet<string>();
		List<string> noNameSpaceTypeList = new List<string>();

		Generator.GetGenConfig(Utils.GetAllTypes());
		foreach (Type type in Generator.LuaCallCSharp)
		{
			if (string.IsNullOrEmpty(type.Namespace))
			{
				Type t = type;
				while (t.DeclaringType != null)
				{
					t = t.DeclaringType;
				}
				string typeName = t.FullName;
				if (!noNameSpaceTypeSet.Contains(typeName))
				{
					noNameSpaceTypeSet.Add(typeName);
					noNameSpaceTypeList.Add(typeName);
				}
			}
			else
			{
				string namespaceName = type.Namespace.Split('.')[0];
				if (!nameSpaceSet.Contains(namespaceName))
				{
					nameSpaceSet.Add(namespaceName);
					nameSpaceList.Add(namespaceName);
				}
			}
		}
		nameSpaceList.Sort();
		noNameSpaceTypeList.Sort();

		Dictionary<string, byte[]> fileDict = new Dictionary<string, byte[]>();

		StringBuilder mapSb = new StringBuilder();
		mapSb.AppendLine("CS = {");
		foreach (string nameSpace in nameSpaceList)
		{
			mapSb.Append("\t");
			mapSb.Append(nameSpace);
			mapSb.Append(" = ");
			mapSb.Append(nameSpace);
			mapSb.AppendLine(";");
		}
		mapSb.AppendLine();
		foreach (string typeName in noNameSpaceTypeList)
		{
			mapSb.Append("\t");
			mapSb.Append(typeName);
			mapSb.Append(" = ");
			mapSb.Append(typeName);
			mapSb.AppendLine(";");
		}
		mapSb.Append("}");

		string mapFileName = FILE_NAME + ".lua";
		byte[] mapBytes = Encoding.UTF8.GetBytes(mapSb.ToString());
		fileDict[mapFileName] = mapBytes;

		StringBuilder utilSb = new StringBuilder();
		utilSb.AppendLine("---@param CSClass table");
		utilSb.AppendLine("---@return System.Type");
		utilSb.AppendLine("function typeof(CSClass) end");
		utilSb.AppendLine();
		TextAsset ta = Resources.Load<TextAsset>("xlua/util.lua");
		if (ta)
		{
			string text = ta.text;
			text = text.Replace("local function cs_generator(func)",
				"---@param func fun()" + Environment.NewLine +
				"---@return System.Collections.IEnumerator" + Environment.NewLine +
				"local function cs_generator(func)");
			int index = text.LastIndexOf("return {");
			if (index != -1)
			{
				utilSb.Append(text.Substring(0, index));
				utilSb.Append("util = {");
				utilSb.Append(text.Substring(index + "return {".Length));
				utilSb.Append("return util");
			}
		}
		string utilFileName = "util.lua";
		byte[] utilBytes = Encoding.UTF8.GetBytes(utilSb.ToString());
		fileDict[utilFileName] = utilBytes;

		string zipFileName = Application.dataPath + "/../LuaLib/" + FILE_NAME + ".zip";
		WriteZip(zipFileName, fileDict);

		Debug.Log("NameSpaceMap.zip generating is complete!");
    }

	private static void WriteZip(string zipFileName, Dictionary<string, byte[]> fileDict, int compressionLevel = 9)
	{
		FileInfo zipFile = new FileInfo(zipFileName);
		DirectoryInfo dir = zipFile.Directory;
		if (!dir.Exists)
		{
			dir.Create();
		}
		FileStream fileStream = zipFile.Create();
		ZipOutputStream zipStream = new ZipOutputStream(fileStream);
		zipStream.SetLevel(compressionLevel);
		foreach (string fileName in fileDict.Keys)
		{
			zipStream.PutNextEntry(new ZipEntry(fileName));
			byte[] buffer = fileDict[fileName];
			zipStream.Write(buffer, 0, buffer.Length);
		}
		zipStream.Flush();
		zipStream.Close();
		fileStream.Close();
	}
}

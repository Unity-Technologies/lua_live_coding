demo基于UnityAssetStore中的SurvivalShooterTutorial项目开发而成，并采用了同样由Tencent公司G6团队开发的xlua，和基于xlua的一套轻量级lua框架。
demo主要演示了unity环境的下的liveCoding方案，包含 **资源、Lua、C#** 3个方面的实现。

# 项目目录说明
--------
除大多数目录与SurvivalShooterTutorial一致以外，demo还包含了以下几个目录。

```

Asset
│
└───_Complete-Game          
│   │
│   └───Prefabs             //部分prefab上增加了LuaOperation组件
│   │
│   └───Scripts             
│       │ 
│       └───Core            //C#代码修改主要在这里，包含Lua框架和LiveCoding所需代码
│
│   
└───StreamingAssets                     
│   │
│   └───LuaScripts          //Lua相关代码
│       │   ...
│   
└───G6HotFix                //liveCoding相关C#代码
│       │
│       └───Editor
│       │   ...
│
│
│		
```


# demo使用方法
--------
首先要安装adb,并正确配置adb环境变量。

## Lua的liveCoding:
在unity的addressables包中包含的Hosting界面下，新加customServer-HttpPushHostingService并启动。
进入游戏后点击左上角的open按钮打开log面板，点击Hotfix按钮即可建立与本地HostServer的连接。
如果是安装在android手机上时，需要在命令行中执行adb命令。

```shell
adb reverse tcp:11000 tcp:11000
```

连接后可以在HttpPushHostingService中发送测试文本查看是否连接成功，连接成功时游戏中的log面板会打印发送的文本。

连接成功即可进行hotfix测试，在编辑器中修改lua代码，切回unity编辑器正常即可触发热更。

## 资源的LiveCoding:
在手机上使用Unity的Addressable系统时，需要通过USB线连接到开发者的pc上，并输入相应adb命令。端口对应Unity HostingServices中的端口号

```shell
adb reverse tcp:53036 tcp:53036
```

## C#的LiveCoding:
此特性需要使用修改后的AndroidPlayer来build apk，将来可能整合入Unity中国版，对解决中国游戏开发者的一些特殊需求应该也会有所帮助。
修改C#代码后，点击顶部菜单中的G6HotFix->NewScirptBuild&Push Dll, 等待编辑器中进度条消失后，重启手机上的应用即可。
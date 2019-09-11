# demo usage：
Install adb,and config adb environment.

## lua liveCoding:
Add and run customServer-HttpPushHostingService on the hosting window of addressables tools. 
After entering the game, click open button to open log panel, click hotfix buttone to connect to local HostServer.
If you are installing game on android device, you need to execute the adb command in the command line tool.

adb reverse tcp:11000 tcp:11000

After connecting to the local HostServer, you can send text message through HttpPushHostingService to check if the connection is succeeded. 
With a complete connection, log panel will print text sent from game.

If the connection is succeeded, you can test hotfix, edit Lua code in the IDE, after switching back to Unity editor, hotfix will be executed.

## Asset LiveCoding:
When using Addressable system on mobile device, you need to connect usb cable to the development PC, and input adb command. The port id is the same with Unity HostingServices port id.

adb reverse tcp:53036 tcp:53036

## dll LiveCoding:
This feature need to modify Unity Android Player. This feature will be integrated to China version of Unity and fullfill the needs of China developers.
After modifying C# code, click menu G6HotFix->NewScirptBuild&Push Dll, waiting for the progress bar completed and restart the game to see the effect.
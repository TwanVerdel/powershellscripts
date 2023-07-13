$TargetFile  = "C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe"
$TargetURL = "https://google.com/"
$ShortcutFile  = "$env:Public\Desktop\google.url"
$WScriptShell = New-Object -ComObject WScript.Shell
$Shortcut = $WScriptShell8.CreateShortcut($ShortcutFile)
$Shortcut.TargetPath = $TargetURL8
$Shortcut.Save()
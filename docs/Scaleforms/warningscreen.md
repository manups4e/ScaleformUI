---
layout: default
title: Warning Screen
parent: Scaleforms API
show_buttons: true
show_all_code: false
---

# Warning Screen
![image](https://user-images.githubusercontent.com/4005518/162582803-87963fe6-7ea2-4ef4-896a-65a579f755b3.png)

The Warning screen is a customizable screen that can be updated on the go and is compatible with instructionalButtons to make the user decide the action they wants to make.

```c#
Main.Warning
```

```lua
ScaleformUI.Scaleforms.Warning
```

## Functions

```c#
ShowWarning(string title, string subtitle, string prompt = "", string errorMsg = "", WarningPopupType type = WarningPopupType.Classic)
ShowWarningWithButtons(string title, string subtitle, string prompt, List<InstructionalButton> buttons, string errorMsg = "", WarningPopupType type = WarningPopupType.Classic)
UpdateWarning(string title, string subtitle, string prompt = "", string errorMsg = "", WarningPopupType type = WarningPopupType.Classic)
Dispose() // used to stop showing the Warning
OnButtonPressed (InstructionalButton button) // this is an event called if one of the instructional buttons available are pressed while the warning is showing
```

```lua
ShowWarning(title, subtitle, prompt, errorMsg, warningType)
ShowWarningWithButtons(title, subtitle, prompt, buttons, errorMsg, warningType)
UpdateWarning(title, subtitle, prompt, errorMsg, warningType)
Dispose() -- used to stop showing the Warning
OnButtonPressed = function(button) end -- function called if one of the instructional buttons available are pressed while the warning is showing
```

---
layout: default
title: Help Notification
parent: Notifications
show_buttons: true
show_all_code: false
---

# Help Notification
![image](https://user-images.githubusercontent.com/4005518/162587464-ef6a72bd-807b-4c49-af03-2bac78474c14.png)

## Usage
### C#
```c#
ShowHelpNotification(string helpText) // this needs to be called per frame
ShowHelpNotification(string helpText, int time) // this doesn't need to be called per frame!
```
### Lua
```lua
:ShowHelpNotification(helpText, time)
```

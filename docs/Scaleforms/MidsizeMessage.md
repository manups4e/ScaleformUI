---
layout: default
title: Midsize Message
parent: Scaleforms API
show_buttons: true
show_all_code: false
---

# Midsize Message

![image](https://user-images.githubusercontent.com/4005518/162582501-cd80a049-21ff-477e-b567-84b8fb477188.png)

```c#
Main.MedMessageInstance
```

```lua
ScaleformUI.Scaleforms.MidMessageInstance
```

## Functions
Time parameter is defaulted at 5000 if not specified.

```c#
void ShowColoredShard(string msg, string desc, HudColor bgColor, HudColor outColor = HudColor.HUD_COLOUR_FREEMODE, bool useDarkerShard = false, bool useCondensedShard = false, int time = 5000, float animTime = 0.33f)
```

```lua
function MidMessageInstance:ShowColoredShard(msg, desc, bgColor, useDarkerShard, useCondensedShard, time)
```

---
layout: default
title: Big Message
parent: Scaleforms API
show_buttons: true
show_all_code: false
---

# Big Message
![image](https://user-images.githubusercontent.com/4005518/162581479-ccb4dabe-9225-4e9a-9b20-69fb5f7f0c15.png)

```c#
Main.BigMessageInstance
```  

```lua
ScaleformUI.Scaleforms.BigMessageInstance
```

## Parameters

### Manual Dispose
Allows to choose if disposing of the scaleform movie will be manual or automatic after time ends.
Manual Dispose is also a parameter of all the available API functions. Check below.

```c#
public bool ManualDispose { get; set; }
```

```lua
BigMessageInstance._manualDispose
```

### Transition
These settings give full control of the transition animation. The available transitions are `TRANSITION_UP`, `TRANSITION_OUT`, `TRANSITION_DOWN`

```c#
public string Transition { get; set; } = "TRANSITION_OUT";
public float TransitionDuration { get; set; } = 0.4f;
public bool TransitionAutoExpansion { get; set; } = false;
```

```lua
function BigMessageInstance:SetTransition(transition, duration, preventAutoExpansion)
```

## Functions
Time parameter is defaulted at 5000 if not specified.

```c#
public void ShowMissionPassedMessage(string msg, int time = 5000, bool manualDispose = false){}
public void ShowMissionPassedMessage(ScaleformLabel msg, int time = 5000, bool manualDispose = false){}
public void ShowColoredShard(string msg, string desc, HudColor textColor, HudColor bgColor, int time = 5000, bool manualDispose = false){}
public void ShowOldMessage(string msg, int time = 5000, bool manualDispose = false){}
public void ShowSimpleShard(string title, string subtitle, int time = 5000, bool manualDispose = false){}
public void ShowRankupMessage(string msg, string subtitle, int rank, int time = 5000, bool manualDispose = false){}
public void ShowWeaponPurchasedMessage(string bigMessage, string weaponName, WeaponHash weapon, int time = 5000, bool manualDispose = false){}
public void ShowMpMessageLarge(string msg, int time = 5000, bool manualDispose = false){}
public void ShowMpWastedMessage(string msg, string sub, int time = 5000, bool manualDispose = false){}
public void ShowCustomShard(string funcName, params object[] paremeters){}
```

```lua
function BigMessageInstance:ShowMissionPassedMessage(msg, duration, manualDispose)
function BigMessageInstance:ShowColoredShard(msg, desc, textColor, bgColor, duration, manualDispose)
function BigMessageInstance:ShowOldMessage(msg, duration, manualDispose)
function BigMessageInstance:ShowSimpleShard(msg, subtitle, duration, manualDispose)
function BigMessageInstance:ShowRankupMessage(msg, subtitle, rank, duration, manualDispose)
function BigMessageInstance:ShowWeaponPurchasedMessage(bigMessage, weaponName, weaponHash, duration, manualDispose)
function BigMessageInstance:ShowMpMessageLarge(msg, duration, manualDispose)
function BigMessageInstance:ShowMpWastedMessage(msg, subtitle, duration, manualDispose)
```

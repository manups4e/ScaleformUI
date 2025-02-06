---
layout: default
title: Player List
parent: Scaleforms API
show_buttons: true
show_all_code: false
---

# Player List
![image](https://github.com/user-attachments/assets/74a0970e-4303-4b3f-aa91-1d80136e8d8a)

```c#
Main.PlayerListHandler
```  

```lua
ScaleformUI.Scaleforms.PlayerListHandler
```

## Features
To show and draw the player list you simply have to set CurrentPage to > 0 or use NextPage to let the API handle it.

```c#
public List<PlayerRow> PlayerRows { get; set; }
public int CurrentPage { get; set; }
public string TitleLeftText { get; set; }
public string TitleRightText { get; set; }
public int TitleIcon { get; set; }
public void SetTitle(string left, string right, int icon)
public void AddRow(PlayerRow row)
public void RemoveRow(PlayerRow row)
public void RemoveRow(int serverId)
public void NextPage()
public void SetHighlight(int idx)
public void DisplayMic(int idx, int unk)
public void UpdateSlot(PlayerRow row)
public void SetIcon(int index, ScoreRightIconType icon, string txt)
```

```lua
---@field public Enabled boolean
---@field public Index number
---@field public MaxPages number
---@field public currentPage number
---@field public PlayerRows table<number, SCPlayerItem>
---@field public TitleLeftText string
---@field public TitleRightText string
---@field public TitleIcon number
---@field public X number
---@field public Y number
---@field public Update fun():nil
---@field public NextPage fun():nil
---@field public AddRow fun(row:SCPlayerItem):nil
---@field public RemoveRow fun(index:number):nil
---@field public CurrentPage fun(_c:number?):number
---@field public Dispose fun():nil
---@field public Load fun():nil
---@field public SetTitle fun(title:string, label:string, icon:number):nil
---@field public SetPosition fun(x:number, y:number):nil
```
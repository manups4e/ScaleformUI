---
layout: default
title: Minimap Overlays
parent: Scaleforms API
show_buttons: true
show_all_code: false
---

# Minimap Overlays
![image](https://github.com/manups4e/ScaleformUI/assets/4005518/3f1dbc73-da73-4c8c-813e-cae8c92f96d8)

This is a custom scaleform that allows you to add as many overlays (textures) as you want to the ingame Map and Minimap, useful for custom maps and blips!

```c#
Main.MinimapOverlays
```

```lua
ScaleformUI.Scaleforms.MinimapOverlays
```

## ⚠️⚠️ Due to the nature of the Minimap Overlay Scaleform, being loaded as a file and not as a streamed scaleform, the only way you're able to use the Overlays is by calling an export to load the overlays metatable

```lua
local overlays = exports.ScaleformUI_Lua:GetMinimapOverlays()

-- you can then call the functions by doing
overlays:AddSizedOverlayToMap(textureDict, textureName, x, y, rotation, width, height, alpha, centered)
overlays:AddScaledOverlayToMap(textureDict, textureName, x, y, rotation, xScale, yScale, alpha, centered)
overlays:AddAreaOverlay(coordsTable, hasOutline, color)
overlays:SetOverlayColor(overlayId, color)
overlays:HideOverlay(overlayId, hide)
overlays:SetOverlayAlpha(overlayId, alpha)
overlays:SetOverlayPosition(overlayId, position)
overlays:SetOverlaySizeOrScale(overlayId, width, height)
overlays:RemoveOverlayFromMinimap(overlayId)
overlays:ClearAll()
```

## Functions

```c#
public static async Task<MinimapOverlay> AddSizedOverlayToMap(string textureDict, string textureName, float x, float y, float rotation = 0, float width = -1, float height = -1, int alpha = 100, bool centered = false) {}
public static async Task<MinimapOverlay> AddScaledOverlayToMap(string textureDict, string textureName, float x, float y, float rotation = 0, float xScale = 100f, float yScale = 100f, int alpha = 100, bool centered = false) {}
public static void SetOverlayColor(int overlayId, SColor color) {}
public static void HideOverlay(int overlayId, bool hide) {}
public static void SetOverlayAlpha(int overlayId, float alpha) {}
public static void SetOverlayPosition(int overlayId, Vector2 pos) {}
public static void SetOverlayPosition(int overlayId, float x, float y) {}
public static void SetOverlayPosition(int overlayId, float[] pos) {}
public static void SetOverlaySizeOrScale(int overlayId, SizeF size) {}
public static void SetOverlaySizeOrScale(int overlayId, float w, float h) {}
public static void SetOverlaySizeOrScale(int overlayId, float[] size) {}
public static void SetOverlayRotation(int overlayId, float rotation) {}
public static async void RemoveOverlayFromMinimap(int overlayId) {}
public static void ClearAll() {}
```

```lua
function MinimapOverlays:AddSizedOverlayToMap(textureDict, textureName, x, y, rotation, width, height, alpha, centered)
function MinimapOverlays:AddScaledOverlayToMap(textureDict, textureName, x, y, rotation, xScale, yScale, alpha, centered)
function MinimapOverlays:AddAreaOverlay(coordsTable, hasOutline, color)
function MinimapOverlays:SetOverlayColor(overlayId, color)
function MinimapOverlays:HideOverlay(overlayId, hide)
function MinimapOverlays:SetOverlayAlpha(overlayId, alpha)
function MinimapOverlays:SetOverlayPosition(overlayId, position)
function MinimapOverlays:SetOverlaySizeOrScale(overlayId, width, height)
function MinimapOverlays:RemoveOverlayFromMinimap(overlayId)
function MinimapOverlays:ClearAll()
```

## Minimap Overlay
Adding an overlay generates a `MinimapOverlay` item.
The `MinimapOverlay` item is a very simple class, it contains all the info of your added overlay.

### Minimap Overlay Parameters
```c#
public bool Visible
public int Handle { get; set; }
public string Txd { get; set; }
public string Txn { get; set; }
public SColor Color { get; set; }
public Vector2 Position { get; set; }
public float Rotation { get; set; }
public SizeF Size { get; set; }
public float Alpha { get; set; }
public bool Centered { get; set; }
```

```lua
overlay.Handle
overlay.Txd
overlay.Txn
overlay.Color
overlay.Position
overlay.Rotation
overlay.Size
overlay.Alpha
overlay.Centered
```
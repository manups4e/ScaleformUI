---
layout: default
title: Markers
parent: Notifications
show_buttons: true
show_all_code: false
---

# Markers
![image](https://user-images.githubusercontent.com/4005518/162584296-72fb5a66-49af-42e6-92b6-55e7ee726b5b.png)

Markers are quite easy to handle.

## Usage

```c#
new Marker(MarkerType type, Vector3 position, float distance, Color color, bool placeOnGround = false, bool bobUpDown = false, bool rotate = false, bool faceCamera = false)
new Marker(MarkerType type, Vector3 position, Vector3 scale, float distance, Color color, bool placeOnGround = false, bool bobUpDown = false, bool rotate = false, bool faceCamera = false)
```

```lua
Marker.New(type, position, scale, distance, color, placeOnGround, bobUpDown, rotate, faceCamera, checkZ)
```

## Properties
- **boolean IsInMarker**
- **boolean IsInRange**
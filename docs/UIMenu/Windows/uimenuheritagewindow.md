---
layout: default
title: UIMenuHeritageWindow
parent: Windows
show_buttons: true
show_all_code: false
---

# UIMenuHeritageWindow

![image](https://github.com/user-attachments/assets/a9a32bad-df40-4c39-b12e-cdff939ed2fc)

Heritage window is a preview of characters used in char creators to preview character heritage parents.

## Constructor

```c#
UIMenuHeritageWindow(int mom, int dad)
```

```lua
UIMenuHeritageWindow.New(Mom, Dad)
```

## Features 

### Mom and Dad values

```c#
public int Mom { get; }
public int Dad { get; }

public void Index(int mom, int dad)
```

```lua
window.Mom
window.Dad

window:Index(Mom, Dad)
```



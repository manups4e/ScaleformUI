---
layout: default
title: UIMenu
show_buttons: false
show_all_code: true
---
# UIMenu
**UIMenu** is the UI basic menus main class, it creates the base menu for you to add items to.

![UIMenu banner](https://user-images.githubusercontent.com/4005518/162590980-a84456c2-5aee-4481-a3f3-3626752f74ce.png)  

Below you can see examples of Menu initialization.

## C#
- Initialization example:

```c#
UIMenu mainMenu = new UIMenu("Banner Title", "SUBTITLE", new PointF(0, 0));
```

- Possible constructors:

```c#
public UIMenu(string title, string subtitle, bool glare = false, bool alternativeTitle = false, float fadingTime, MenuAlignment menuAlignment)

public UIMenu(string title, string subtitle, PointF offset, bool glare = false, bool alternativeTitle = false, float fadingTime, MenuAlignment menuAlignment)

public UIMenu(string title, string subtitle, PointF offset, KeyValuePair<string, string> customBanner, bool glare = false, bool alternativeTitle = false, float fadingTime, MenuAlignment menuAlignment)

public UIMenu(string title, string subtitle, PointF offset, string spriteLibrary, string spriteName, bool glare = false, bool alternativeTitle = false, float fadingTime, MenuAlignment menuAlignment)

public UIMenu(string title, string subtitle, string description, PointF offset, string spriteLibrary, string spriteName, bool glare = false, bool alternativeTitle = false, float fadingTime, MenuAlignment menuAlignment)
```

C# contructors come in multiple overloads, full list of parameters is:
- **title**: Title that appears on the big banner. Set to "" if you are using a custom banner.
- **subtitle**: Subtitle that appears in capital letters in a small black bar.
- **description**: screen width max long description like on GTA:O
- **offset**: PointF object with X and Y data for offsets. Applied to all menu elements.
- **spriteLibrary**: Sprite library name for the banner.
- **spriteName**: Sprite name for the banner.
- **glare**: Add menu Glare scaleform?.
- **alternativeTitle**: Set the alternative type to the title?.
- **fadingTime**: Set fading time for the menu and the items, set it to 0.0 to disable it.



## Lua

- Initialization example:

```lua
local mainMenu = UIMenu.New("Banner Title", "SUBTITLE", 0, 0)
```

- Constructor:

```lua
function UIMenu.New(title, subTitle, x, y, glare, txtDictionary, txtName, alternativeTitleStyle, fadeTime, longdesc, align)
```


Full list of parameters is:

- **title** [string]: -- Menu title
- **subTitle** [string]: -- Menu subtitle
- **x** [number or nil]: -- Menu Offset X position
- **y** [number or nil]: -- Menu Offset Y position
- **glare** [boolean or nil]: -- Menu glare effect
- **txtDictionary** [string or nil]: -- Custom texture dictionary for the menu banner background (default: commonmenu)
- **txtName** [string or nil]: -- Custom texture name for the menu banner background (default: interaction_bgd)
- **alternativeTitleStyle** [boolean or nil]: -- Use alternative title style (default: false)
- **fadeTime** [number or nil]: -- 0.1 by default, the higher the slowest. Values are in seconds where 0.1 means 100ms. 0.0 to disable fading.
- **longdesc** [string or nil]: -- screen width max long description like on GTA:O
- **align** [MenuAlignment or nil]: -- Menu alignment can be LEFT or RIGHT and it's safe bounds responsive (center will be added in future updates)

## Description
![description image](https://user-images.githubusercontent.com/4005518/162612416-63b1a6f8-e74f-4ed6-8ac2-39c5b0cadd46.png)  
The menu will show a description for each item that has one, the description is bounded to the selected item and will change when you select a different item.  
It supports emojis, blips, and input icons.
---
layout: default
title: Getting Started
permalink: /getting-started/
nav_order: 2
---

## Requirements  
* Grand Theft Auto V  
* FiveM  
* Visual Studio or FxDK for C#
* Visual Sudio code or any editor of your choice or FxDK for Lua
* ScaleformUI

## How to install ScaleformUI  

### Streaming the Scaleforms.
FiveM and streamed scaleforms are a strange match, if you would place the streamed gfxs along with your resource and restart it.. weird things happen!!  
So to avoid bad things, i prepared a zip called ScaleformUI_Assets containing a ready to start empty script to stream your scaleforms separated from any script at all. This way even if you restart your script 100 times, the scaleforms won't go 🍌🍌🍌.  
Simply unzip ScaleformUI_Assets and place the resource wherever you want in your resources folder and start it before you start any other ScaleformUI dependant script.

### C# 
1. Download the latest release of ScaleformUI_Csharp, unzip it and place it in your resources folder.
2. It contains the ScaleformUI library and ExamleMenu script. If you want to use the library directly, simply take ScaleformUI.dll and delete the rest.
3. Add ScaleformUI.dll to your references in your Visual Studio /FxDK project and in your script's folder specifying it in the resource manifest's `files {}` section.

### Lua
1. Download the latest release of ScaleformUI_Lua, unzip it and place it in your resources folder.
2. It contains the ScaleformUI.lua file, the 💖 of your API and example.lua. If you don't want the example menu, simply delete the file and remove it from the manifest.
3. Remember to start the ScaleformUI script after you started the Assets to ensure the scaleforms are loaded correctly on client joining!

## How to use it?  
### C#
Simply use the reference in the project and on compilation it should copy the dll in the output folder along with your client.net.dll, copy the dll if you didn't do that before and add the reference in the resource's manifest `files {}` section, you're good to go!🍾🥂🎉

### Lua
There are 2 ways you can use the ScaleformUI.lua library.
1. First option: Place your ScaleformUI.lua in each resource that uses it and start it before any other client file.
2. Second option: Leave it in its own ScaleformUI resource and start it before the other resources. When you want to use it in any resource simply add `"@ScaleformUI_Lua/ScaleformUI.lua",` in the resource manifest in the client_scripts section before anything else.  

I personally suggest the **second option** for 2 main reasons: the first is that whenever you need to update the API you do it only once in its own resource, the second reason is that this way you don't risk to have multiple instances of the API at the same time for each script.. less memory used, happy players, happy server scripter, happy me! 🥳🥳

---

**Now for the fun part.**
## How do i make a menu?  

You can create a menu by using the **UIMenu** class, a Pause Menu using **TabView** class or a Lobby Screen using **MainView** class.
The **UIMenu** class is the main class that handles the menu and all the items the menu contains.
Once the menu is declared you need to add items to it, there are different types of items, 
* **UIMenuItem**: for basic items
* **UIMenuListItem**: for list items (soon to be deprecated)
* **UIMenuDynamicListItem**: for list items and runtime execution (dynamic lists, soon to be default list item)
* **UIMenuCheckboxItem**: for true / false statements
* **UIMenuSliderItem**: for sliding issues
* **UIMenuProgressItem**: for progress choices like a volume up/down
* **UIMenuSeparatorItem**: a separator between items
* **UIMenuStatsItem**: **special** item similar to progress item used especially in char creation menus.

Each item has its own features but all of them are an inheritance of UIMenuItem, the basic item where all begins.  
The menu doesn't stop with the **items**. Each item can define a number of **Panels** that will be displayed below or besides the menu.
And along with the items, the menu can contain **windows** like the **Heritage** window, or the **Statistics** window!

How the items, the panels and the windows interact with the menu we'll see it in the related pages of the wiki, but if you're impatient you can go check the example menus! They contain almost all the features and a showcase of how all the items are coded to work in the menu.
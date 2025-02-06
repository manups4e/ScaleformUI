---
layout: default
title: Big Feed
parent: Scaleforms API
show_buttons: true
show_all_code: false
---

# Big Feed

![image](https://github.com/manups4e/ScaleformUI/assets/4005518/62bc56a8-c67d-43f6-9c6a-2511b23a7c04)

```c#
Main.BigFeed
```  

```lua
ScaleformUI.Scaleforms.BigFeed
```

## Functions 
```c#
bool RightAligned // Decides if the feed is centered or right aligned, *MUST* be called before Enabled
bool DisabledNotifications // If true disables all kind of notifications while the feed is showing
string Title // Sets the title of the BigFeedInstance
string Subtitle // Sets the subtitle of the BigFeedInstance
string BodyText // Sets the body text of the BigFeedInstance
string TextureDictionary // The Texture Dictionary (TXD) where the texture is loaded
string TextureName // The texture in the dictionary
bool Enabled // Toggles the BigFeedInstance on or off
void UpdatePicture(string txd, string txn) // updates the texture
```

```lua
:Title(title) -- Sets the title of the BigFeedInstance, if no title is provided it will return the current title
:Subtitle(subtitle) -- Sets the subtitle of the BigFeedInstance, if no subtitle is provided it will return the current subtitle
:BodyText(body) -- Sets the body text of the BigFeedInstance, if no body text is provided it will return the current body text
:RightAligned(rightAligned) -- [boolean] Sets the BigFeedInstance to be right aligned, if no state is provided it will return the current state
:Texture(textureName, textureDictionary) -- Sets the texture of the BigFeedInstance, if no texture is provided it will return the current texture
:Enabled(enabled) -- [boolean] Toggles the BigFeedInstance on or off, if a state is not provided it will return the current enabled state
```
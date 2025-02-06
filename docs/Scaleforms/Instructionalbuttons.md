---
layout: default
title: Instructional Buttons
parent: Scaleforms API
show_buttons: true
show_all_code: false
---

# Instructional Buttons
One of the most used and most important scaleforms in FiveM and in ScaleformUI.

![image](https://user-images.githubusercontent.com/4005518/162583983-be7a6a7d-c976-4258-9aea-c5e03d15c514.png)

The instructional buttons are used to guide the player while using the menus but they can be used for whatever reason (one of them is the saving notification).

```c#
Main.InstructionalButtons
```

```lua
ScaleformUI.Scaleforms.InstructionalButtons
```

Before showing what and how this scaleform performs, we need to look at one more component to make it work, an `InstructionalButton` must be declared for each control the developer wants to add or remove.

the InstructionalButton can be created in a list in c# or in a table in lua and then the list/table can be added via the instructionalButtons's SetInstructionalButtons function.

here's an example:  

```c#
// new InstructionalButton(Control control, string text, PadCheck padFilter = PadCheck.Any)
// new InstructionalButton(List<Control> controls, string text, PadCheck padFilter = PadCheck.Any)
// new InstructionalButton(Control gamepadControl, Control keyboardControl, string text)
// InstructionalButton(List<Control> gamepadControls, List<Control> keyboardControls, string text)
// InstructionalButton(InputGroup control, string text, PadCheck padFilter = PadCheck.Any)

List<InstructionalButton> buttons = new List<InstructionalButton>()
{
	new InstructionalButton(Control.PhoneCancel, Game.GetGXTEntry("HUD_INPUT3")),
	new InstructionalButton(Control.LookUpDown, "Scroll text", PadCheck.Controller),
	new InstructionalButton(InputGroup.INPUTGROUP_CURSOR_SCROLL, "Scroll text", PadCheck.Keyboard)
	// cannot make difference between controller / keyboard here in 1 line because we are using the InputGroup for keyboard
};
ScaleformUI.InstructionalButtons.SetInstructionalButtons(buttons);

```

```lua
-- InstructionalButton.New(text, padcheck, gamepadControls, keyboardControls, inputGroup)

-- padCheck can be -1 for both, 0 for gamepad, 1 for keyboard and mouse, it filters to show that control only for the selected control or both
-- gamepadControls can be one or a table of controls, for example 51 or {51, 47, 176, 177}
-- keyboardControls the same as gamepadControls,
-- inpuGroup can be set to handle all the buttons needed automatically (needs gamepad and keyboard controls to be -1)

local buttons = {
	InstructionalButton.New(GetLabelText("HUD_INPUT3"), -1, 177, 177, -1),
	InstructionalButton.New("Scroll text", 0, 2, -1, -1),
	InstructionalButton.New("Scroll text", 1, -1, -1, "INPUTGROUP_CURSOR_SCROLL")
	-- cannot make difference between controller / keyboard here in 1 line because we are using the InputGroup for keyboard
}
ScaleformUI.Scaleforms.InstructionalButtons:SetInstructionalButtons(buttons)
```

The InstructionalButton can be filtered, setting 1 or more controls for controller / keyboard separately and can handle InputGroups, using the padcheck the control selected will be shown only if the player is using one of the 2 input methods.

## Parameters

### IsSaving check
Used to check if the saving notification is showing (Busy Spinner)

```c#
public bool IsSaving {get;}
```

```lua
ScaleformUI.Scaleforms.InstructionalButtons.IsSaving
```

## Functions

```c#
public void SetInstructionalButtons(List<InstructionalButton> buttons) {}
public void AddInstructionalButton(InstructionalButton button) {}
public void RemoveInstructionalButton(InstructionalButton button) {}
public void RemoveInstructionalButtons(List<InstructionalButton> buttons) {}
public void RemoveInstructionalButton(int button) {}
public void ClearButtonList() {}
public void AddSavingText(LoadingSpinnerType spinnerType, string text, int time) {}
public void AddSavingText(LoadingSpinnerType spinnerType, string text) {}
public void HideSavingText() {}
public static bool IsControlJustPressed(Control control, PadCheck keyboardOnly = PadCheck.Any) {}
public void ForceUpdate() {}
```

```lua
function ButtonsHandler:SetInstructionalButtons(buttons)
function ButtonsHandler:AddInstructionalButton(button)
function ButtonsHandler:RemoveInstructionalButton(button)
function ButtonsHandler:ClearButtonList()
function ButtonsHandler:Refresh()
function ButtonsHandler:ShowBusySpinner(spinnerType, text, time, manualDispose)
function ButtonsHandler:HideBusySpinner()
```
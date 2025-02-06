---
layout: default
title: Mission Selector
parent: Scaleforms API
show_buttons: true
show_all_code: false
---

# Mission Selector
![image](https://github.com/manups4e/ScaleformUI/assets/4005518/4dff1186-cd1e-4685-b77b-8101fe8859f1)

The mission selector handler implements the use of the JobSelectionButton, JobSelectionCard and MissionDetailsItem (details below)

```c#
Main.JobMissionSelection
```  

```lua
ScaleformUI.Scaleforms.JobMissionSelector
```

## Features

```c#
int[] Votes // up to 9 votes (6 cards + 3 buttons)
int VotedFor
int MaxVotes
int SelectedCard
HudColor VotesColor // defaulted to HudColor.HUD_COLOUR_BLUE
JobSelectionTitle JobTitle
List<JobSelectionCard> Cards // 6 cards
List<JobSelectionButton> Buttons // 3 buttons
bool Enabled
bool AlreadyVoted
void SetTitle(string title)
void SetVotes(int actual, string label = "")
void AddCard(JobSelectionCard card)
void AddButton(JobSelectionButton button)
void ShowPlayerVote(int idx, string playerName, HudColor color, bool showCheckMark = false, bool flashBG = false)
```

```lua
.Votes
.VotedFor
.VotesColor -- default Colours.HUD_COLOUR_BLUE
:SetTitle(title)
:SetVotes(actual, label)
:AddCard(card)
:AddButton(button)
:Enabled(bool)
:AlreadyVoted()
:ShowPlayerVote(idx, playerName, color, showCheckMark, flashBG)
```

Example code for the Mission Selector

```c#
if (ScaleformUI.Main.JobMissionSelection.Enabled)
{
    ScaleformUI.Main.JobMissionSelection.Enabled = false;
    return;
}

long txd = API.CreateRuntimeTxd("test");
long _paneldui = API.CreateDui("https://i.imgur.com/mH0Y65C.gif", 288, 160);
API.CreateRuntimeTextureFromDuiHandle(txd, "panelbackground", API.GetDuiHandle(_paneldui));

ScaleformUI.Main.JobMissionSelection.SetTitle("MISSION SELECTOR");
ScaleformUI.Main.JobMissionSelection.MaxVotes = 3;
ScaleformUI.Main.JobMissionSelection.SetVotes(0, "VOTES");
ScaleformUI.Main.JobMissionSelection.Cards = new List<JobSelectionCard>();

JobSelectionCard card = new JobSelectionCard("Test 1", "~y~Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat", "test", "panelbackground", 12, 15, JobSelectionCardIcon.BASE_JUMPING, HudColor.HUD_COLOUR_FREEMODE, 2, new List<MissionDetailsItem>()
{
    new MissionDetailsItem("Left Label", "Right Label", 0, HudColor.HUD_COLOUR_FREEMODE),
    new MissionDetailsItem("Left Label", "Right Label", (JobIcon)1, HudColor.HUD_COLOUR_GOLD),
    new MissionDetailsItem("Left Label", "Right Label", (JobIcon)2, HudColor.HUD_COLOUR_PURPLE),
    new MissionDetailsItem("Left Label", "Right Label", (JobIcon)3, HudColor.HUD_COLOUR_GREEN),
    new MissionDetailsItem("Left Label", "Right Label", (JobIcon)4, HudColor.HUD_COLOUR_WHITE, true),
});
ScaleformUI.Main.JobMissionSelection.AddCard(card);

JobSelectionCard card1 = new JobSelectionCard("Test 2", "~y~Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat", "test", "panelbackground", 12, 15, JobSelectionCardIcon.BASE_JUMPING, HudColor.HUD_COLOUR_FREEMODE, 2, new List<MissionDetailsItem>()
{
    new MissionDetailsItem("Left Label", "Right Label", (JobIcon)5, HudColor.HUD_COLOUR_FREEMODE),
    new MissionDetailsItem("Left Label", "Right Label", (JobIcon)6, HudColor.HUD_COLOUR_GOLD),
    new MissionDetailsItem("Left Label", "Right Label", (JobIcon)7, HudColor.HUD_COLOUR_PURPLE),
    new MissionDetailsItem("Left Label", "Right Label", (JobIcon)8, HudColor.HUD_COLOUR_GREEN),
    new MissionDetailsItem("Left Label", "Right Label", (JobIcon)9, HudColor.HUD_COLOUR_WHITE, true),
});
ScaleformUI.Main.JobMissionSelection.AddCard(card1);

JobSelectionCard card2 = new JobSelectionCard("Test 3", "~y~Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat", "test", "panelbackground", 12, 15, JobSelectionCardIcon.BASE_JUMPING, HudColor.HUD_COLOUR_FREEMODE, 2, new List<MissionDetailsItem>()
{
    new MissionDetailsItem("Left Label", "Right Label", (JobIcon)10, HudColor.HUD_COLOUR_FREEMODE),
    new MissionDetailsItem("Left Label", "Right Label", (JobIcon)11, HudColor.HUD_COLOUR_GOLD),
    new MissionDetailsItem("Left Label", "Right Label", (JobIcon)12, HudColor.HUD_COLOUR_PURPLE),
    new MissionDetailsItem("Left Label", "Right Label", (JobIcon)13, HudColor.HUD_COLOUR_GREEN),
    new MissionDetailsItem("Left Label", "Right Label", (JobIcon)14, HudColor.HUD_COLOUR_WHITE, true),
});
ScaleformUI.Main.JobMissionSelection.AddCard(card2);

JobSelectionCard card3 = new JobSelectionCard("Test 4", "~y~Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat", "test", "panelbackground", 12, 15, JobSelectionCardIcon.BASE_JUMPING, HudColor.HUD_COLOUR_FREEMODE, 2, new List<MissionDetailsItem>()
{
    new MissionDetailsItem("Left Label", "Right Label", (JobIcon)15, HudColor.HUD_COLOUR_FREEMODE),
    new MissionDetailsItem("Left Label", "Right Label", (JobIcon)16, HudColor.HUD_COLOUR_GOLD),
    new MissionDetailsItem("Left Label", "Right Label", (JobIcon)17, HudColor.HUD_COLOUR_PURPLE),
    new MissionDetailsItem("Left Label", "Right Label", (JobIcon)18, HudColor.HUD_COLOUR_GREEN),
    new MissionDetailsItem("Left Label", "Right Label", (JobIcon)19, HudColor.HUD_COLOUR_WHITE, true),
});
ScaleformUI.Main.JobMissionSelection.AddCard(card3);

JobSelectionCard card4 = new JobSelectionCard("Test 5", "~y~Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat", "test", "panelbackground", 12, 15, JobSelectionCardIcon.BASE_JUMPING, HudColor.HUD_COLOUR_FREEMODE, 2, new List<MissionDetailsItem>()
{
    new MissionDetailsItem("Left Label", "Right Label", (JobIcon)20, HudColor.HUD_COLOUR_FREEMODE),
    new MissionDetailsItem("Left Label", "Right Label", (JobIcon)21, HudColor.HUD_COLOUR_GOLD),
    new MissionDetailsItem("Left Label", "Right Label", (JobIcon)22, HudColor.HUD_COLOUR_PURPLE),
    new MissionDetailsItem("Left Label", "Right Label", (JobIcon)23, HudColor.HUD_COLOUR_GREEN),
    new MissionDetailsItem("Left Label", "Right Label", (JobIcon)24, HudColor.HUD_COLOUR_WHITE, true),
});
ScaleformUI.Main.JobMissionSelection.AddCard(card4);

JobSelectionCard card5 = new JobSelectionCard("Test 6", "~y~Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat", "test", "panelbackground", 12, 15, JobSelectionCardIcon.BASE_JUMPING, HudColor.HUD_COLOUR_FREEMODE, 2, new List<MissionDetailsItem>()
{
    new MissionDetailsItem("Left Label", "Right Label", 0, HudColor.HUD_COLOUR_FREEMODE),
    new MissionDetailsItem("Left Label", "Right Label", (JobIcon)1, HudColor.HUD_COLOUR_GOLD),
    new MissionDetailsItem("Left Label", "Right Label", (JobIcon)2, HudColor.HUD_COLOUR_PURPLE),
    new MissionDetailsItem("Left Label", "Right Label", (JobIcon)3, HudColor.HUD_COLOUR_GREEN),
    new MissionDetailsItem("Left Label", "Right Label", (JobIcon)4, HudColor.HUD_COLOUR_WHITE, true),
});
ScaleformUI.Main.JobMissionSelection.AddCard(card5);

ScaleformUI.Main.JobMissionSelection.Buttons = new List<JobSelectionButton>()
{
    new JobSelectionButton("Test1", "description test", new List<MissionDetailsItem>()) {Selectable = false },

    new JobSelectionButton("Test2", "description test", new List<MissionDetailsItem>()) {Selectable = false },

    new JobSelectionButton("Test3", "description test", new List<MissionDetailsItem>()) {Selectable = true },
};
ScaleformUI.Main.JobMissionSelection.Buttons[0].OnButtonPressed += () =>
{
    Screen.ShowSubtitle($"Button Pressed => {ScaleformUI.Main.JobMissionSelection.Buttons[0].Text}");
};

ScaleformUI.Main.JobMissionSelection.Enabled = true;

await Delay(1000);
ScaleformUI.Main.JobMissionSelection.ShowPlayerVote(2, "PlayerName", HudColor.HUD_COLOUR_GREEN, true, true);
```

```lua
local MissionSelectorVisible = false
function CreateMissionSelectorMenu()

	MissionSelectorVisible = not MissionSelectorVisible

	if not MissionSelectorVisible then 
		ScaleformUI.Scaleforms.JobMissionSelector:Enabled(false) 
		return
	end

	local txd = CreateRuntimeTxd("test")
	local _paneldui = CreateDui("https://i.imgur.com/mH0Y65C.gif", 288, 160)
	CreateRuntimeTextureFromDuiHandle(txd, "panelbackground", GetDuiHandle(_paneldui))

	ScaleformUI.Scaleforms.JobMissionSelector:SetTitle("MISSION SELECTOR")
	ScaleformUI.Scaleforms.JobMissionSelector.MaxVotes = 3
	ScaleformUI.Scaleforms.JobMissionSelector:SetVotes(0, "VOTED")
	ScaleformUI.Scaleforms.JobMissionSelector.Cards = {}

	local card = JobSelectionCard.New("Test 1", "~y~Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat", "test", "panelbackground", 12, 15, JobSelectionCardIcon.BASE_JUMPING, Colours.HUD_COLOUR_FREEMODE, 2, {
		MissionDetailsItem.New("Left Label", "Right Label", false, JobIcon.GTAOMission, Colours.HUD_COLOUR_FREEMODE),
		MissionDetailsItem.New("Left Label", "Right Label", false, JobIcon.Deathmatch, Colours.HUD_COLOUR_GOLD),
		MissionDetailsItem.New("Left Label", "Right Label", false, JobIcon.RaceFinish, Colours.HUD_COLOUR_PURPLE),
		MissionDetailsItem.New("Left Label", "Right Label", false, JobIcon.GTAOSurvival, Colours.HUD_COLOUR_GREEN),
		MissionDetailsItem.New("Left Label", "Right Label", false, JobIcon.TeamDeathmatch, Colours.HUD_COLOUR_WHITE, true),
	})
	ScaleformUI.Scaleforms.JobMissionSelector:AddCard(card)

	local card1 = JobSelectionCard.New("Test 2", "~y~Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat", "test", "panelbackground", 12, 15, JobSelectionCardIcon.BASE_JUMPING, Colours.HUD_COLOUR_FREEMODE, 2, {
		MissionDetailsItem.New("Left Label", "Right Label", false, JobIcon.GTAOMission, Colours.HUD_COLOUR_FREEMODE),
		MissionDetailsItem.New("Left Label", "Right Label", false, JobIcon.Deathmatch, Colours.HUD_COLOUR_GOLD),
		MissionDetailsItem.New("Left Label", "Right Label", false, JobIcon.RaceFinish, Colours.HUD_COLOUR_PURPLE),
		MissionDetailsItem.New("Left Label", "Right Label", false, JobIcon.GTAOSurvival, Colours.HUD_COLOUR_GREEN),
		MissionDetailsItem.New("Left Label", "Right Label", false, JobIcon.TeamDeathmatch, Colours.HUD_COLOUR_WHITE, true),
	})
	ScaleformUI.Scaleforms.JobMissionSelector:AddCard(card1)

	local card2 = JobSelectionCard.New("Test 3", "~y~Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat", "test", "panelbackground", 12, 15, JobSelectionCardIcon.BASE_JUMPING, Colours.HUD_COLOUR_FREEMODE, 2, {
		MissionDetailsItem.New("Left Label", "Right Label", false, JobIcon.GTAOMission, Colours.HUD_COLOUR_FREEMODE),
		MissionDetailsItem.New("Left Label", "Right Label", false, JobIcon.Deathmatch, Colours.HUD_COLOUR_GOLD),
		MissionDetailsItem.New("Left Label", "Right Label", false, JobIcon.RaceFinish, Colours.HUD_COLOUR_PURPLE),
		MissionDetailsItem.New("Left Label", "Right Label", false, JobIcon.GTAOSurvival, Colours.HUD_COLOUR_GREEN),
		MissionDetailsItem.New("Left Label", "Right Label", false, JobIcon.TeamDeathmatch, Colours.HUD_COLOUR_WHITE, true),
	})
	ScaleformUI.Scaleforms.JobMissionSelector:AddCard(card2)

	local card3 = JobSelectionCard.New("Test 4", "~y~Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat", "test", "panelbackground", 12, 15, JobSelectionCardIcon.BASE_JUMPING, Colours.HUD_COLOUR_FREEMODE, 2, {
		MissionDetailsItem.New("Left Label", "Right Label", false, JobIcon.GTAOMission, Colours.HUD_COLOUR_FREEMODE),
		MissionDetailsItem.New("Left Label", "Right Label", false, JobIcon.Deathmatch, Colours.HUD_COLOUR_GOLD),
		MissionDetailsItem.New("Left Label", "Right Label", false, JobIcon.RaceFinish, Colours.HUD_COLOUR_PURPLE),
		MissionDetailsItem.New("Left Label", "Right Label", false, JobIcon.GTAOSurvival, Colours.HUD_COLOUR_GREEN),
		MissionDetailsItem.New("Left Label", "Right Label", false, JobIcon.TeamDeathmatch, Colours.HUD_COLOUR_WHITE, true),
	})
	ScaleformUI.Scaleforms.JobMissionSelector:AddCard(card3)

	local card4 = JobSelectionCard.New("Test 5", "~y~Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat", "test", "panelbackground", 12, 15, JobSelectionCardIcon.BASE_JUMPING, Colours.HUD_COLOUR_FREEMODE, 2, {
		MissionDetailsItem.New("Left Label", "Right Label", false, JobIcon.GTAOMission, Colours.HUD_COLOUR_FREEMODE),
		MissionDetailsItem.New("Left Label", "Right Label", false, JobIcon.Deathmatch, Colours.HUD_COLOUR_GOLD),
		MissionDetailsItem.New("Left Label", "Right Label", false, JobIcon.RaceFinish, Colours.HUD_COLOUR_PURPLE),
		MissionDetailsItem.New("Left Label", "Right Label", false, JobIcon.GTAOSurvival, Colours.HUD_COLOUR_GREEN),
		MissionDetailsItem.New("Left Label", "Right Label", false, JobIcon.TeamDeathmatch, Colours.HUD_COLOUR_WHITE, true),
	})
	ScaleformUI.Scaleforms.JobMissionSelector:AddCard(card4)

	local card5 = JobSelectionCard.New("Test 6", "~y~Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat", "test", "panelbackground", 12, 15, JobSelectionCardIcon.BASE_JUMPING, Colours.HUD_COLOUR_FREEMODE, 2, {
		MissionDetailsItem.New("Left Label", "Right Label", false, JobIcon.GTAOMission, Colours.HUD_COLOUR_FREEMODE),
		MissionDetailsItem.New("Left Label", "Right Label", false, JobIcon.Deathmatch, Colours.HUD_COLOUR_GOLD),
		MissionDetailsItem.New("Left Label", "Right Label", false, JobIcon.RaceFinish, Colours.HUD_COLOUR_PURPLE),
		MissionDetailsItem.New("Left Label", "Right Label", false, JobIcon.GTAOSurvival, Colours.HUD_COLOUR_GREEN),
		MissionDetailsItem.New("Left Label", "Right Label", false, JobIcon.TeamDeathmatch, Colours.HUD_COLOUR_WHITE, true),
	})
	ScaleformUI.Scaleforms.JobMissionSelector:AddCard(card5)

	ScaleformUI.Scaleforms.JobMissionSelector.Buttons = {
		JobSelectionButton.New("Button 1", "description test", {
			MissionDetailsItem.New("Left Label", "Right Label", false, JobIcon.GTAOMission, Colours.HUD_COLOUR_FREEMODE),
			MissionDetailsItem.New("Left Label", "Right Label", false, JobIcon.Deathmatch, Colours.HUD_COLOUR_GOLD),
			MissionDetailsItem.New("Left Label", "Right Label", false, JobIcon.RaceFinish, Colours.HUD_COLOUR_PURPLE),
			MissionDetailsItem.New("Left Label", "Right Label", false, JobIcon.GTAOSurvival, Colours.HUD_COLOUR_GREEN),
			MissionDetailsItem.New("Left Label", "Right Label", false, JobIcon.TeamDeathmatch, Colours.HUD_COLOUR_WHITE, true),
		}),
		JobSelectionButton.New("Button 2", "description test", {
			MissionDetailsItem.New("Left Label", "Right Label", false, JobIcon.GTAOMission, Colours.HUD_COLOUR_FREEMODE),
			MissionDetailsItem.New("Left Label", "Right Label", false, JobIcon.Deathmatch, Colours.HUD_COLOUR_GOLD),
			MissionDetailsItem.New("Left Label", "Right Label", false, JobIcon.RaceFinish, Colours.HUD_COLOUR_PURPLE),
			MissionDetailsItem.New("Left Label", "Right Label", false, JobIcon.GTAOSurvival, Colours.HUD_COLOUR_GREEN),
			MissionDetailsItem.New("Left Label", "Right Label", false, JobIcon.TeamDeathmatch, Colours.HUD_COLOUR_WHITE, true),
		}),
		JobSelectionButton.New("Button 3", "description test", {
			MissionDetailsItem.New("Left Label", "Right Label", false, JobIcon.GTAOMission, Colours.HUD_COLOUR_FREEMODE),
			MissionDetailsItem.New("Left Label", "Right Label", false, JobIcon.Deathmatch, Colours.HUD_COLOUR_GOLD),
			MissionDetailsItem.New("Left Label", "Right Label", false, JobIcon.RaceFinish, Colours.HUD_COLOUR_PURPLE),
			MissionDetailsItem.New("Left Label", "Right Label", false, JobIcon.GTAOSurvival, Colours.HUD_COLOUR_GREEN),
			MissionDetailsItem.New("Left Label", "Right Label", false, JobIcon.TeamDeathmatch, Colours.HUD_COLOUR_WHITE, true),
		}),
	}
	ScaleformUI.Scaleforms.JobMissionSelector.Buttons[1].Selectable = false
	ScaleformUI.Scaleforms.JobMissionSelector.Buttons[2].Selectable = false
	ScaleformUI.Scaleforms.JobMissionSelector.Buttons[3].Selectable = true

	ScaleformUI.Scaleforms.JobMissionSelector.Buttons[1].OnButtonPressed = function()
		ScaleformUI.Notifications:ShowSubtitle("Button Pressed => " .. ScaleformUI.Scaleforms.JobMissionSelector.Buttons[1].Text)
	end
	ScaleformUI.Scaleforms.JobMissionSelector:Enabled(true)
	
	Citizen.Wait(1000)
	ScaleformUI.Scaleforms.JobMissionSelector:ShowPlayerVote(3, "PlayerName", Colours.HUD_COLOUR_GREEN, true, true)
end
```

### JobSelectionCard

```c#
string Title
string Description 
string Txd 
string Txn 
int RpMultiplier 
int CashMultiplier
JobSelectionCardIcon Icon 
HudColor IconColor 
int ApMultiplier 
List<MissionDetailsItem> Details // not more than 4!!

JobSelectionCard(string title, string description, string txd, string txn, int rpMult, int cashMult, JobSelectionCardIcon icon, HudColor iconColor, int apMultiplier, List<MissionDetailsItem> details)
```

```lua
---@param title string
---@param description string
---@param txd string
---@param txn string
---@param rpMult number
---@param cashMult number
---@param icon JobSelectionCardIcon
---@param iconColor Colours
---@param apMultiplier number
---@param details table<MissionDetailsItem>
JobSelectionCard.New(title, description, txd, txn, rpMult, cashMult, icon, iconColor, apMultiplier, details)
---@field public Title string
---@field public Description string
---@field public Txd string
---@field public Txn string
---@field public RpMultiplier number
---@field public CashMultiplier number
---@field public Icon JobSelectionCardIcon
---@field public IconColor Colours
---@field public ApMultiplier number
---@field public Details table<MissionDetailsItem> -- not more than 4!!
```
### JobSelectionButton


```c#
string Text
string Description
List<MissionDetailsItem> // NOT MORE THAN 5
JobSelectionButtonEvent OnButtonPressed
JobSelectionButton(string text, string description, List<MissionDetailsItem> details)
```

```lua
---@param title string
---@param description string
---@param details table<MissionDetailsItem>
JobSelectionButton.New(title, description, details)
---@field public Text string
---@field public Description string
---@field public Details table<MissionDetailsItem> -- NOT MORE THAN 5
---@field public OnButtonPressed fun(self: JobSelectionButton)
```
### MissionDetailsItem


```c#
JobIcon Icon
string TextLeft
string TextRight
HudColor IconColor
int Type
bool Tick
MissionDetailsItem(string textLeft, string textRight, bool separator)
MissionDetailsItem(string textLeft, string textRight, JobIcon icon, HudColor iconColor = HudColor.NONE, bool tick = false)
```

```lua
---@param textLeft string
---@param textRight string
---@param seperator boolean
---@param icon JobIcon
---@param iconColor Colours
---@param tick boolean
MissionDetailsItem.New(textLeft, textRight, seperator, icon, iconColor, tick)

---@field public Type number
---@field public TextLeft string
---@field public TextRight string
---@field public Icon JobIcon
---@field public IconColor Colours
---@field public Tick boolean
```

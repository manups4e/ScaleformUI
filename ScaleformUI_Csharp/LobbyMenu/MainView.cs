using System;
using System.Collections.Generic;
using System.Drawing;
using System.Linq;
using CitizenFX.Core;
using CitizenFX.Core.Native;
using static CitizenFX.Core.Native.API;
using CitizenFX.Core.UI;
using Font = CitizenFX.Core.UI.Font;

namespace ScaleformUI.LobbyMenu
{
    public class MainView : PauseMenuBase
    {
        public string Title { get; set; }
        public string SubTitle { get; set; }
        public string SideStringTop { get; set; }
        public string SideStringMiddle { get; set; }
        public string SideStringBottom { get; set; }
        public Tuple<string, string> HeaderPicture { internal get; set; }
        public Tuple<string, string> CrewPicture { internal get; set; }
        public bool IsLobby { get; set; }
        public List<UIMenuItem> LeftItems { get; private set; }
        public List<LobbyItem> CenterItems { get; private set; }
        public int LeftItemIndex
        {
            get => leftItemIndex;
            set
            {
                leftItemIndex = value;
                //SendPauseMenuLeftItemChange();
            }
        }

        public bool TemporarilyHidden { get; set; }
        public bool HideTabs { get; set; }
        public bool DisplayHeader = true;

        public List<InstructionalButton> InstructionalButtons = new()
        {
            new InstructionalButton(Control.PhoneSelect, UIMenu._selectTextLocalized),
            new InstructionalButton(Control.PhoneCancel, UIMenu._backTextLocalized),
            new InstructionalButton(InputGroup.INPUTGROUP_FRONTEND_BUMPERS, _browseTextLocalized),
        };

        internal PauseMenuScaleform _pause;
        internal bool _loaded;
        internal readonly static string _browseTextLocalized = Game.GetGXTEntry("HUD_INPUT1C");

        public MainView(string title) : this(title, "", "", "", "")
        {
        }
        public MainView(string title, string subtitle) : this(title, subtitle, "", "", "")
        {
        }

        public MainView(string title, string subtitle, string sideTop, string sideMid, string sideBot)
        {
            Title = title;
            SubTitle = subtitle;
            SideStringTop = sideTop;
            SideStringMiddle = sideMid;
            SideStringBottom = sideBot;
            Index = 0;
            TemporarilyHidden = false;
            _pause = ScaleformUI.PauseMenu;
            LeftItems = new();
            CenterItems = new();
        }

        public override bool Visible
        {
            get { return _visible; }
            set
            {
                if (value)
                {
                    //API.ActivateFrontendMenu((uint)Game.GenerateHash("FE_MENU_VERSION_EMPTY"), false, -1);
                    BuildPauseMenu();
                    //SendPauseMenuOpen();
                    API.DontRenderInGameUi(true);
                    Screen.Effects.Start(ScreenEffect.FocusOut, 500);
                    API.TriggerScreenblurFadeIn(800);
                    ScaleformUI.InstructionalButtons.SetInstructionalButtons(InstructionalButtons);
                    API.SetPlayerControl(Game.Player.Handle, false, 0);
                }
                else
                {
                    _pause.Dispose();
                    API.DontRenderInGameUi(false);
                    Screen.Effects.Start(ScreenEffect.FocusOut, 500);
                    if (API.IsScreenblurFadeRunning()) API.DisableScreenblurFade();
                    API.TriggerScreenblurFadeOut(100);
                    //SendPauseMenuClose();
                    API.SetPlayerControl(Game.Player.Handle, true, 0);
                }
                Game.IsPaused = value;
                ScaleformUI.InstructionalButtons.Enabled = value;
                _pause.Visible = value;
                _visible = value;
            }
        }

        public int Index;
        private bool _visible;
        private int focusLevel;
        private int rightItemIndex;
        private int leftItemIndex;
        private int _timer;
        public async void ShowHeader()
        {
            if (String.IsNullOrEmpty(SubTitle) || String.IsNullOrWhiteSpace(SubTitle))
                _pause.SetHeaderTitle(Title);
            else
            {
                _pause.ShiftCoronaDescription(true, false);
                _pause.SetHeaderTitle(Title, SubTitle);
            }
            if (HeaderPicture != null)
                _pause.SetHeaderCharImg(HeaderPicture.Item2, HeaderPicture.Item2, true);
            if (CrewPicture != null)
                _pause.SetHeaderSecondaryImg(CrewPicture.Item1, CrewPicture.Item2, true);
            _pause.SetHeaderDetails(SideStringTop, SideStringMiddle, SideStringBottom);
            _pause.AddLobbyMenuTab("SETTINGS", 2, 0, HudColor.HUD_COLOUR_RED);
            _pause.AddLobbyMenuTab("PLAYERS", 2, 0, HudColor.HUD_COLOUR_ORANGE);
            _pause.AddLobbyMenuTab("INFOS", 2, 0, HudColor.HUD_COLOUR_GREEN);
            _pause._header.CallFunction("SET_ALL_HIGHLIGHTS", true, (int)HudColor.HUD_COLOUR_PAUSE_BG);

            _loaded = true;
        }

        public void AddSettingsItem(UIMenuItem item)
        {
            item.ParentLobby = this;
            LeftItems.Add(item);
        }

        public void AddPlayerItem(LobbyItem item)
        {
            item.ParentLobby = this;
            CenterItems.Add(item);
        }

        public async void BuildPauseMenu()
        {
            ShowHeader();

            foreach (var item in LeftItems)
            {
                var index = LeftItems.IndexOf(item);
                AddTextEntry($"menu_lobby_desc_{index}", item.Description);
                BeginScaleformMovieMethod(_pause._lobby.Handle, "ADD_LEFT_ITEM");
                PushScaleformMovieFunctionParameterInt(item._itemId);
                PushScaleformMovieMethodParameterString(item.Label);
                if (item.DescriptionHash != 0 && string.IsNullOrWhiteSpace(item.Description))
                {
                    BeginTextCommandScaleformString("STRTNM1");
                    AddTextComponentSubstringTextLabelHashKey(item.DescriptionHash);
                    EndTextCommandScaleformString_2();
                }
                else
                {
                    BeginTextCommandScaleformString($"menu_lobby_desc_{index}");
                    EndTextCommandScaleformString_2();
                }
                PushScaleformMovieFunctionParameterBool(item.Enabled);
                PushScaleformMovieFunctionParameterBool(item.BlinkDescription);
                switch (item)
                {
                    case UIMenuListItem:
                        UIMenuListItem it = (UIMenuListItem)item;
                        AddTextEntry($"listitem_lobby_{index}_list", string.Join(",", it.Items));
                        BeginTextCommandScaleformString($"listitem_lobby_{index}_list");
                        EndTextCommandScaleformString();
                        PushScaleformMovieFunctionParameterInt(it.Index);
                        PushScaleformMovieFunctionParameterInt((int)it.MainColor);
                        PushScaleformMovieFunctionParameterInt((int)it.HighlightColor);
                        PushScaleformMovieFunctionParameterInt((int)it.TextColor);
                        PushScaleformMovieFunctionParameterInt((int)it.HighlightedTextColor);
                        EndScaleformMovieMethod();
                        break;
                    case UIMenuCheckboxItem:
                        UIMenuCheckboxItem check = (UIMenuCheckboxItem)item;
                        PushScaleformMovieFunctionParameterInt((int)check.Style);
                        PushScaleformMovieMethodParameterBool(check.Checked);
                        PushScaleformMovieFunctionParameterInt((int)check.MainColor);
                        PushScaleformMovieFunctionParameterInt((int)check.HighlightColor);
                        PushScaleformMovieFunctionParameterInt((int)check.TextColor);
                        PushScaleformMovieFunctionParameterInt((int)check.HighlightedTextColor);
                        EndScaleformMovieMethod();
                        break;
                    case UIMenuSliderItem:
                        UIMenuSliderItem prItem = (UIMenuSliderItem)item;
                        PushScaleformMovieFunctionParameterInt(prItem._max);
                        PushScaleformMovieFunctionParameterInt(prItem._multiplier);
                        PushScaleformMovieFunctionParameterInt(prItem.Value);
                        PushScaleformMovieFunctionParameterInt((int)prItem.MainColor);
                        PushScaleformMovieFunctionParameterInt((int)prItem.HighlightColor);
                        PushScaleformMovieFunctionParameterInt((int)prItem.TextColor);
                        PushScaleformMovieFunctionParameterInt((int)prItem.HighlightedTextColor);
                        PushScaleformMovieFunctionParameterInt((int)prItem.SliderColor);
                        PushScaleformMovieFunctionParameterBool(prItem._heritage);
                        EndScaleformMovieMethod();
                        break;
                    case UIMenuProgressItem:
                        UIMenuProgressItem slItem = (UIMenuProgressItem)item;
                        PushScaleformMovieFunctionParameterInt(slItem._max);
                        PushScaleformMovieFunctionParameterInt(slItem._multiplier);
                        PushScaleformMovieFunctionParameterInt(slItem.Value);
                        PushScaleformMovieFunctionParameterInt((int)slItem.MainColor);
                        PushScaleformMovieFunctionParameterInt((int)slItem.HighlightColor);
                        PushScaleformMovieFunctionParameterInt((int)slItem.TextColor);
                        PushScaleformMovieFunctionParameterInt((int)slItem.HighlightedTextColor);
                        PushScaleformMovieFunctionParameterInt((int)slItem.SliderColor);
                        EndScaleformMovieMethod();
                        break;
                    default:
                        PushScaleformMovieFunctionParameterInt((int)item.MainColor);
                        PushScaleformMovieFunctionParameterInt((int)item.HighlightColor);
                        PushScaleformMovieFunctionParameterInt((int)item.TextColor);
                        PushScaleformMovieFunctionParameterInt((int)item.HighlightedTextColor);
                        EndScaleformMovieMethod();
                        break;
                }
            }

            foreach (var item in CenterItems)
            {
                var index = CenterItems.IndexOf(item);
                switch (item)
                {
                    case FriendItem:
                        var fi = (FriendItem)item;
                        Debug.WriteLine($"{fi.Label}, (int){fi.ItemColor}, {fi.ColoredTag}, {fi.iconL}, {fi.boolL}, {fi.iconR}, {fi.boolR}, {fi.Status}, (int){fi.StatusColor}, {fi.Rank}, {fi.CrewTag}");
                        _pause._lobby.CallFunction("ADD_PLAYER_ITEM", 1, 1, fi.Label, (int)fi.ItemColor, fi.ColoredTag, fi.iconL, fi.boolL, fi.iconR, fi.boolR, fi.Status, (int)fi.StatusColor, fi.Rank, fi.CrewTag);
                        break;
                }
            }
        }

        private bool controller = false;
        public override async void Draw()
        {
            if (!Visible || TemporarilyHidden) return;
            _pause.Draw(true);
            //UpdateKeymapItems();
        }

        /*
        private void UpdateKeymapItems()
        {
            if (!API.IsInputDisabled(2))
            {
                if (!controller)
                {
                    controller = true;
                    if (Tabs[Index] is TabSubmenuItem)
                    {
                        foreach (var lItem in (Tabs[Index] as TabSubmenuItem).LeftItemList)
                        {
                            var idx = (Tabs[Index] as TabSubmenuItem).LeftItemList.IndexOf(lItem);
                            if (lItem.ItemType == LeftItemType.Keymap)
                            {
                                for (int i = 0; i < lItem.ItemList.Count; i++)
                                {
                                    KeymapItem item = (KeymapItem)lItem.ItemList[i];
                                    _pause.UpdateKeymap(Index, idx, i, item.PrimaryGamepad, item.SecondaryGamepad);
                                }
                            }
                        }
                    }
                }
            }
            else
            {
                if (controller)
                {
                    controller = false;
                    foreach (var lItem in (Tabs[Index] as TabSubmenuItem).LeftItemList)
                    {
                        var idx = (Tabs[Index] as TabSubmenuItem).LeftItemList.IndexOf(lItem);
                        if (lItem.ItemType == LeftItemType.Keymap)
                        {
                            for (int i = 0; i < lItem.ItemList.Count; i++)
                            {
                                KeymapItem item = (KeymapItem)lItem.ItemList[i];
                                _pause.UpdateKeymap(Index, idx, i, item.PrimaryKeyboard, item.SecondaryKeyboard);
                            }
                        }
                    }
                }
            }
        }
        */

        private bool firstTick = true;
        public override async void ProcessControls()
        {
            /*
            if (firstTick)
            {
                firstTick = false;
                return;
                // without this shit the menu goes on focus without need if opened from another menu.
            }
            if (!Visible || TemporarilyHidden) return;
            string result = "";

            if (Game.IsControlJustPressed(2, Control.PhoneUp))
            {
                if (FocusLevel == 0) return;
                result = await _pause.SendInputEvent(8);
            }
            else if (Game.IsControlJustPressed(2, Control.PhoneDown))
            {
                if (FocusLevel == 0) return;
                result = await _pause.SendInputEvent(9);
            }

            else if (Game.IsControlJustPressed(2, Control.PhoneLeft))
            {
                if (FocusLevel == 1) return;
                if (FocusLevel == 0)
                    _pause.HeaderGoLeft();
                result = await _pause.SendInputEvent(10);
            }
            else if (Game.IsControlJustPressed(2, Control.PhoneRight))
            {
                if (FocusLevel == 1) return;
                if (FocusLevel == 0)
                    _pause.HeaderGoRight();
                result = await _pause.SendInputEvent(11);
            }

            else if (Game.IsControlJustPressed(2, Control.FrontendLb))
            {
                if (FocusLevel == 0)
                {
                    _pause.HeaderGoLeft();
                    result = await _pause.SendInputEvent(10);
                }
            }
            else if (Game.IsControlJustPressed(2, Control.FrontendRb))
            {
                if (FocusLevel == 0)
                {
                    _pause.HeaderGoRight();
                    result = await _pause.SendInputEvent(11);
                }
            }

            else if (Game.IsControlJustPressed(2, Control.FrontendAccept))
            {
                result = await _pause.SendInputEvent(16);
                switch (focusLevel)
                {

                    case 1:
                        if (Tabs[Index].LeftItemList[leftItemIndex].ItemType == LeftItemType.Info || Tabs[Index].LeftItemList[leftItemIndex].ItemType == LeftItemType.Empty)
                        {
                            Tabs[Index].LeftItemList[leftItemIndex].Activated();
                        }
                        break;
                    case 2:
                        if (Tabs[Index].LeftItemList[leftItemIndex].ItemList[rightItemIndex] is SettingsTabItem)
                        {
                            var it = Tabs[Index].LeftItemList[leftItemIndex].ItemList[rightItemIndex] as SettingsTabItem;
                            it.Activated();
                        }
                        break;
                }
            }

            else if (Game.IsControlJustPressed(2, Control.PhoneCancel))
            {
                if (FocusLevel > 0)
                    result = await _pause.SendInputEvent(17);
                else
                {
                    Visible = false;
                }
            }

            if (Game.IsControlJustPressed(1, Control.CursorScrollUp))
            {
                result = await _pause.SendScrollEvent(-1);
            }
            else if (Game.IsControlJustPressed(1, Control.CursorScrollDown))
            {
                result = await _pause.SendScrollEvent(1);
            }


            if (Game.IsControlPressed(2, Control.LookUpOnly))
            {
                if (Game.GameTime - _timer > 250)
                {
                    result = await _pause.SendScrollEvent(-1);
                    _timer = Game.GameTime;
                }
            }
            else if (Game.IsControlPressed(2, Control.LookDownOnly))
            {
                if (Game.GameTime - _timer > 250)
                {
                    result = await _pause.SendScrollEvent(1);
                    _timer = Game.GameTime;
                }
            }
            */
            /*
            if (Game.IsControlPressed(2, Control.PhoneLeft))
            {
                if (FocusLevel == 2)
                {
                    if (Game.GameTime - _timer > 250)
                    {
                        result = await _pause.SendInputEvent(10);
                        _timer = Game.GameTime;
                    }
                }
            }
            else if (Game.IsControlPressed(2, Control.PhoneRight))
            {
                if (FocusLevel == 2)
                {
                    if (Game.GameTime - _timer > 250)
                    {
                        result = await _pause.SendInputEvent(11);
                        _timer = Game.GameTime;
                    }
                }
            }
            */
            /*
            if (Game.IsControlJustPressed(0, Control.Attack) && API.IsInputDisabled(2))
            {
                if (Game.GameTime - _timer > 250)
                {
                    result = await _pause.SendClickEvent();
                    _timer = Game.GameTime;
                }
            }

            if (!string.IsNullOrWhiteSpace(result) && result.Contains(","))
            {
                var split = result.Split(',');
                var curTab = Convert.ToInt32(split[0]);
                var focusLevel = Convert.ToInt32(split[1]);
                int leftItemIndex = -1;
                int rightPanelIndex = -1;
                int retVal = -1;
                bool retBool = false;
                if (split.Length > 2)
                {
                    switch (split.Length)
                    {
                        case 3:
                            leftItemIndex = split[2] != "undefined" ? Convert.ToInt32(split[2]) : -1;
                            break;
                        case 5:
                            leftItemIndex = Convert.ToInt32(split[2]);
                            rightPanelIndex = Convert.ToInt32(split[3]);
                            if (split[4] == "true" || split[4] == "false")
                                retBool = Convert.ToBoolean(split[4]);
                            else
                                retVal = Convert.ToInt32(split[4]);
                            break;
                    }
                }

                Index = curTab;
                FocusLevel = focusLevel;

                if (focusLevel == 0)
                {
                    foreach (var t in Tabs)
                        t.Focused = Tabs.IndexOf(t) == Index;
                    SendPauseMenuTabChange();
                }

                if (focusLevel == 1)
                {
                    var tab = Tabs[Index];
                    if (tab is not TabTextItem)
                    {
                        (tab as TabSubmenuItem).Index = leftItemIndex;
                        LeftItemIndex = leftItemIndex;
                        foreach (var item in (tab as TabSubmenuItem).LeftItemList)
                        {
                            item.Highlighted = (tab as TabSubmenuItem).LeftItemList.IndexOf(item) == leftItemIndex;
                        }
                    }
                }

                if (focusLevel == 2)
                {
                    var leftItem = Tabs[Index].LeftItemList.SingleOrDefault(x => x.Highlighted);
                    if (leftItem.ItemType == LeftItemType.Settings)
                    {
                        leftItem.ItemIndex = rightPanelIndex;
                        RightItemIndex = leftItem.ItemIndex;
                        foreach (var it in leftItem.ItemList)
                        {
                            (it as SettingsTabItem).Highlighted = leftItem.ItemList.IndexOf(it) == rightPanelIndex;
                            if ((it as SettingsTabItem).Highlighted)
                            {
                                var rightItem = it as SettingsTabItem;
                                switch (rightItem.ItemType)
                                {
                                    case SettingsItemType.ListItem:
                                        rightItem.ItemIndex = retVal;
                                        break;
                                    case SettingsItemType.SliderBar:
                                    case SettingsItemType.ProgressBar:
                                    case SettingsItemType.MaskedProgressBar:
                                        rightItem.Value = retVal;
                                        break;
                                    case SettingsItemType.CheckBox:
                                        rightItem.IsChecked = retBool;
                                        break;
                                }
                            }
                        }
                    }
                }

                // DEBUG
                //Debug.WriteLine("Scaleform [tabIndex, focusLevel, currentTabLeftItemIndex, currentRightPanelItemIndex, retVal] = " + result);
                //Debug.WriteLine($"C# [tabIndex, focusLevel, currentTabLeftItemIndex, currentRightPanelItemIndex, retVal] = {Index},{FocusLevel},{leftItemIndex},{RightItemIndex}");
            }
            */
        }
    }
}

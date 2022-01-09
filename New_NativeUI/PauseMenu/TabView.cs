using System;
using System.Collections.Generic;
using System.Drawing;
using System.Linq;
using CitizenFX.Core;
using CitizenFX.Core.Native;
using CitizenFX.Core.UI;
using Font = CitizenFX.Core.UI.Font;

namespace ScaleformUI.PauseMenu
{
    public delegate void PauseMenuOpenEvent(TabView menu);
    public delegate void PauseMenuCloseEvent(TabView menu);
    public delegate void PauseMenuTabChanged(TabView menu, BaseTab tab, int tabIndex);
    public delegate void PauseMenuFocusChanged(TabView menu, BaseTab tab, int focusLevel);
    public delegate void LeftItemSelect(TabView menu, int tabIndex, int focusLevel, int leftItem);
    public delegate void RightItemSelect(TabView menu, int tabIndex, int focusLevel, int leftItem, int rightItem);

    public class TabView
    {
        /*
        API.ShowCursorThisFrame();
        */
        public string Title { get; set; }
        public string SubTitle { get; set; }
        public string SideStringTop { get; set; }
        public string SideStringMiddle { get; set; }
        public string SideStringBottom { get; set; }
        public Tuple<string, string> HeaderPicture { internal get; set; }
        public List<BaseTab> Tabs { get; set; }
        public int LeftItemIndex
        {
            get => leftItemIndex;
            set
            {
                leftItemIndex = value;
                SendPauseMenuLeftItemChange();
            }
        }
        public int RightItemIndex
        {
            get => rightItemIndex;
            set
            {
                rightItemIndex = value;
                SendPauseMenuRightItemChange();
            }
        }
        public int FocusLevel
        {
            get => focusLevel;
            set
            {
                focusLevel = value;
                SendPauseMenuFocusChange();
            }
        }
        public bool TemporarilyHidden { get; set; }
        public bool HideTabs { get; set; }
        public bool DisplayHeader = true;

        public List<InstructionalButton> buttons = new()
        {
            new InstructionalButton(Control.PhoneSelect, UIMenu._selectTextLocalized),
            new InstructionalButton(Control.PhoneCancel, UIMenu._backTextLocalized),
            new InstructionalButton(InputGroup.INPUTGROUP_FRONTEND_BUMPERS, _browseTextLocalized),
        };


        internal PauseMenuScaleform _pause;
        internal bool _loaded;
        internal readonly static string _browseTextLocalized = Game.GetGXTEntry("HUD_INPUT1C");

        public event PauseMenuOpenEvent OnPauseMenuOpen;
        public event PauseMenuCloseEvent OnPauseMenuClose;
        public event PauseMenuTabChanged OnPauseMenuTabChanged;
        public event PauseMenuFocusChanged OnPauseMenuFocusChanged;
        public event LeftItemSelect OnLeftItemChange;
        public event RightItemSelect OnRightItemChange;

        public TabView(string title) : this(title, "", "", "", "")
        {
        }
        public TabView(string title, string subtitle) : this(title, subtitle, "", "", "")
        {
        }

        public TabView(string title, string subtitle, string sideTop, string sideMid, string sideBot)
        {
            Title = title;
            SubTitle = subtitle;
            SideStringTop = sideTop;
            SideStringMiddle = sideMid;
            SideStringBottom = sideBot;
            Tabs = new List<BaseTab>();
            Index = 0;
            FocusLevel = 0;
            TemporarilyHidden = false;
            _pause = ScaleformUI.PauseMenu;
        }

        public bool Visible
        {
            get { return _visible; }
            set
            {
                if (value)
                {
                    BuildPauseMenu();
                    SendPauseMenuOpen();
                    Screen.Effects.Start(ScreenEffect.FocusOut, 800);
                    API.TransitionToBlurred(700);

                    ScaleformUI.InstructionalButtons.SetInstructionalButtons(buttons);
                    API.SetPlayerControl(Game.Player.Handle, false, 0);
                }
                else
                {
                    _pause.Dispose();
                    Screen.Effects.Start(ScreenEffect.FocusOut, 500);
                    API.TransitionFromBlurred(400);
                    SendPauseMenuClose();
                    API.SetPlayerControl(Game.Player.Handle, true, 0);
                }
                Game.IsPaused = value;
                ScaleformUI.InstructionalButtons.Enabled = value;
                _pause.Visible = value;
                _visible = value;
            }
        }
        public void AddTab(BaseTab item)
        {
            Tabs.Add(item);
            item.Parent = this;
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
/*
            else
            {
                var mugshot = await Notifications.GetPedMugshotAsync(Game.PlayerPed);
                _pause.SetHeaderCharImg(mugshot.Item2, mugshot.Item2, true);
                API.ReleasePedheadshotImgUpload(mugshot.Item1);
            }
*/
            _pause.SetHeaderDetails(SideStringTop, SideStringMiddle, SideStringBottom);
            _loaded = true;
        }

        public async void BuildPauseMenu()
        {
            ShowHeader();
            foreach (var tab in Tabs)
            {
                int tabIndex = Tabs.IndexOf(tab);
                switch (tab)
                {
                    case TabTextItem:
                        {
                            TabTextItem simpleTab = tab as TabTextItem;
                            _pause.AddPauseMenuTab(tab.Title, 0);
                            if (!string.IsNullOrWhiteSpace(simpleTab.TextTitle))
                                _pause.AddRightTitle(tabIndex, 0, simpleTab.TextTitle);
                            foreach (var it in simpleTab.LabelsList)
                                _pause.AddRightListLabel(tabIndex, 0, it.Label);
                        }
                        break;
                    case TabSubmenuItem:
                        {
                            _pause.AddPauseMenuTab(tab.Title, 1);
                            foreach (var item in tab.LeftItemList)
                            {
                                int itemIndex = tab.LeftItemList.IndexOf(item);
                                _pause.AddLeftItem(tabIndex, (int)item.ItemType, item.Label, item.MainColor, item.HighlightColor);

                                if (!string.IsNullOrWhiteSpace(item.TextTitle))
                                    _pause.AddRightTitle(tabIndex, itemIndex, item.TextTitle);

                                foreach (var ii in item.ItemList)
                                {
                                    switch (ii)
                                    {
                                        default:
                                            {
                                                _pause.AddRightListLabel(tabIndex, itemIndex, ii.Label);
                                            }
                                            break;
                                        case StatsTabItem:
                                            {
                                                var sti = ii as StatsTabItem;
                                                if (sti.Type == StatItemType.Basic)
                                                    _pause.AddRightStatItemLabel(tabIndex, itemIndex, sti.Label, sti.RightLabel);
                                                else if (sti.Type == StatItemType.ColoredBar)
                                                    _pause.AddRightStatItemColorBar(tabIndex, itemIndex, sti.Label, sti.Value, sti.ColoredBarColor);
                                            }
                                            break;
                                        case SettingsTabItem:
                                            {
                                                var sti = ii as SettingsTabItem;
                                                switch (sti.ItemType)
                                                {
                                                    case SettingsItemType.Basic:
                                                        _pause.AddRightSettingsBaseItem(tabIndex, itemIndex, sti.Label, sti.RightLabel);
                                                        break;
                                                    case SettingsItemType.ListItem:
                                                        _pause.AddRightSettingsListItem(tabIndex, itemIndex, sti.Label, sti.ListItems, sti.ItemIndex);
                                                        break;
                                                    case SettingsItemType.ProgressBar:
                                                        _pause.AddRightSettingsProgressItem(tabIndex, itemIndex, sti.Label, sti.MaxValue, sti.ColoredBarColor, sti.Value);
                                                        break;
                                                    case SettingsItemType.MaskedProgressBar:
                                                        _pause.AddRightSettingsProgressItemAlt(tabIndex, itemIndex, sti.Label, sti.MaxValue, sti.ColoredBarColor, sti.Value);
                                                        break;
                                                    case SettingsItemType.CheckBox:
                                                        while (!API.HasStreamedTextureDictLoaded("commonmenu"))
                                                        {
                                                            await BaseScript.Delay(0);
                                                            API.RequestStreamedTextureDict("commonmenu", true);
                                                        }
                                                        _pause.AddRightSettingsCheckboxItem(tabIndex, itemIndex, sti.Label, sti.CheckBoxStyle, sti.IsChecked);
                                                        break;
                                                    case SettingsItemType.SliderBar:
                                                        _pause.AddRightSettingsSliderItem(tabIndex, itemIndex, sti.Label, sti.MaxValue, sti.ColoredBarColor, sti.Value);
                                                        break;
                                                }
                                            }
                                            break;
                                    }
                                }
                            }
                        }
                        break;
                }
            }
        }

        public async void Draw()
        {
            if (!Visible || TemporarilyHidden) return;
            _pause.Draw();
        }

        private bool firstTick = true;
        public async void ProcessControls()
        {
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
                        if(Tabs[Index].LeftItemList[leftItemIndex].ItemType == LeftItemType.Info || Tabs[Index].LeftItemList[leftItemIndex].ItemType == LeftItemType.Empty)
                        {
                            Tabs[Index].LeftItemList[leftItemIndex].Activated();
                        }
                        break;
                    case 2:
                        if (Tabs[Index].LeftItemList[leftItemIndex].ItemList[rightItemIndex] is SettingsTabItem)
                        {
                            var it = Tabs[Index].LeftItemList[leftItemIndex].ItemList[rightItemIndex] as SettingsTabItem;
                            it.Activate();
                        }
                        break;
                }
            }

            else if (Game.IsControlJustPressed(2, Control.PhoneCancel))
            {
                if (FocusLevel > 0)
                    result = await _pause.SendInputEvent(17);
                else Visible = false;
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
        }

        internal void SendPauseMenuOpen()
        {
            OnPauseMenuOpen?.Invoke(this);
        }

        internal void SendPauseMenuClose()
        {
            OnPauseMenuClose?.Invoke(this);
        }

        internal void SendPauseMenuTabChange()
        {
            OnPauseMenuTabChanged?.Invoke(this, Tabs[Index], Index);
        }

        internal void SendPauseMenuFocusChange()
        {
            OnPauseMenuFocusChanged?.Invoke(this, Tabs[Index], FocusLevel);
        }

        internal void SendPauseMenuLeftItemChange()
        {
            OnLeftItemChange?.Invoke(this, Index, FocusLevel, LeftItemIndex);
        }

        internal void SendPauseMenuRightItemChange()
        {
            OnRightItemChange?.Invoke(this, Index, FocusLevel, LeftItemIndex, RightItemIndex);
        }
    }
}
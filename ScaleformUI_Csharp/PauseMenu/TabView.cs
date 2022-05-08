using System;
using System.Collections.Generic;
using System.Drawing;
using System.Linq;
using CitizenFX.Core;
using CitizenFX.Core.Native;
using static CitizenFX.Core.Native.API;
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

    public class TabView : PauseMenuBase
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
        public Tuple<string, string> CrewPicture { internal get; set; }
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
                if(_pause is not null)
                    _pause.SetFocus(value);
                SendPauseMenuFocusChange();
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

        public event PauseMenuOpenEvent OnPauseMenuOpen;
        public event PauseMenuCloseEvent OnPauseMenuClose;
        public event PauseMenuTabChanged OnPauseMenuTabChanged;
        public event PauseMenuFocusChanged OnPauseMenuFocusChanged;
        public event LeftItemSelect OnLeftItemChange;
        public event LeftItemSelect OnLeftItemSelect;
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

        public override bool Visible
        {
            get { return _visible; }
            set
            {
                if (value)
                {
                    BuildPauseMenu();
                    SendPauseMenuOpen();
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
            if (CrewPicture != null)
                _pause.SetHeaderSecondaryImg(CrewPicture.Item1, CrewPicture.Item2, true);
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
                            _pause.AddPauseMenuTab(tab.Title, tab._type, 0);
                            if (!string.IsNullOrWhiteSpace(simpleTab.TextTitle))
                                _pause.AddRightTitle(tabIndex, 0, simpleTab.TextTitle);
                            foreach (var it in simpleTab.LabelsList)
                                _pause.AddRightListLabel(tabIndex, 0, it.Label);
                        }
                        break;
                    case TabSubmenuItem:
                        {
                            _pause.AddPauseMenuTab(tab.Title, tab._type, 1);
                            foreach (var item in tab.LeftItemList)
                            {
                                int itemIndex = tab.LeftItemList.IndexOf(item);
                                _pause.AddLeftItem(tabIndex, (int)item.ItemType, item.Label, item.MainColor, item.HighlightColor);

                                if (!string.IsNullOrWhiteSpace(item.TextTitle))
                                {
                                    if (item.ItemType == LeftItemType.Keymap)
                                        _pause.AddKeymapTitle(tabIndex, itemIndex, item.TextTitle, item.KeymapRightLabel_1, item.KeymapRightLabel_2);
                                    else
                                        _pause.AddRightTitle(tabIndex, itemIndex, item.TextTitle);
                                }


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
                                                switch (sti.Type)
                                                {
                                                    case StatItemType.Basic:
                                                        _pause.AddRightStatItemLabel(tabIndex, itemIndex, sti.Label, sti.RightLabel);
                                                        break;
                                                    case StatItemType.ColoredBar:
                                                        _pause.AddRightStatItemColorBar(tabIndex, itemIndex, sti.Label, sti.Value, sti.ColoredBarColor);
                                                        break;
                                                }
                                            }
                                            break;
                                        case SettingsItem:
                                            {
                                                var sti = ii as SettingsItem;
                                                switch (sti.ItemType)
                                                {
                                                    case SettingsItemType.Basic:
                                                        _pause.AddRightSettingsBaseItem(tabIndex, itemIndex, sti.Label, sti.RightLabel);
                                                        break;
                                                    case SettingsItemType.ListItem:
                                                        var lis = (SettingsListItem)sti;
                                                        _pause.AddRightSettingsListItem(tabIndex, itemIndex, lis.Label, lis.ListItems, lis.ItemIndex);
                                                        break;
                                                    case SettingsItemType.ProgressBar:
                                                        var prog = (SettingsProgressItem)sti;
                                                        _pause.AddRightSettingsProgressItem(tabIndex, itemIndex, prog.Label, prog.MaxValue, prog.ColoredBarColor, prog.Value);
                                                        break;
                                                    case SettingsItemType.MaskedProgressBar:
                                                        var prog_alt = (SettingsProgressItem)sti;
                                                        _pause.AddRightSettingsProgressItemAlt(tabIndex, itemIndex, sti.Label, prog_alt.MaxValue, prog_alt.ColoredBarColor, prog_alt.Value);
                                                        break;
                                                    case SettingsItemType.CheckBox:
                                                        while (!API.HasStreamedTextureDictLoaded("commonmenu"))
                                                        {
                                                            await BaseScript.Delay(0);
                                                            API.RequestStreamedTextureDict("commonmenu", true);
                                                        }
                                                        var check = (SettingsCheckboxItem)sti;
                                                        _pause.AddRightSettingsCheckboxItem(tabIndex, itemIndex, check.Label, check.CheckBoxStyle, check.IsChecked);
                                                        break;
                                                    case SettingsItemType.SliderBar:
                                                        var slid = (SettingsSliderItem)sti;
                                                        _pause.AddRightSettingsSliderItem(tabIndex, itemIndex, slid.Label, slid.MaxValue, slid.ColoredBarColor, slid.Value);
                                                        break;
                                                }
                                            }
                                            break;
                                        case KeymapItem:
                                            var ki = ii as KeymapItem;
                                            if (API.IsInputDisabled(2))
                                                _pause.AddKeymapItem(tabIndex, itemIndex, ki.Label, ki.PrimaryKeyboard, ki.SecondaryKeyboard);
                                            else
                                                _pause.AddKeymapItem(tabIndex, itemIndex, ki.Label, ki.PrimaryGamepad, ki.SecondaryGamepad);
                                            UpdateKeymapItems();
                                            break;
                                    }
                                }
                            }
                        }
                        break;
                }
            }
        }

        private bool controller = false;
        public override async void Draw()
        {
            base.Draw();
            if (!Visible || TemporarilyHidden) return;
            _pause.Draw();
            UpdateKeymapItems();
        }

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

        private bool firstTick = true;
        private int eventType = 0;
        private int itemId = 0;
        private int context = 0;
        private int unused = 0;

        public override void ProcessMouse()
        {
            if (!IsUsingKeyboard(2))
            {
                return;
            }
            // check for is using keyboard (2) to use Mouse or not.
            SetMouseCursorActiveThisFrame();
            SetInputExclusive(2, 239);
            SetInputExclusive(2, 240);
            SetInputExclusive(2, 237);
            SetInputExclusive(2, 238);

            var successHeader = GetScaleformMovieCursorSelection(ScaleformUI.PauseMenu._header.Handle, ref eventType, ref context, ref itemId, ref unused);
            if (successHeader)
            {
                switch (eventType)
                {
                    case 5: // on click pressed
                        switch (context)
                        {
                            case -1:
                                _pause.SelectTab(itemId);
                                FocusLevel = 1;
                                Index = itemId;
                                break;
                                /* TODO: CHANGE IT WITH SPRITE LIKE THE ACTUAL PAUSE MENU
                            case 1:
                                switch (itemId)
                                {
                                    case 0:
                                        _pause.HeaderGoLeft();
                                        break;
                                    case 1:
                                        _pause.HeaderGoRight();
                                        break;
                                }
                                break;
                                */
                        }
                        break;
                }
            }

            var successPause = GetScaleformMovieCursorSelection(ScaleformUI.PauseMenu._pause.Handle, ref eventType, ref context, ref itemId, ref unused);
            if (successPause)
            {
                switch (eventType)
                {
                    case 5: // on click pressed
                        switch (context)
                        {
                            case 0: // going from unfocused to focused
                                FocusLevel = 1;
                                break;
                            case 1: // left item in subitem tab pressed
                                if (focusLevel != 1)
                                {
                                    Tabs[Index].LeftItemList[LeftItemIndex].Selected = false;
                                    LeftItemIndex = itemId;
                                    Tabs[Index].LeftItemList[LeftItemIndex].Selected = true;
                                    FocusLevel = 1;
                                }
                                else if(focusLevel == 1)
                                {
                                    if (Tabs[Index].LeftItemList[LeftItemIndex].ItemType == LeftItemType.Settings)
                                    {
                                        FocusLevel = 2;
                                        _pause._pause.CallFunction("SELECT_RIGHT_ITEM_INDEX", 0);
                                        RightItemIndex = 0;
                                    }
                                    Tabs[Index].LeftItemList[LeftItemIndex].Selected = false;
                                    LeftItemIndex = itemId;
                                    Tabs[Index].LeftItemList[LeftItemIndex].Selected = true;
                                }
                                _pause._pause.CallFunction("SELECT_LEFT_ITEM_INDEX", itemId);
                                Tabs[Index].LeftItemList[LeftItemIndex].Activated();
                                SendPauseMenuLeftItemSelect();
                                break;
                            case 2:// right settings item in subitem tab pressed
                                if(FocusLevel != 2)
                                    FocusLevel = 2;
                                _pause._pause.CallFunction("SELECT_RIGHT_ITEM_INDEX", itemId);
                                if (Tabs[Index].LeftItemList[leftItemIndex].ItemList[itemId] is SettingsItem)
                                {
                                    //(Tabs[Index].LeftItemList[leftItemIndex].ItemList[RightItemIndex] as SettingsTabItem).Activated();
                                    if ((Tabs[Index].LeftItemList[leftItemIndex].ItemList[RightItemIndex] as SettingsItem).Selected)
                                    {
                                        (Tabs[Index].LeftItemList[leftItemIndex].ItemList[RightItemIndex] as SettingsItem).Activated();
                                        return;
                                    }

                                    (Tabs[Index].LeftItemList[leftItemIndex].ItemList[RightItemIndex] as SettingsItem).Selected = false;
                                    RightItemIndex = itemId;
                                    (Tabs[Index].LeftItemList[leftItemIndex].ItemList[RightItemIndex] as SettingsItem).Selected = true;
                                }

                                /*
                                 * aggiungere i vari check e poi gesire item copme nei menu
                                 */
                                break;
                        }
                        break;
                    case 6: // on click released
                        break;
                    case 7: // on click released ouside
                        break;
                    case 8: // on not hover
                        switch (context)
                        {
                            case 1: // left item in subitem tab pressed
                                Tabs[Index].LeftItemList[itemId].Hovered = false;
                                break;
                            case 2:// right settings item in subitem tab pressed
                                var curIt = Tabs[Index].LeftItemList[LeftItemIndex].ItemList[itemId];
                                if (curIt is SettingsItem)
                                {
                                    (curIt as SettingsItem).Hovered = false;
                                    Debug.WriteLine(itemId+", "+(curIt as SettingsItem).Hovered.ToString());
                                }
                                break;
                        }
                        break;
                    case 9: // on hovered
                        switch (context)
                        {
                            case 1: // left item in subitem tab pressed
                                Tabs[Index].LeftItemList[itemId].Hovered = true;
                                break;
                            case 2:// right settings item in subitem tab pressed
                                foreach (var curIt in Tabs[Index].LeftItemList[LeftItemIndex].ItemList)
                                {
                                    var idx = Tabs[Index].LeftItemList[LeftItemIndex].ItemList.IndexOf(curIt);
                                    if (curIt is SettingsItem)
                                    {
                                        (curIt as SettingsItem).Hovered = itemId == idx;
                                    }
                                }
                                break;
                        }
                        break;
                    case 0: // dragged outside
                        break;
                    case 1: // dragged inside
                        break;
                }
            }
            Notifications.DrawText(0.3f, 0.7f, "eventType:" + eventType);
            Notifications.DrawText(0.3f, 0.725f, "context:" + context);
            Notifications.DrawText(0.3f, 0.75f, "itemId:" + itemId);
            if(focusLevel == 2)
                Notifications.DrawText(0.3f, 0.775f, "item0 hovered:" + (Tabs[Index].LeftItemList[LeftItemIndex].ItemList[1] as SettingsItem).Hovered);
        }

        public override async void ProcessControls()
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
                        if (Tabs[Index].LeftItemList[leftItemIndex].ItemType == LeftItemType.Info || Tabs[Index].LeftItemList[leftItemIndex].ItemType == LeftItemType.Empty)
                        {
                            Tabs[Index].LeftItemList[leftItemIndex].Activated();
                        }
                        break;
                    case 2:
                        if (Tabs[Index].LeftItemList[leftItemIndex].ItemList[rightItemIndex] is SettingsItem)
                        {
                            var it = Tabs[Index].LeftItemList[leftItemIndex].ItemList[rightItemIndex] as SettingsItem;
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
            */

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
                            item.Selected = (tab as TabSubmenuItem).LeftItemList.IndexOf(item) == leftItemIndex;
                        }
                    }
                }

                if (focusLevel == 2)
                {
                    var leftItem = Tabs[Index].LeftItemList.SingleOrDefault(x => x.Enabled);
                    if (leftItem.ItemType == LeftItemType.Settings)
                    {
                        leftItem.ItemIndex = rightPanelIndex;
                        RightItemIndex = leftItem.ItemIndex;
                        foreach (var it in leftItem.ItemList)
                        {
                            (it as SettingsItem).Selected = leftItem.ItemList.IndexOf(it) == rightPanelIndex;
                            if ((it as SettingsItem).Selected)
                            {
                                var rightItem = it as SettingsItem;
                                switch (rightItem.ItemType)
                                {
                                    case SettingsItemType.ListItem:
                                        (rightItem as SettingsListItem).ItemIndex = retVal;
                                        break;
                                    case SettingsItemType.SliderBar:
                                        (rightItem as SettingsSliderItem).Value = retVal;
                                        break;
                                    case SettingsItemType.ProgressBar:
                                    case SettingsItemType.MaskedProgressBar:
                                        (rightItem as SettingsProgressItem).Value = retVal;
                                        break;
                                    case SettingsItemType.CheckBox:
                                        (rightItem as SettingsCheckboxItem).IsChecked = retBool;
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

        internal void SendPauseMenuLeftItemSelect()
        {
            OnLeftItemSelect?.Invoke(this, Index, FocusLevel, LeftItemIndex);
        }

        internal void SendPauseMenuRightItemChange()
        {
            OnRightItemChange?.Invoke(this, Index, FocusLevel, LeftItemIndex, RightItemIndex);
        }
    }
}
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
    public delegate void LeftItemSelect(TabView menu, TabLeftItem item, int leftItemIndex);
    public delegate void RightItemSelect(TabView menu, SettingsItem item, int leftItemIndex, int rightItemIndex);

    public class TabView : PauseMenuBase
    {
        /*
        ShowCursorThisFrame();
        */
        public string AUDIO_LIBRARY = "HUD_FRONTEND_DEFAULT_SOUNDSET";

        public string AUDIO_UPDOWN = "NAV_UP_DOWN";
        public string AUDIO_LEFTRIGHT = "NAV_LEFT_RIGHT";
        public string AUDIO_SELECT = "SELECT";
        public string AUDIO_BACK = "BACK";
        public string AUDIO_ERROR = "ERROR";

        public string Title { get; set; }
        public string SubTitle { get; set; }
        public string SideStringTop { get; set; }
        public string SideStringMiddle { get; set; }
        public string SideStringBottom { get; set; }
        public Tuple<string, string> HeaderPicture { internal get; set; }
        public Tuple<string, string> CrewPicture { internal get; set; }
        public List<BaseTab> Tabs { get; set; }
        public int Index;
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
        public event RightItemSelect OnRightItemSelect;

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
                    SendPauseMenuOpen();
                    DontRenderInGameUi(true);
                    AnimpostfxPlay("PauseMenuIn", 800, true);
                    ScaleformUI.InstructionalButtons.SetInstructionalButtons(InstructionalButtons);
                    SetPlayerControl(Game.Player.Handle, false, 0);
                    BuildPauseMenu();
                }
                else
                {
                    _pause.Dispose();
                    DontRenderInGameUi(false);
                    AnimpostfxStop("PauseMenuIn");
                    AnimpostfxPlay("PauseMenuOut", 800, false);
                    SendPauseMenuClose();
                    SetPlayerControl(Game.Player.Handle, true, 0);
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
                    case TextTab:
                        {
                            TextTab simpleTab = tab as TextTab;
                            _pause.AddPauseMenuTab(tab.Title, tab._type, 0);
                            if (!string.IsNullOrWhiteSpace(simpleTab.TextTitle))
                                _pause.AddRightTitle(tabIndex, 0, simpleTab.TextTitle);
                            foreach (var it in simpleTab.LabelsList)
                                _pause.AddRightListLabel(tabIndex, 0, it.Label);
                        }
                        break;
                    case SubmenuTab:
                        {
                            _pause.AddPauseMenuTab(tab.Title, tab._type, 1);
                            foreach (var item in tab.LeftItemList)
                            {
                                int itemIndex = tab.LeftItemList.IndexOf(item);
                                _pause.AddLeftItem(tabIndex, (int)item.ItemType, item.Label, item.MainColor, item.HighlightColor, item.Enabled);
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
                                                        _pause.AddRightSettingsBaseItem(tabIndex, itemIndex, sti.Label, sti.RightLabel, sti.Enabled);
                                                        break;
                                                    case SettingsItemType.ListItem:
                                                        var lis = (SettingsListItem)sti;
                                                        _pause.AddRightSettingsListItem(tabIndex, itemIndex, lis.Label, lis.ListItems, lis.ItemIndex, lis.Enabled);
                                                        break;
                                                    case SettingsItemType.ProgressBar:
                                                        var prog = (SettingsProgressItem)sti;
                                                        _pause.AddRightSettingsProgressItem(tabIndex, itemIndex, prog.Label, prog.MaxValue, prog.ColoredBarColor, prog.Value, prog.Enabled);
                                                        break;
                                                    case SettingsItemType.MaskedProgressBar:
                                                        var prog_alt = (SettingsProgressItem)sti;
                                                        _pause.AddRightSettingsProgressItemAlt(tabIndex, itemIndex, sti.Label, prog_alt.MaxValue, prog_alt.ColoredBarColor, prog_alt.Value, prog_alt.Enabled);
                                                        break;
                                                    case SettingsItemType.CheckBox:
                                                        while (!HasStreamedTextureDictLoaded("commonmenu"))
                                                        {
                                                            await BaseScript.Delay(0);
                                                            RequestStreamedTextureDict("commonmenu", true);
                                                        }
                                                        var check = (SettingsCheckboxItem)sti;
                                                        _pause.AddRightSettingsCheckboxItem(tabIndex, itemIndex, check.Label, check.CheckBoxStyle, check.IsChecked, check.Enabled);
                                                        break;
                                                    case SettingsItemType.SliderBar:
                                                        var slid = (SettingsSliderItem)sti;
                                                        _pause.AddRightSettingsSliderItem(tabIndex, itemIndex, slid.Label, slid.MaxValue, slid.ColoredBarColor, slid.Value, slid.Enabled);
                                                        break;
                                                }
                                            }
                                            break;
                                        case KeymapItem:
                                            var ki = ii as KeymapItem;
                                            if (IsInputDisabled(2))
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
            if (!Visible || TemporarilyHidden) return;
            base.Draw();
            _pause.Draw();
            UpdateKeymapItems();
        }

        private void UpdateKeymapItems()
        {
            if (!IsInputDisabled(2))
            {
                if (!controller)
                {
                    controller = true;
                    if (Tabs[Index] is SubmenuTab)
                    {
                        foreach (var lItem in (Tabs[Index] as SubmenuTab).LeftItemList)
                        {
                            var idx = (Tabs[Index] as SubmenuTab).LeftItemList.IndexOf(lItem);
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
                    foreach (var lItem in (Tabs[Index] as SubmenuTab).LeftItemList)
                    {
                        var idx = (Tabs[Index] as SubmenuTab).LeftItemList.IndexOf(lItem);
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

        public async void Select(bool playSound)
        {
            switch (FocusLevel)
            {
                case 0:
                    FocusLevel++;
                    if (Tabs[Index].LeftItemList.All(x => !x.Enabled)) break;
                    while (!Tabs[Index].LeftItemList[leftItemIndex].Enabled)
                    {
                        await BaseScript.Delay(0);
                        leftItemIndex++;
                        _pause._pause.CallFunction("SELECT_LEFT_ITEM_INDEX", leftItemIndex);
                    }
                    break;
                case 1:
                    {
                        if (Tabs[Index] is SubmenuTab)
                        {
                            var leftItem = Tabs[Index].LeftItemList[LeftItemIndex];
                            if (!leftItem.Enabled)
                            {
                                Game.PlaySound(AUDIO_ERROR, AUDIO_LIBRARY);
                                return;
                            }
                            if (leftItem.ItemType == LeftItemType.Settings)
                            {
                                FocusLevel = 2;
                                if (leftItem.ItemList.All(x => !(x as SettingsItem).Enabled)) break;
                                while(!(leftItem.ItemList[rightItemIndex] as SettingsItem).Enabled)
                                {
                                    await BaseScript.Delay(0);
                                    rightItemIndex++;
                                    _pause._pause.CallFunction("SELECT_RIGHT_ITEM_INDEX", rightItemIndex);
                                }
                            }
                            SendPauseMenuLeftItemSelect();
                        }
                    }
                    break;
                case 2:
                    {
                        _pause._pause.CallFunction("SET_INPUT_EVENT", 16);
                        var leftItem = Tabs[Index].LeftItemList[LeftItemIndex];
                        if (leftItem.ItemType == LeftItemType.Settings)
                        {
                            if (leftItem.ItemList[RightItemIndex] is SettingsItem rightItem)
                            {
                                if (!rightItem.Enabled)
                                {
                                    Game.PlaySound(AUDIO_ERROR, AUDIO_LIBRARY);
                                    return;
                                }

                                switch (rightItem.ItemType)
                                {
                                    case SettingsItemType.ListItem:
                                        (rightItem as SettingsListItem).ListSelected();
                                        break;
                                    case SettingsItemType.CheckBox:
                                        (rightItem as SettingsCheckboxItem).IsChecked = !(rightItem as SettingsCheckboxItem).IsChecked!;
                                        break;
                                    case SettingsItemType.MaskedProgressBar:
                                    case SettingsItemType.ProgressBar:
                                        (rightItem as SettingsProgressItem).ProgressSelected();
                                        break;
                                    case SettingsItemType.SliderBar:
                                        (rightItem as SettingsSliderItem).SliderSelected();
                                        break;
                                    default:
                                        rightItem.Activated();
                                        break;
                                }
                                SendPauseMenuRightItemSelect();
                            }
                        }
                    }
                    break;
            }
            if (playSound) Game.PlaySound(AUDIO_SELECT, AUDIO_LIBRARY);
        }
        public void GoBack()
        {
            Game.PlaySound(AUDIO_BACK, AUDIO_LIBRARY);
            if (FocusLevel > 0)
            {
                FocusLevel--;
            }
            else
            {
                if(CanPlayerCloseMenu) Visible = false;
            }
        }

        public async void GoUp()
        {
            BeginScaleformMovieMethod(_pause._pause.Handle, "SET_INPUT_EVENT");
            ScaleformMovieMethodAddParamInt(8);
            var ret = EndScaleformMovieMethodReturnValue();
            while (!IsScaleformMovieMethodReturnValueReady(ret)) await BaseScript.Delay(0);
            var retVal = GetScaleformMovieFunctionReturnInt(ret);
            if(retVal != -1)
            {
                if(FocusLevel == 1)
                {
                    LeftItemIndex = retVal;
                }
                else if (FocusLevel == 2)
                {
                    RightItemIndex = retVal;
                }
            }
        }

        public async void GoDown()
        {
            BeginScaleformMovieMethod(_pause._pause.Handle, "SET_INPUT_EVENT");
            ScaleformMovieMethodAddParamInt(9);
            var ret = EndScaleformMovieMethodReturnValue();
            while (!IsScaleformMovieMethodReturnValueReady(ret)) await BaseScript.Delay(0);
            var retVal = GetScaleformMovieFunctionReturnInt(ret);
            if (retVal != -1)
            {
                if (FocusLevel == 1)
                {
                    LeftItemIndex = retVal;
                }
                else if (FocusLevel == 2)
                {
                    RightItemIndex = retVal;
                }
            }
        }

        public async void GoLeft()
        {
            BeginScaleformMovieMethod(_pause._pause.Handle, "SET_INPUT_EVENT");
            ScaleformMovieMethodAddParamInt(10);
            var ret = EndScaleformMovieMethodReturnValue();
            while (!IsScaleformMovieMethodReturnValueReady(ret)) await BaseScript.Delay(0);
            var retVal = GetScaleformMovieFunctionReturnInt(ret);
            if (retVal != -1)
            {
                if (FocusLevel == 0)
                {
                    _pause.HeaderGoLeft();
                    Index = retVal;
                }
                else if (FocusLevel == 2)
                {
                    var rightItem = Tabs[Index].LeftItemList[LeftItemIndex].ItemList[RightItemIndex] as SettingsItem;
                    switch (rightItem.ItemType)
                    {
                        case SettingsItemType.ListItem:
                            (rightItem as SettingsListItem).ItemIndex = retVal;
                            (rightItem as SettingsListItem).ListChanged();
                            break;
                        case SettingsItemType.SliderBar:
                            (rightItem as SettingsSliderItem).Value = retVal;
                            (rightItem as SettingsSliderItem).SliderChanged();
                            break;
                        case SettingsItemType.ProgressBar:
                        case SettingsItemType.MaskedProgressBar:
                            (rightItem as SettingsProgressItem).Value = retVal;
                            (rightItem as SettingsProgressItem).ProgressChanged();
                            break;
                    }
                }
            }
        }

        public async void GoRight()
        {
            BeginScaleformMovieMethod(_pause._pause.Handle, "SET_INPUT_EVENT");
            ScaleformMovieMethodAddParamInt(11);
            var ret = EndScaleformMovieMethodReturnValue();
            while (!IsScaleformMovieMethodReturnValueReady(ret)) await BaseScript.Delay(0);
            var retVal = GetScaleformMovieFunctionReturnInt(ret);
            if (retVal != -1)
            {
                if (FocusLevel == 0)
                {
                    _pause.HeaderGoRight();
                    Index = retVal;
                }
                else if (FocusLevel == 2)
                {
                    var rightItem = Tabs[Index].LeftItemList[LeftItemIndex].ItemList[RightItemIndex] as SettingsItem;
                    switch (rightItem.ItemType)
                    {
                        case SettingsItemType.ListItem:
                            (rightItem as SettingsListItem).ItemIndex = retVal;
                            (rightItem as SettingsListItem).ListChanged();
                            break;
                        case SettingsItemType.SliderBar:
                            (rightItem as SettingsSliderItem).Value = retVal;
                            (rightItem as SettingsSliderItem).SliderChanged();
                            break;
                        case SettingsItemType.ProgressBar:
                        case SettingsItemType.MaskedProgressBar:
                            (rightItem as SettingsProgressItem).Value = retVal;
                            (rightItem as SettingsProgressItem).ProgressChanged();
                            break;
                    }
                }
            }

        }

        private bool firstTick = true;
        private int eventType = 0;
        private int itemId = 0;
        private int context = 0;
        private int unused = 0;

        public override async void ProcessMouse()
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
                                if (Tabs[Index].LeftItemList.All(x => !x.Enabled)) break;
                                while (!Tabs[Index].LeftItemList[leftItemIndex].Enabled)
                                {
                                    await BaseScript.Delay(0);
                                    leftItemIndex++;
                                    _pause._pause.CallFunction("SELECT_LEFT_ITEM_INDEX", leftItemIndex);
                                }
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
                                if (Tabs[Index].LeftItemList.All(x => !x.Enabled)) break;
                                while (!Tabs[Index].LeftItemList[leftItemIndex].Enabled)
                                {
                                    await BaseScript.Delay(0);
                                    leftItemIndex++;
                                    _pause._pause.CallFunction("SELECT_LEFT_ITEM_INDEX", leftItemIndex);
                                }
                                break;
                            case 1: // left item in subitem tab pressed
                                if (focusLevel != 1)
                                {
                                    if (!Tabs[Index].LeftItemList[LeftItemIndex].Enabled)
                                    {
                                        Game.PlaySound(AUDIO_ERROR, AUDIO_LIBRARY);
                                        return;
                                    }
                                    Tabs[Index].LeftItemList[LeftItemIndex].Selected = false;
                                    LeftItemIndex = itemId;
                                    Tabs[Index].LeftItemList[LeftItemIndex].Selected = true;
                                    FocusLevel = 1;
                                }
                                else if(focusLevel == 1)
                                {
                                    if (!Tabs[Index].LeftItemList[LeftItemIndex].Enabled)
                                    {
                                        Game.PlaySound(AUDIO_ERROR, AUDIO_LIBRARY);
                                        return;
                                    }
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
                                if (!(Tabs[Index].LeftItemList[leftItemIndex].ItemList[itemId] as SettingsItem).Enabled)
                                {
                                    Game.PlaySound(AUDIO_ERROR, AUDIO_LIBRARY);
                                    return;
                                }

                                if (FocusLevel != 2)
                                    FocusLevel = 2;
                                if (Tabs[Index].LeftItemList[leftItemIndex].ItemList[itemId] is SettingsItem)
                                {
                                    //(Tabs[Index].LeftItemList[leftItemIndex].ItemList[RightItemIndex] as SettingsTabItem).Activated();
                                    if ((Tabs[Index].LeftItemList[leftItemIndex].ItemList[itemId] as SettingsItem).Selected)
                                    {
                                        var item = (Tabs[Index].LeftItemList[leftItemIndex].ItemList[RightItemIndex] as SettingsItem);
                                        switch (item.ItemType)
                                        {
                                            case SettingsItemType.ListItem:
                                                (item as SettingsListItem).ListSelected();
                                                break;
                                            case SettingsItemType.CheckBox:
                                                (item as SettingsCheckboxItem).IsChecked = !(item as SettingsCheckboxItem).IsChecked!;
                                                break;
                                            case SettingsItemType.MaskedProgressBar:
                                            case SettingsItemType.ProgressBar:
                                                (item as SettingsProgressItem).ProgressSelected();
                                                break;
                                            case SettingsItemType.SliderBar:
                                                (item as SettingsSliderItem).SliderSelected();
                                                break;
                                            default:
                                                item.Activated();
                                                break;
                                        }
                                        SendPauseMenuRightItemSelect();
                                        return;
                                    }
                                    (Tabs[Index].LeftItemList[leftItemIndex].ItemList[RightItemIndex] as SettingsItem).Selected = false;
                                    RightItemIndex = itemId;
                                    _pause._pause.CallFunction("SELECT_RIGHT_ITEM_INDEX", itemId);
                                    (Tabs[Index].LeftItemList[leftItemIndex].ItemList[RightItemIndex] as SettingsItem).Selected = true;
                                }

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
                                }
                                break;
                        }
                        break;
                    case 9: // on hovered
                        switch (context)
                        {
                            case 1: // left item in subitem tab pressed
                                foreach(var item in Tabs[Index].LeftItemList)
                                    item.Hovered = Tabs[Index].LeftItemList.IndexOf(item) == itemId && item.Enabled;
                                break;
                            case 2:// right settings item in subitem tab pressed
                                foreach (var curIt in Tabs[Index].LeftItemList[LeftItemIndex].ItemList)
                                {
                                    var idx = Tabs[Index].LeftItemList[LeftItemIndex].ItemList.IndexOf(curIt);
                                    if (curIt is SettingsItem)
                                    {
                                        (curIt as SettingsItem).Hovered = itemId == idx && (curIt as SettingsItem).Enabled;
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

            if (Game.IsControlJustPressed(2, Control.PhoneUp))
                GoUp();
            else if (Game.IsControlJustPressed(2, Control.PhoneDown))
                GoDown();
            else if (Game.IsControlJustPressed(2, Control.PhoneLeft))
                GoLeft();
            else if (Game.IsControlJustPressed(2, Control.PhoneRight))
                GoRight();
            else if (Game.IsControlJustPressed(2, Control.FrontendLb))
            {
                if (FocusLevel == 0)
                {
                    GoLeft();
                }
            }
            else if (Game.IsControlJustPressed(2, Control.FrontendRb))
            {
                if (FocusLevel == 0)
                {
                    GoRight();
                }
            }
            else if (Game.IsControlJustPressed(2, Control.FrontendAccept))
                Select(false);
            else if (Game.IsControlJustPressed(2, Control.PhoneCancel))
                GoBack();

            if (Game.IsControlJustPressed(1, Control.CursorScrollUp))
                _pause.SendScrollEvent(-1);
            else if (Game.IsControlJustPressed(1, Control.CursorScrollDown))
                _pause.SendScrollEvent(1);

            if (Game.IsControlPressed(2, Control.LookUpOnly) && !IsUsingKeyboard(2))
            {
                if (Game.GameTime - _timer > 175)
                {
                    _pause.SendScrollEvent(-1);
                    _timer = Game.GameTime;
                }
            }
            else if (Game.IsControlPressed(2, Control.LookDownOnly) && !IsUsingKeyboard(2))
            {
                if (Game.GameTime - _timer > 175)
                {
                    _pause.SendScrollEvent(1);
                    _timer = Game.GameTime;
                }
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
            OnLeftItemChange?.Invoke(this, Tabs[Index].LeftItemList[LeftItemIndex], LeftItemIndex);
        }

        internal void SendPauseMenuLeftItemSelect()
        {
            OnLeftItemSelect?.Invoke(this, Tabs[Index].LeftItemList[LeftItemIndex], LeftItemIndex);
        }
        internal void SendPauseMenuRightItemChange()
        {
            OnRightItemChange?.Invoke(this, Tabs[Index].LeftItemList[LeftItemIndex].ItemList[RightItemIndex] as SettingsItem, LeftItemIndex, RightItemIndex);
        }
        internal void SendPauseMenuRightItemSelect()
        {
            OnRightItemSelect?.Invoke(this, Tabs[Index].LeftItemList[LeftItemIndex].ItemList[RightItemIndex] as SettingsItem, LeftItemIndex, RightItemIndex);
        }
    }
}
using CitizenFX.Core;
using ScaleformUI.Elements;
using ScaleformUI.Menu;
using ScaleformUI.PauseMenus;
using ScaleformUI.PauseMenus.Elements.Items;
using ScaleformUI.PauseMenus.Elements.Panels;
using ScaleformUI.Scaleforms;
using static CitizenFX.Core.Native.API;

namespace ScaleformUI.PauseMenu
{
    public delegate void PauseMenuOpenEvent(TabView menu);
    public delegate void PauseMenuCloseEvent(TabView menu);
    public delegate void PauseMenuTabChanged(TabView menu, BaseTab tab, int i);
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
        private bool isBuilding = false;
        public string Title { get; set; }
        public string SubTitle { get; set; }
        public string SideStringTop { get; set; }
        public string SideStringMiddle { get; set; }
        public string SideStringBottom { get; set; }
        public bool ShowBlur = true;
        public Tuple<string, string> HeaderPicture
        {
            internal get => headerPicture;
            set
            {
                headerPicture = value;
                if (Visible)
                    _pause.SetHeaderCharImg(HeaderPicture.Item1, HeaderPicture.Item2, true);

            }
        }
        public Tuple<string, string> CrewPicture { internal get; set; }
        public bool SetHeaderDynamicWidth { get; set; }
        public List<BaseTab> Tabs { get; set; }
        private int index;
        public int LeftItemIndex
        {
            get => leftItemIndex;
            set
            {
                Tabs[Index].LeftItemList[leftItemIndex].Selected = false;
                leftItemIndex = value;
                Tabs[Index].LeftItemList[leftItemIndex].Selected = true;
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
                _pause?.SetFocus(value);
                SendPauseMenuFocusChange();
            }
        }
        public bool TemporarilyHidden { get; set; }
        public bool HideTabs { get; set; }
        public bool DisplayHeader = true;

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
            index = 0;
            FocusLevel = 0;
            TemporarilyHidden = false;
            InstructionalButtons = new()
            {
                new InstructionalButton(Control.PhoneSelect, UIMenu._selectTextLocalized),
                new InstructionalButton(Control.PhoneCancel, UIMenu._backTextLocalized),
                new InstructionalButton(InputGroup.INPUTGROUP_FRONTEND_BUMPERS, _browseTextLocalized),
            };
            _pause = Main.PauseMenu;
        }

        public override bool Visible
        {
            get { return _visible; }
            set
            {
                base.Visible = value;
                _visible = value;
                _pause.Visible = value;
                Game.IsPaused = value;
                if (value)
                {
                    ActivateFrontendMenu((uint)Game.GenerateHash("FE_MENU_VERSION_CORONA"), true, -1);
                    if (ShowBlur)
                        doScreenBlur();
                    Main.InstructionalButtons.SetInstructionalButtons(InstructionalButtons);
                    SetPlayerControl(Game.Player.Handle, false, 0);
                    isBuilding = true;
                    ShowHeader();
                    foreach (BaseTab tab in Tabs)
                    {
                        _pause.AddPauseMenuTab(tab.Title, 0, tab._type, tab.TabColor);
                    }
                    Tabs[0].Visible = true;
                    BuildPauseMenu();
                    MenuHandler.currentBase = this;
                    SendPauseMenuOpen();
                }
                else
                {
                    if (Tabs[Index] is PlayerListTab t)
                        t.Minimap?.Dispose();
                    else if (Tabs[Index] is GalleryTab g)
                        g.Minimap?.Dispose();
                    if (ShowBlur || AnimpostfxIsRunning("PauseMenuIn"))
                    {
                        AnimpostfxStop("PauseMenuIn");
                        AnimpostfxPlay("PauseMenuOut", 0, false);
                    }
                    SendPauseMenuClose();
                    SetPlayerControl(Game.Player.Handle, true, 0);
                    MenuHandler.currentBase = null;
                    Main.InstructionalButtons.ClearButtonList();
                    _pause.Dispose();
                    ActivateFrontendMenu((uint)Game.GenerateHash("FE_MENU_VERSION_CORONA"), false, -1);
                }
            }
        }

        private async void doScreenBlur()
        {
            while (AnimpostfxIsRunning("PauseMenuOut"))
            {
                await BaseScript.Delay(0);
                AnimpostfxStop("PauseMenuOut");
            }
            AnimpostfxPlay("PauseMenuIn", 0, true);
        }

        public int Index
        {
            get => index; set
            {
                _pause._pause.CallFunction("CLEAR_ALL");
                _pause._pause.CallFunction("FADE_OUT");
                Tabs[Index].Visible = false;
                index = value;
                if (index > Tabs.Count - 1)
                    index = 0;
                if (index < 0)
                    index = Tabs.Count - 1;
                Tabs[Index].Visible = true;
                if (Visible)
                {
                    BuildPauseMenu();
                    _pause.SelectTab(index);
                }
                SendPauseMenuTabChange();
            }
        }

        public void AddTab(BaseTab item)
        {
            if (item is PlayerListTab t)
            {
                t.Minimap = new MinimapPanel(this, t);
            }
            if (item is GalleryTab g)
            {
                g.Minimap = new MinimapPanel(this, g);
            }
            item.Parent = this;
            Tabs.Add(item);
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
            if (HeaderPicture != null && !string.IsNullOrEmpty(HeaderPicture.Item1) && !string.IsNullOrEmpty(HeaderPicture.Item2))
                _pause.SetHeaderCharImg(HeaderPicture.Item1, HeaderPicture.Item2, true);
            else
                _pause.SetHeaderCharImg("CHAR_DEFAULT", "CHAR_DEFAULT", true);
            if (CrewPicture != null)
                _pause.SetHeaderSecondaryImg(CrewPicture.Item1, CrewPicture.Item2, true);
            _pause.SetHeaderDetails(SideStringTop, SideStringMiddle, SideStringBottom);
            _pause._header.CallFunction("ENABLE_DYNAMIC_WIDTH", SetHeaderDynamicWidth);
            _loaded = true;
        }

        public void BuildPauseMenu()
        {
            isBuilding = true;
            if (!HasStreamedTextureDictLoaded("commonmenu"))
                RequestStreamedTextureDict("commonmenu", true);
            BaseTab tab = Tabs[Index];
            switch (tab._type)
            {
                case 0:
                    {
                        TextTab simpleTab = (TextTab)tab;
                        _pause._pause.CallFunction("ADD_TAB", 0);
                        if (!string.IsNullOrWhiteSpace(simpleTab.TextTitle))
                            _pause.AddRightTitle(0, simpleTab.TextTitle);
                        for (int j = 0; j < simpleTab.LabelsList.Count; j++)
                        {
                            BasicTabItem it = simpleTab.LabelsList[j];
                            _pause.AddRightListLabel(0, it.Label, it.LabelFont.FontName, it.LabelFont.FontID);
                        }
                        if (!(string.IsNullOrWhiteSpace(simpleTab.BGTextureDict) && string.IsNullOrWhiteSpace(simpleTab.BGTextureName)))
                            _pause._pause.CallFunction("UPDATE_BASE_TAB_BACKGROUND", simpleTab.BGTextureDict, simpleTab.BGTextureName);
                        if (!(string.IsNullOrWhiteSpace(simpleTab.RightTextureDict) && string.IsNullOrWhiteSpace(simpleTab.RightTextureName)))
                            _pause._pause.CallFunction("SET_BASE_TAB_RIGHT_PICTURE", simpleTab.RightTextureDict, simpleTab.RightTextureName);
                    }
                    break;
                case 1:
                    {
                        SubmenuTab submenu = (SubmenuTab)tab;
                        _pause._pause.CallFunction("ADD_TAB", 1);
                        for (int j = 0; j < submenu.LeftItemList.Count; j++)
                        {
                            TabLeftItem item = submenu.LeftItemList[j];
                            _pause.AddLeftItem((int)item.ItemType, item._formatLeftLabel, item.MainColor, item.HighlightColor);

                            if (item._labelFont != ScaleformFonts.CHALET_LONDON_NINETEENSIXTY)
                                _pause._pause.CallFunction("SET_LEFT_ITEM_LABEL_FONT", j, item._labelFont.FontName, item._labelFont.FontID);
                            //_pause._pause.CallFunction("SET_LEFT_ITEM_RIGHT_LABEL_FONT", i, j, item._labelFont.FontName, item._labelFont.FontID);

                            if (!string.IsNullOrWhiteSpace(item.RightTitle))
                            {
                                if (item.ItemType == LeftItemType.Keymap)
                                    _pause.AddKeymapTitle(j, item.RightTitle, item.KeymapRightLabel_1, item.KeymapRightLabel_2);
                                else
                                    _pause.AddRightTitle(j, item.RightTitle);
                            }


                            for (int k = 0; k < item.ItemList.Count; k++)
                            {
                                BasicTabItem ii = item.ItemList[k];
                                switch (ii)
                                {
                                    default:
                                        {
                                            _pause.AddRightListLabel(j, ii.Label, ii.LabelFont.FontName, ii.LabelFont.FontID);
                                        }
                                        break;
                                    case StatsTabItem:
                                        {
                                            StatsTabItem sti = ii as StatsTabItem;
                                            switch (sti.Type)
                                            {
                                                case StatItemType.Basic:
                                                    _pause.AddRightStatItemLabel(j, sti.Label, sti.RightLabel, sti.LabelFont, sti.rightLabelFont);
                                                    break;
                                                case StatItemType.ColoredBar:
                                                    _pause.AddRightStatItemColorBar(j, sti.Label, sti.Value, sti.ColoredBarColor, sti.labelFont);
                                                    break;
                                            }
                                        }
                                        break;
                                    case SettingsItem:
                                        {
                                            SettingsItem sti = ii as SettingsItem;
                                            switch (sti.ItemType)
                                            {
                                                case SettingsItemType.Basic:
                                                    _pause.AddRightSettingsBaseItem(j, sti.Label, sti.RightLabel, sti.Enabled);
                                                    break;
                                                case SettingsItemType.ListItem:
                                                    SettingsListItem lis = (SettingsListItem)sti;
                                                    _pause.AddRightSettingsListItem(j, lis.Label, lis.ListItems, lis.ItemIndex, lis.Enabled);
                                                    break;
                                                case SettingsItemType.ProgressBar:
                                                    SettingsProgressItem prog = (SettingsProgressItem)sti;
                                                    _pause.AddRightSettingsProgressItem(j, prog.Label, prog.MaxValue, prog.ColoredBarColor, prog.Value, prog.Enabled);
                                                    break;
                                                case SettingsItemType.MaskedProgressBar:
                                                    SettingsProgressItem prog_alt = (SettingsProgressItem)sti;
                                                    _pause.AddRightSettingsProgressItemAlt(j, sti.Label, prog_alt.MaxValue, prog_alt.ColoredBarColor, prog_alt.Value, prog_alt.Enabled);
                                                    break;
                                                case SettingsItemType.CheckBox:
                                                    SettingsCheckboxItem check = (SettingsCheckboxItem)sti;
                                                    _pause.AddRightSettingsCheckboxItem(j, check.Label, check.CheckBoxStyle, check.IsChecked, check.Enabled);
                                                    break;
                                                case SettingsItemType.SliderBar:
                                                    SettingsSliderItem slid = (SettingsSliderItem)sti;
                                                    _pause.AddRightSettingsSliderItem(j, slid.Label, slid.MaxValue, slid.ColoredBarColor, slid.Value, slid.Enabled);
                                                    break;
                                            }
                                        }
                                        break;
                                    case KeymapItem:
                                        KeymapItem ki = ii as KeymapItem;
                                        if (IsUsingKeyboard(2))
                                            _pause.AddKeymapItem(j, ki.Label, ki.PrimaryKeyboard, ki.SecondaryKeyboard);
                                        else
                                            _pause.AddKeymapItem(j, ki.Label, ki.PrimaryGamepad, ki.SecondaryGamepad);
                                        UpdateKeymapItems();
                                        break;
                                }
                            }

                            if (item.ItemType == LeftItemType.Info || item.ItemType == LeftItemType.Statistics || item.ItemType == LeftItemType.Settings)
                            {
                                if (!(string.IsNullOrWhiteSpace(item.TextureDict) && string.IsNullOrWhiteSpace(item.TextureName)))
                                    _pause._pause.CallFunction("UPDATE_LEFT_ITEM_RIGHT_BACKGROUND", j, item.TextureDict, item.TextureName, (int)item.LeftItemBGType);
                            }

                        }
                    }
                    break;
                case 2:
                    {
                        PlayerListTab plTab = (PlayerListTab)tab;
                        _pause._pause.CallFunction("ADD_TAB", 2);
                        switch (plTab.listCol.Count)
                        {
                            case 1:
                                _pause._pause.CallFunction("CREATE_PLAYERS_TAB_COLUMNS", plTab.listCol[0].Type);
                                _pause._pause.CallFunction("SET_PLAYERS_TAB_COLUMN_MAXITEMS", 0, plTab.listCol[0]._maxItems);
                                break;
                            case 2:
                                _pause._pause.CallFunction("CREATE_PLAYERS_TAB_COLUMNS", plTab.listCol[0].Type, plTab.listCol[1].Type);
                                _pause._pause.CallFunction("SET_PLAYERS_TAB_COLUMN_MAXITEMS", 0, plTab.listCol[0]._maxItems);
                                _pause._pause.CallFunction("SET_PLAYERS_TAB_COLUMN_MAXITEMS", 1, plTab.listCol[1]._maxItems);
                                break;
                            case 3:
                                _pause._pause.CallFunction("CREATE_PLAYERS_TAB_COLUMNS", plTab.listCol[0].Type, plTab.listCol[1].Type, plTab.listCol[2].Type);
                                _pause._pause.CallFunction("SET_PLAYERS_TAB_COLUMN_MAXITEMS", 0, plTab.listCol[0]._maxItems);
                                _pause._pause.CallFunction("SET_PLAYERS_TAB_COLUMN_MAXITEMS", 1, plTab.listCol[1]._maxItems);
                                _pause._pause.CallFunction("SET_PLAYERS_TAB_COLUMN_MAXITEMS", 2, plTab.listCol[2]._maxItems);
                                break;
                        }
                        _pause._pause.CallFunction("SET_PLAYERS_TAB_NEWSTYLE", plTab._newStyle);
                        if (plTab.listCol.Any(x => x.Type == "settings"))
                        {
                            plTab.SettingsColumn.Parent = this;
                            plTab.SettingsColumn.isBuilding = true;
                            buildSettings(plTab);
                        }
                        if (plTab.listCol.Any(x => x.Type == "players"))
                        {
                            plTab.PlayersColumn.Parent = this;
                            plTab.PlayersColumn.isBuilding = true;
                            buildPlayers(plTab);
                        }
                        if (plTab.listCol.Any(x => x.Type == "missions"))
                        {
                            plTab.MissionsColumn.isBuilding = true;
                            plTab.MissionsColumn.Parent = this;
                            buildMissions(plTab);
                        }
                        if (plTab.listCol.Any(x => x.Type == "store"))
                        {
                            plTab.StoreColumn.isBuilding = true;
                            plTab.StoreColumn.Parent = this;
                            buildStore(plTab);
                        }
                        if (plTab.listCol.Any(x => x.Type == "panel"))
                        {
                            plTab.MissionPanel.Parent = this;
                            buildPanel(plTab);
                        }
                        plTab.SelectColumn(0);
                    }
                    break;
                case 3:
                    _pause._pause.CallFunction("ADD_TAB", 3);
                    GalleryTab glTab = (GalleryTab)tab;
                    if (!string.IsNullOrEmpty(glTab.dateLabel) && !string.IsNullOrEmpty(glTab.locationLabel) && !string.IsNullOrEmpty(glTab.trackLabel))
                        _pause._pause.CallFunction("SET_GALLERY_DESCRIPTION_LABELS", glTab.maxItemsPerPage, glTab.titleLabel, glTab.dateLabel, glTab.locationLabel, glTab.trackLabel, glTab.labelsVisible);

                    for (int i = 0; i < 12; i++)
                    {
                        if (i <= glTab.GalleryItems.Count - 1)
                        {
                            GalleryItem item = glTab.GalleryItems[i];
                            _pause._pause.CallFunction("ADD_GALLERY_ITEM", i, i, 33, 4, 0, 1, item.Label1, item.Label2, item.TextureDictionary, item.TextureName, 1, false, item.Label3, item.Label4);
                            if (item.Blip != null)
                                glTab.Minimap.MinimapBlips.Add(item.Blip);
                        }
                        else
                            _pause._pause.CallFunction("ADD_GALLERY_ITEM", i, i, 33, 0, 0, 1, "", "", "", "", 1, false);
                    }
                    glTab.UpdatePage();
                    _pause._pause.CallFunction("DISPLAY_GALLERY");
                    break;
            }
            _pause._pause.CallFunction("UPDATE_DRAWING");
            _pause._pause.CallFunction("FADE_IN");
            isBuilding = false;
        }

        bool canBuild = true;
        internal void buildSettings(PlayerListTab tab)
        {
            int max = tab.SettingsColumn.Pagination.ItemsPerPage;
            if (tab.SettingsColumn.Items.Count < max)
                max = tab.SettingsColumn.Items.Count;

            tab.SettingsColumn.Pagination.MinItem = tab.SettingsColumn.Pagination.CurrentPageStartIndex;
            if (tab.SettingsColumn.Pagination.scrollType == ScrollingType.CLASSIC && tab.SettingsColumn.Pagination.TotalPages > 1)
            {
                int missingItems = tab.SettingsColumn.Pagination.GetMissingItems();
                if (missingItems > 0)
                {
                    tab.SettingsColumn.Pagination.ScaleformIndex = tab.SettingsColumn.Pagination.GetPageIndexFromMenuIndex(tab.SettingsColumn.Pagination.CurrentPageEndIndex) + missingItems;
                    tab.SettingsColumn.Pagination.MinItem = tab.SettingsColumn.Pagination.CurrentPageStartIndex - missingItems;
                }
            }
            tab.SettingsColumn.Pagination.MaxItem = tab.SettingsColumn.Pagination.CurrentPageEndIndex;

            for (int i = 0; i < max; i++)
            {
                tab.SettingsColumn._itemCreation(tab.SettingsColumn.Pagination.CurrentPage, i, false, true);
            }
            tab.SettingsColumn.CurrentSelection = 0;
            tab.SettingsColumn.Pagination.ScaleformIndex = tab.SettingsColumn.Pagination.GetScaleformIndex(tab.SettingsColumn.CurrentSelection);
            tab.SettingsColumn.Items[0].Selected = false;
            _pause._pause.CallFunction("SET_PLAYERS_TAB_SETTINGS_SELECTION", tab.SettingsColumn.Pagination.ScaleformIndex);
            _pause._pause.CallFunction("SET_PLAYERS_TAB_SETTINGS_QTTY", tab.SettingsColumn.CurrentSelection + 1, tab.SettingsColumn.Items.Count);
            tab.SettingsColumn.isBuilding = false;
        }

        internal void buildPlayers(PlayerListTab tab)
        {
            int max = tab.PlayersColumn.Pagination.ItemsPerPage;
            if (tab.PlayersColumn.Items.Count < max)
                max = tab.PlayersColumn.Items.Count;

            tab.PlayersColumn.Pagination.MinItem = tab.PlayersColumn.Pagination.CurrentPageStartIndex;
            if (tab.PlayersColumn.Pagination.scrollType == ScrollingType.CLASSIC && tab.PlayersColumn.Pagination.TotalPages > 1)
            {
                int missingItems = tab.PlayersColumn.Pagination.GetMissingItems();
                if (missingItems > 0)
                {
                    tab.PlayersColumn.Pagination.ScaleformIndex = tab.PlayersColumn.Pagination.GetPageIndexFromMenuIndex(tab.PlayersColumn.Pagination.CurrentPageEndIndex) + missingItems;
                    tab.PlayersColumn.Pagination.MinItem = tab.PlayersColumn.Pagination.CurrentPageStartIndex - missingItems;
                }
            }
            tab.PlayersColumn.Pagination.MaxItem = tab.PlayersColumn.Pagination.CurrentPageEndIndex;

            for (int i = 0; i < max; i++)
            {
                tab.PlayersColumn._itemCreation(tab.PlayersColumn.Pagination.CurrentPage, i, false, true);
            }
            tab.PlayersColumn.CurrentSelection = 0;
            tab.PlayersColumn.Pagination.ScaleformIndex = tab.PlayersColumn.Pagination.GetScaleformIndex(tab.PlayersColumn.CurrentSelection);
            tab.PlayersColumn.Items[0].Selected = false;
            _pause._pause.CallFunction("SET_PLAYERS_TAB_PLAYERS_SELECTION", tab.PlayersColumn.Pagination.ScaleformIndex);
            _pause._pause.CallFunction("SET_PLAYERS_TAB_PLAYERS_QTTY", tab.PlayersColumn.CurrentSelection + 1, tab.PlayersColumn.Items.Count);
            tab.PlayersColumn.isBuilding = false;
        }

        internal void buildMissions(PlayerListTab tab)
        {
            int max = tab.MissionsColumn.Pagination.ItemsPerPage;
            if (tab.MissionsColumn.Items.Count < max)
                max = tab.MissionsColumn.Items.Count;

            tab.MissionsColumn.Pagination.MinItem = tab.MissionsColumn.Pagination.CurrentPageStartIndex;
            if (tab.MissionsColumn.Pagination.scrollType == ScrollingType.CLASSIC && tab.MissionsColumn.Pagination.TotalPages > 1)
            {
                int missingItems = tab.MissionsColumn.Pagination.GetMissingItems();
                if (missingItems > 0)
                {
                    tab.MissionsColumn.Pagination.ScaleformIndex = tab.MissionsColumn.Pagination.GetPageIndexFromMenuIndex(tab.MissionsColumn.Pagination.CurrentPageEndIndex) + missingItems;
                    tab.MissionsColumn.Pagination.MinItem = tab.MissionsColumn.Pagination.CurrentPageStartIndex - missingItems;
                }
            }
            tab.MissionsColumn.Pagination.MaxItem = tab.MissionsColumn.Pagination.CurrentPageEndIndex;

            for (int i = 0; i < max; i++)
            {
                tab.MissionsColumn._itemCreation(tab.MissionsColumn.Pagination.CurrentPage, i, false, true);
            }
            tab.MissionsColumn.CurrentSelection = 0;
            tab.MissionsColumn.Pagination.ScaleformIndex = tab.MissionsColumn.Pagination.GetScaleformIndex(tab.MissionsColumn.CurrentSelection);
            tab.MissionsColumn.Items[0].Selected = false;
            _pause._pause.CallFunction("SET_PLAYERS_TAB_MISSIONS_SELECTION", tab.MissionsColumn.Pagination.ScaleformIndex);
            _pause._pause.CallFunction("SET_PLAYERS_TAB_MISSIONS_QTTY", tab.MissionsColumn.CurrentSelection + 1, tab.MissionsColumn.Items.Count);
            tab.MissionsColumn.isBuilding = false;
        }

        internal void buildStore(PlayerListTab tab)
        {
            int max = tab.StoreColumn.Pagination.ItemsPerPage;
            if (tab.StoreColumn.Items.Count < max)
                max = tab.StoreColumn.Items.Count;

            tab.StoreColumn.Pagination.MinItem = tab.StoreColumn.Pagination.CurrentPageStartIndex;
            if (tab.StoreColumn.Pagination.scrollType == ScrollingType.CLASSIC && tab.StoreColumn.Pagination.TotalPages > 1)
            {
                int missingItems = tab.StoreColumn.Pagination.GetMissingItems();
                if (missingItems > 0)
                {
                    tab.StoreColumn.Pagination.ScaleformIndex = tab.StoreColumn.Pagination.GetPageIndexFromMenuIndex(tab.StoreColumn.Pagination.CurrentPageEndIndex) + missingItems;
                    tab.StoreColumn.Pagination.MinItem = tab.StoreColumn.Pagination.CurrentPageStartIndex - missingItems;
                }
            }
            tab.StoreColumn.Pagination.MaxItem = tab.StoreColumn.Pagination.CurrentPageEndIndex;

            for (int i = 0; i < max; i++)
            {
                tab.StoreColumn._itemCreation(tab.StoreColumn.Pagination.CurrentPage, i, false, true);
            }
            tab.StoreColumn.CurrentSelection = 0;
            tab.StoreColumn.Pagination.ScaleformIndex = tab.StoreColumn.Pagination.GetScaleformIndex(tab.StoreColumn.CurrentSelection);
            tab.StoreColumn.Items[0].Selected = false;
            _pause._pause.CallFunction("SET_PLAYERS_TAB_STORE_SELECTION", tab.StoreColumn.Pagination.ScaleformIndex);
            _pause._pause.CallFunction("SET_PLAYERS_TAB_STORE_QTTY", tab.StoreColumn.CurrentSelection + 1, tab.StoreColumn.Items.Count);
            tab.StoreColumn.isBuilding = false;
        }

        internal void buildPanel(PlayerListTab tab)
        {
            _pause._pause.CallFunction("ADD_PLAYERS_TAB_MISSION_PANEL_PICTURE", tab.MissionPanel.TextureDict, tab.MissionPanel.TextureName);
            _pause._pause.CallFunction("SET_PLAYERS_TAB_MISSION_PANEL_TITLE", tab.MissionPanel.Title);
            if (tab.MissionPanel.Items.Count > 0)
            {
                for (int j = 0; j < tab.MissionPanel.Items.Count; j++)
                {
                    UIFreemodeDetailsItem item = tab.MissionPanel.Items[j];
                    _pause._pause.CallFunction("ADD_PLAYERS_TAB_MISSION_PANEL_ITEM", item.Type, item.TextLeft, item.TextRight, (int)item.Icon, item.IconColor, item.Tick, item._labelFont.FontName, item._labelFont.FontID, item._rightLabelFont.FontName, item._rightLabelFont.FontID);
                }
            }
        }

        private bool controller = false;
        public override async void Draw()
        {
            if (!Visible || TemporarilyHidden || isBuilding) return;
            if (Tabs[Index] is PlayerListTab t)
            {
                t.Minimap?.MaintainMap();
            }
            else if (Tabs[Index] is GalleryTab g)
            {
                g.Minimap.MaintainMap();
            }
            base.Draw();
            _pause.Draw();
            _pause._header.CallFunction("SHOW_ARROWS");
            UpdateKeymapItems();
        }

        private void UpdateKeymapItems()
        {
            if (!IsUsingKeyboard(2))
            {
                if (!controller)
                {
                    controller = true;
                    if (Tabs[Index] is SubmenuTab)
                    {
                        foreach (TabLeftItem lItem in (Tabs[Index] as SubmenuTab).LeftItemList)
                        {
                            int idx = (Tabs[Index] as SubmenuTab).LeftItemList.IndexOf(lItem);
                            if (lItem.ItemType == LeftItemType.Keymap)
                            {
                                for (int i = 0; i < lItem.ItemList.Count; i++)
                                {
                                    KeymapItem item = (KeymapItem)lItem.ItemList[i];
                                    _pause.UpdateKeymap(idx, i, item.PrimaryGamepad, item.SecondaryGamepad);
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
                    if (Tabs[Index] is SubmenuTab)
                    {
                        foreach (TabLeftItem lItem in (Tabs[Index] as SubmenuTab).LeftItemList)
                        {
                            int idx = (Tabs[Index] as SubmenuTab).LeftItemList.IndexOf(lItem);
                            if (lItem.ItemType == LeftItemType.Keymap)
                            {
                                for (int i = 0; i < lItem.ItemList.Count; i++)
                                {
                                    KeymapItem item = (KeymapItem)lItem.ItemList[i];
                                    _pause.UpdateKeymap(idx, i, item.PrimaryKeyboard, item.SecondaryKeyboard);
                                }
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
                    if (Tabs[Index] is PlayerListTab pl)
                    {
                        int selection = pl._newStyle ? pl.Focus : 0;
                        switch (pl.listCol[selection].Type)
                        {
                            case "settings":
                                pl.SettingsColumn.Items[pl.SettingsColumn.CurrentSelection].Selected = true;
                                break;
                            case "players":
                                pl.PlayersColumn.Items[pl.PlayersColumn.CurrentSelection].Selected = true;
                                if (pl.PlayersColumn.Items[pl.PlayersColumn.CurrentSelection].KeepPanelVisible)
                                {
                                    if (pl.PlayersColumn.Items[pl.PlayersColumn.CurrentSelection].ClonePed != null)
                                        pl.PlayersColumn.Items[pl.PlayersColumn.CurrentSelection].CreateClonedPed();
                                }
                                break;
                            case "missions":
                                pl.MissionsColumn.Items[pl.MissionsColumn.CurrentSelection].Selected = true;
                                break;
                            case "store":
                                pl.StoreColumn.Items[pl.StoreColumn.CurrentSelection].Selected = true;
                                break;
                        }
                        if (pl.listCol.Any(x => x.Type == "players"))
                            SetPauseMenuPedLighting(FocusLevel != 0);
                    }
                    else if (Tabs[Index] is GalleryTab gT)
                    {
                        if (gT.GalleryItems[gT.currentIndex].Blip != null)
                        {
                            _pause._pause.CallFunction("SET_GALLERY_PANEL_DESCRIPTION", "");
                            _pause._pause.CallFunction("SET_GALLERY_PANEL_HIDDEN", true);
                            gT.Minimap.Enabled = true;
                            gT.Minimap.RefreshMapPosition(new Vector2(gT.GalleryItems[gT.currentIndex].Blip.Position.X, gT.GalleryItems[gT.currentIndex].Blip.Position.Y));
                        }
                        else if (!string.IsNullOrEmpty(gT.GalleryItems[gT.currentIndex].RightPanelDescription))
                        {
                            gT.Minimap.Enabled = false;
                            AddTextEntry("gallerytab_desc", gT.GalleryItems[gT.currentIndex].RightPanelDescription);
                            _pause._pause.CallFunction("SET_GALLERY_PANEL_HIDDEN", false);
                            BeginScaleformMovieMethod(_pause._pause.Handle, "SET_GALLERY_PANEL_DESCRIPTION");
                            BeginTextCommandScaleformString("gallerytab_desc");
                            EndTextCommandScaleformString_2();
                            EndScaleformMovieMethod();
                        }
                        else
                        {
                            gT.Minimap.Enabled = false;
                            _pause._pause.CallFunction("SET_GALLERY_PANEL_DESCRIPTION", "");
                            _pause._pause.CallFunction("SET_GALLERY_PANEL_HIDDEN", true);
                        }
                        return;
                    }
                    else if (Tabs[Index] is SubmenuTab)
                    {
                        Tabs[Index].LeftItemList[LeftItemIndex].Selected = true;
                    }
                    if (Tabs[Index].LeftItemList.All(x => !x.Enabled)) break;
                    while (!Tabs[Index].LeftItemList[leftItemIndex].Enabled)
                    {
                        await BaseScript.Delay(0);
                        LeftItemIndex++;
                        _pause._pause.CallFunction("SELECT_LEFT_ITEM_INDEX", leftItemIndex);
                    }
                    break;
                case 1:
                    {
                        if (Tabs[Index] is SubmenuTab)
                        {
                            TabLeftItem leftItem = Tabs[Index].LeftItemList[LeftItemIndex];
                            if (!leftItem.Enabled)
                            {
                                Game.PlaySound(AUDIO_ERROR, AUDIO_LIBRARY);
                                return;
                            }
                            if (leftItem.ItemType == LeftItemType.Settings)
                            {
                                FocusLevel = 2;
                                if (leftItem.ItemList.All(x => !(x as SettingsItem).Enabled)) break;
                                while (!(leftItem.ItemList[rightItemIndex] as SettingsItem).Enabled)
                                {
                                    await BaseScript.Delay(0);
                                    rightItemIndex++;
                                    _pause._pause.CallFunction("SELECT_RIGHT_ITEM_INDEX", rightItemIndex);
                                }
                            }
                            SendPauseMenuLeftItemSelect();
                        }
                        else if (Tabs[Index] is GalleryTab gT)
                        {
                            if (!gT.bigPic)
                            {
                                gT.SetTitle(gT.GalleryItems[gT.currentIndex].TextureDictionary, gT.GalleryItems[gT.currentIndex].TextureName, GalleryState.LOADED);

                                if (gT.GalleryItems[gT.currentIndex].Blip != null)
                                {
                                    _pause._pause.CallFunction("SET_GALLERY_PANEL_DESCRIPTION", "");
                                    _pause._pause.CallFunction("SET_GALLERY_PANEL_HIDDEN", true);
                                    gT.Minimap.Enabled = true;
                                    gT.Minimap.RefreshMapPosition(new Vector2(gT.GalleryItems[gT.currentIndex].Blip.Position.X, gT.GalleryItems[gT.currentIndex].Blip.Position.Y));
                                }
                                else if (!string.IsNullOrEmpty(gT.GalleryItems[gT.currentIndex].RightPanelDescription))
                                {
                                    gT.Minimap.Enabled = false;
                                    AddTextEntry("gallerytab_desc", gT.GalleryItems[gT.currentIndex].RightPanelDescription);
                                    _pause._pause.CallFunction("SET_GALLERY_PANEL_HIDDEN", false);
                                    BeginScaleformMovieMethod(_pause._pause.Handle, "SET_GALLERY_PANEL_DESCRIPTION");
                                    BeginTextCommandScaleformString("gallerytab_desc");
                                    EndTextCommandScaleformString_2();
                                    EndScaleformMovieMethod();
                                }
                                else
                                {
                                    gT.Minimap.Enabled = false;
                                    _pause._pause.CallFunction("SET_GALLERY_PANEL_DESCRIPTION", "");
                                    _pause._pause.CallFunction("SET_GALLERY_PANEL_HIDDEN", true);
                                }
                                gT.ModeChanged();
                            }
                            else
                            {
                                gT.ItemSelected();
                                gT.GalleryItems[gT.currentIndex].ItemSelected(gT, gT.GalleryItems[gT.currentIndex], gT.currentIndex, gT.CurrentSelection);
                            }
                        }
                        else if (Tabs[Index] is PlayerListTab plTab)
                        {
                            switch (plTab.listCol[plTab.Focus].Type)
                            {
                                case "settings":
                                    UIMenuItem item = plTab.SettingsColumn.Items[plTab.SettingsColumn.CurrentSelection];
                                    if (!item.Enabled)
                                    {
                                        Game.PlaySound(AUDIO_ERROR, AUDIO_LIBRARY);
                                        return;
                                    }
                                    switch (item)
                                    {
                                        case UIMenuCheckboxItem:
                                            {
                                                UIMenuCheckboxItem it = item as UIMenuCheckboxItem;
                                                it.Checked = !it.Checked;
                                                it.CheckboxEventTrigger();
                                                plTab.SettingsColumn.SelectItem();
                                                break;
                                            }

                                        case UIMenuListItem:
                                            {
                                                UIMenuListItem it = item as UIMenuListItem;
                                                it.ListSelectedTrigger(it.Index);
                                                plTab.SettingsColumn.SelectItem();
                                                break;
                                            }

                                        default:
                                            item.ItemActivate(null);
                                            plTab.SettingsColumn.SelectItem();
                                            break;
                                    }
                                    _pause._pause.CallFunction("SET_INPUT_EVENT", 16);
                                    break;
                                case "missions":
                                    MissionItem mitem = plTab.MissionsColumn.Items[plTab.MissionsColumn.CurrentSelection];
                                    mitem.ActivateMission(plTab);
                                    plTab.MissionsColumn.SelectItem();
                                    break;
                                case "players":
                                    plTab.PlayersColumn.SelectItem();
                                    break;
                                case "store":
                                    StoreItem stItem = plTab.StoreColumn.Items[plTab.StoreColumn.CurrentSelection];
                                    stItem.Activate(plTab);
                                    plTab.StoreColumn.SelectItem();
                                    break;
                            }
                        }
                    }
                    break;
                case 2:
                    {
                        _pause._pause.CallFunction("SET_INPUT_EVENT", 16);
                        TabLeftItem leftItem = Tabs[Index].LeftItemList[LeftItemIndex];
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
                if (Tabs[Index] is not PlayerListTab)
                {
                    if (Tabs[Index] is GalleryTab gT)
                    {
                        if (gT.bigPic)
                        {
                            gT.SetTitle("", "", GalleryState.EMPTY);
                            if (gT.GalleryItems[gT.currentIndex].Blip != null)
                            {
                                _pause._pause.CallFunction("SET_GALLERY_PANEL_DESCRIPTION", "");
                                _pause._pause.CallFunction("SET_GALLERY_PANEL_HIDDEN", true);
                                gT.Minimap.Enabled = true;
                                gT.Minimap.RefreshMapPosition(new Vector2(gT.GalleryItems[gT.currentIndex].Blip.Position.X, gT.GalleryItems[gT.currentIndex].Blip.Position.Y));
                            }
                            else if (!string.IsNullOrEmpty(gT.GalleryItems[gT.currentIndex].RightPanelDescription))
                            {
                                gT.Minimap.Enabled = false;
                                AddTextEntry("gallerytab_desc", gT.GalleryItems[gT.currentIndex].RightPanelDescription);
                                _pause._pause.CallFunction("SET_GALLERY_PANEL_HIDDEN", false);
                                BeginScaleformMovieMethod(_pause._pause.Handle, "SET_GALLERY_PANEL_DESCRIPTION");
                                BeginTextCommandScaleformString("gallerytab_desc");
                                EndTextCommandScaleformString_2();
                                EndScaleformMovieMethod();
                            }
                            else
                            {
                                _pause._pause.CallFunction("SET_GALLERY_PANEL_DESCRIPTION", "");
                                gT.Minimap.Enabled = false;
                                _pause._pause.CallFunction("SET_GALLERY_PANEL_HIDDEN", false);
                            }
                            gT.ModeChanged();
                            return;
                        }
                        else
                        {
                            gT.CurrentSelection = 0;
                            gT.currentIndex = 0;
                            _pause._pause.CallFunction("SET_GALLERY_PANEL_DESCRIPTION", "");
                            if (gT.Minimap.enabled)
                                gT.Minimap.Enabled = false;
                        }
                    }
                    FocusLevel--;
                    if (Tabs[Index] is SubmenuTab subTab)
                        subTab.LeftItemList[LeftItemIndex].Selected = focusLevel == 1;
                }
                else if (Tabs[Index] is PlayerListTab pl)
                {
                    if (pl._newStyle)
                    {
                        FocusLevel--;
                        SetPauseMenuPedLighting(FocusLevel != 0);
                        if (pl.listCol.Any(x => x.Type == "settings"))
                            pl.SettingsColumn.Items[pl.SettingsColumn.CurrentSelection].Selected = false;
                        if (pl.listCol.Any(x => x.Type == "players"))
                            pl.PlayersColumn.Items[pl.PlayersColumn.CurrentSelection].Selected = false;
                        if (pl.listCol.Any(x => x.Type == "missions"))
                            pl.MissionsColumn.Items[pl.MissionsColumn.CurrentSelection].Selected = false;
                        if (pl.listCol.Any(x => x.Type == "store"))
                            pl.StoreColumn.Items[pl.StoreColumn.CurrentSelection].Selected = false;
                    }
                    else
                    {
                        if (FocusLevel == 1)
                        {
                            switch (pl.listCol[pl.Focus].Type)
                            {
                                case "settings":
                                    pl.SettingsColumn.Items[pl.SettingsColumn.CurrentSelection].Selected = false;
                                    break;
                                case "players":
                                    pl.PlayersColumn.Items[pl.PlayersColumn.CurrentSelection].Selected = false;
                                    ClearPedInPauseMenu();
                                    break;
                                case "missions":
                                    pl.MissionsColumn.Items[pl.MissionsColumn.CurrentSelection].Selected = false;
                                    break;
                                case "store":
                                    pl.StoreColumn.Items[pl.StoreColumn.CurrentSelection].Selected = false;
                                    break;
                            }
                            if (pl.Focus == 0)
                            {
                                FocusLevel--;
                                return;
                            }
                            pl.updateFocus(pl.Focus - 1);
                            return;
                        }
                    }
                }
            }
            else
            {
                if (CanPlayerCloseMenu) Visible = false;
            }
        }

        public async void GoUp()
        {
            if (Tabs[Index] is PlayerListTab plTab && FocusLevel == 1)
            {
                switch (plTab.listCol[plTab.Focus].Type)
                {
                    case "players":
                        plTab.PlayersColumn.GoUp();
                        break;
                    case "settings":
                        plTab.SettingsColumn.GoUp();
                        break;
                    case "missions":
                        plTab.MissionsColumn.GoUp();
                        break;
                    case "store":
                        plTab.StoreColumn.GoUp();
                        break;
                }
                Game.PlaySound(AUDIO_UPDOWN, AUDIO_LIBRARY);
                return;
            }

            if (FocusLevel == 1)
            {
                if (Tabs[Index] is GalleryTab g)
                {
                    int iPotentialIndex = g.currentIndex;
                    int iPotentialIndexPerPage = g.CurrentSelection;

                    if (iPotentialIndexPerPage > 3)
                    {
                        iPotentialIndex -= 4;
                        iPotentialIndexPerPage -= 4;
                    }
                    else
                    {
                        iPotentialIndex += 8;
                        iPotentialIndexPerPage += 8;
                    }

                    if (iPotentialIndex >= g.GalleryItems.Count)
                        return;

                    g.currentIndex = iPotentialIndex;
                    g.CurrentSelection = iPotentialIndexPerPage;

                    g.UpdateHighlight();
                    g.UpdatePage();
                    g.IndexChanged();

                    GalleryItem it = g.GalleryItems[g.currentIndex];
                    if (g.bigPic)
                    {
                        g.SetTitle(it.TextureDictionary, it.TextureName, GalleryState.LOADED);
                    }

                    if (it.Blip != null)
                    {
                        _pause._pause.CallFunction("SET_GALLERY_PANEL_DESCRIPTION", "");
                        _pause._pause.CallFunction("SET_GALLERY_PANEL_HIDDEN", true);
                        g.Minimap.Enabled = true;
                        g.Minimap.RefreshMapPosition(new Vector2(it.Blip.Position.X, it.Blip.Position.Y));
                    }
                    else if (!string.IsNullOrEmpty(it.RightPanelDescription))
                    {
                        AddTextEntry("gallerytab_desc", it.RightPanelDescription);
                        _pause._pause.CallFunction("SET_GALLERY_PANEL_HIDDEN", false);
                        BeginScaleformMovieMethod(_pause._pause.Handle, "SET_GALLERY_PANEL_DESCRIPTION");
                        BeginTextCommandScaleformString("gallerytab_desc");
                        EndTextCommandScaleformString_2();
                        EndScaleformMovieMethod();
                    }
                    else
                    {
                        _pause._pause.CallFunction("SET_GALLERY_PANEL_DESCRIPTION", "");
                        g.Minimap.Enabled = false;
                        _pause._pause.CallFunction("SET_GALLERY_PANEL_HIDDEN", true);
                    }
                    return;
                }
            }


            int retVal = await _pause._pause.CallFunctionReturnValueInt("SET_INPUT_EVENT", 8);
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

        public async void GoDown()
        {
            if (Tabs[Index] is PlayerListTab plTab && FocusLevel == 1)
            {
                switch (plTab.listCol[plTab.Focus].Type)
                {
                    case "players":
                        plTab.PlayersColumn.GoDown();
                        break;
                    case "settings":
                        plTab.SettingsColumn.GoDown();
                        break;
                    case "missions":
                        plTab.MissionsColumn.GoDown();
                        break;
                    case "store":
                        plTab.StoreColumn.GoDown();
                        break;
                }
                Game.PlaySound(AUDIO_UPDOWN, AUDIO_LIBRARY);
                return;
            }

            if (FocusLevel == 1)
            {
                if (Tabs[Index] is GalleryTab g)
                {
                    int iPotentialIndex = g.currentIndex;
                    int iPotentialIndexPerPage = g.CurrentSelection;

                    if (iPotentialIndexPerPage < 8)
                    {
                        iPotentialIndex += 4;
                        iPotentialIndexPerPage += 4;
                    }
                    else
                    {
                        iPotentialIndex -= 8;
                        iPotentialIndexPerPage -= 8;
                    }

                    if (iPotentialIndex >= g.GalleryItems.Count)
                        return;

                    g.currentIndex = iPotentialIndex;
                    g.CurrentSelection = iPotentialIndexPerPage;
                    g.IndexChanged();

                    g.UpdateHighlight();
                    g.UpdatePage();

                    GalleryItem it = g.GalleryItems[g.currentIndex];
                    if (g.bigPic)
                    {
                        g.SetTitle(it.TextureDictionary, it.TextureName, GalleryState.LOADED);
                    }

                    if (it.Blip != null)
                    {
                        _pause._pause.CallFunction("SET_GALLERY_PANEL_DESCRIPTION", "");
                        _pause._pause.CallFunction("SET_GALLERY_PANEL_HIDDEN", true);
                        g.Minimap.Enabled = true;
                        g.Minimap.RefreshMapPosition(new Vector2(it.Blip.Position.X, it.Blip.Position.Y));
                    }
                    else if (!string.IsNullOrEmpty(it.RightPanelDescription))
                    {
                        AddTextEntry("gallerytab_desc", it.RightPanelDescription);
                        _pause._pause.CallFunction("SET_GALLERY_PANEL_HIDDEN", false);
                        BeginScaleformMovieMethod(_pause._pause.Handle, "SET_GALLERY_PANEL_DESCRIPTION");
                        BeginTextCommandScaleformString("gallerytab_desc");
                        EndTextCommandScaleformString_2();
                        EndScaleformMovieMethod();
                    }
                    else
                    {
                        _pause._pause.CallFunction("SET_GALLERY_PANEL_DESCRIPTION", "");
                        g.Minimap.Enabled = false;
                        _pause._pause.CallFunction("SET_GALLERY_PANEL_HIDDEN", true);
                    }
                    return;
                }
            }

            int retVal = await _pause._pause.CallFunctionReturnValueInt("SET_INPUT_EVENT", 9);
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
            if (FocusLevel == 1)
            {
                if (Tabs[Index] is GalleryTab g)
                {
                    int iPotentialIndex = g.currentIndex;
                    int iPotentialIndexPerPage = g.CurrentSelection;
                    if (g.currentIndex == 0)
                    {
                        g.currentIndex = g.GalleryItems.Count - 1;
                        g.CurrentSelection = g.currentIndex % 12;
                        g.CurPage = g.MaxPages - 1;
                        if (g.MaxPages > 1)
                        {
                            _pause._pause.CallFunction("CLEAR_GALLERY");
                            g.SetDescriptionLabels(g.maxItemsPerPage, g.titleLabel, g.dateLabel, g.locationLabel, g.trackLabel, g.labelsVisible);
                            for (int i = 0; i < 12; i++)
                            {
                                int index = i + (g.CurPage * 12);
                                if (index <= g.GalleryItems.Count - 1)
                                {
                                    GalleryItem item = g.GalleryItems[index];
                                    _pause._pause.CallFunction("UPDATE_GALLERY_ITEM", i, i, 33, 4, 0, 1, item.Label1, item.Label2, item.TextureDictionary, item.TextureName, 1, false, item.Label3, item.Label4);
                                    if (item.Blip != null)
                                        g.Minimap.MinimapBlips.Add(item.Blip);
                                }
                                else
                                    _pause._pause.CallFunction("UPDATE_GALLERY_ITEM", i, i, 33, 0, 0, 1, "", "", "", "", 1, false);
                            }
                        }
                        g.UpdateHighlight();
                        g.UpdatePage();
                    }
                    else
                    {

                        if (g.CurrentSelection % 4 > 0 || (g.MaxPages <= 1) || (g.bigPic && g.CurrentSelection > 0))
                        {
                            iPotentialIndex--;
                            iPotentialIndexPerPage--;
                        }

                        if (g.ShouldNavigateToNewPage(iPotentialIndexPerPage))
                        {
                            g.CurPage = g.CurPage <= 0 ? (g.MaxPages - 1) : g.CurPage - 1;

                            g.currentIndex = g.CurPage * g.maxItemsPerPage + 3;
                            g.CurrentSelection = iPotentialIndexPerPage + 3;
                            if (g.currentIndex >= g.GalleryItems.Count || g.CurPage == g.MaxPages - 1)
                            {
                                g.currentIndex = g.GalleryItems.Count - 1;
                                g.CurrentSelection = g.currentIndex % 12;
                            }

                            _pause._pause.CallFunction("CLEAR_GALLERY");
                            g.SetDescriptionLabels(g.maxItemsPerPage, g.titleLabel, g.dateLabel, g.locationLabel, g.trackLabel, g.labelsVisible);
                            for (int i = 0; i < 12; i++)
                            {
                                int index = i + (g.CurPage * 12);
                                if (index <= g.GalleryItems.Count - 1)
                                {
                                    GalleryItem item = g.GalleryItems[index];
                                    _pause._pause.CallFunction("UPDATE_GALLERY_ITEM", i, i, 33, 4, 0, 1, item.Label1, item.Label2, item.TextureDictionary, item.TextureName, 1, false, item.Label3, item.Label4);
                                    if (item.Blip != null)
                                        g.Minimap.MinimapBlips.Add(item.Blip);
                                }
                                else
                                    _pause._pause.CallFunction("UPDATE_GALLERY_ITEM", i, i, 33, 0, 0, 1, "", "", "", "", 1, false);
                            }

                            g.UpdateHighlight();
                            g.UpdatePage();
                        }
                        else
                        {
                            g.currentIndex = iPotentialIndex;
                            g.CurrentSelection = iPotentialIndexPerPage;
                            g.UpdateHighlight();
                        }
                    }

                    GalleryItem it = g.GalleryItems[g.currentIndex];
                    if (g.bigPic)
                    {
                        g.SetTitle(it.TextureDictionary, it.TextureName, GalleryState.LOADED);
                    }

                    if (it.Blip != null)
                    {
                        _pause._pause.CallFunction("SET_GALLERY_PANEL_DESCRIPTION", "");
                        _pause._pause.CallFunction("SET_GALLERY_PANEL_HIDDEN", true);
                        g.Minimap.Enabled = true;
                        g.Minimap.RefreshMapPosition(new Vector2(it.Blip.Position.X, it.Blip.Position.Y));
                    }
                    else if (!string.IsNullOrEmpty(it.RightPanelDescription))
                    {
                        AddTextEntry("gallerytab_desc", it.RightPanelDescription);
                        _pause._pause.CallFunction("SET_GALLERY_PANEL_HIDDEN", false);
                        BeginScaleformMovieMethod(_pause._pause.Handle, "SET_GALLERY_PANEL_DESCRIPTION");
                        BeginTextCommandScaleformString("gallerytab_desc");
                        EndTextCommandScaleformString_2();
                        EndScaleformMovieMethod();
                    }
                    else
                    {
                        _pause._pause.CallFunction("SET_GALLERY_PANEL_DESCRIPTION", "");
                        g.Minimap.Enabled = false;
                        _pause._pause.CallFunction("SET_GALLERY_PANEL_HIDDEN", true);
                    }
                    g.IndexChanged();
                    return;
                }
            }

            int retVal = await _pause._pause.CallFunctionReturnValueInt("SET_INPUT_EVENT", 10);
            switch (FocusLevel)
            {
                case 0:
                    ClearPedInPauseMenu();
                    //_pause.HeaderGoLeft();
                    if (Tabs[Index] is SubmenuTab)
                    {
                        Tabs[Index].LeftItemList[LeftItemIndex].Selected = false;
                    }
                    Index--;
                    if (Tabs[Index] is PlayerListTab _plTab)
                    {
                        if (_plTab.listCol.Any(x => x.Type == "settings") && _plTab.SettingsColumn != null && _plTab.SettingsColumn.Items.Count > 0)
                        {
                            UIMenuItem item = _plTab.SettingsColumn.Items[_plTab.SettingsColumn.CurrentSelection];
                            if (item is not UIMenuListItem && item is not UIMenuSliderItem && item is not UIMenuProgressItem)
                            {
                                item.Selected = false;
                            }
                        }
                        if (_plTab.listCol.Any(x => x.Type == "missions") && _plTab.MissionsColumn != null && _plTab.MissionsColumn.Items.Count > 0)
                            _plTab.MissionsColumn.Items[_plTab.MissionsColumn.CurrentSelection].Selected = false;
                        if (_plTab.listCol.Any(x => x.Type == "store") && _plTab.StoreColumn != null && _plTab.StoreColumn.Items.Count > 0)
                            _plTab.StoreColumn.Items[_plTab.StoreColumn.CurrentSelection].Selected = false;
                        if (_plTab.listCol.Any(x => x.Type == "players"))
                        {
                            _plTab.PlayersColumn.Items[_plTab.PlayersColumn.CurrentSelection].Selected = false;
                            if (_plTab.listCol[0].Type == "players" || _plTab.PlayersColumn.Items[_plTab.PlayersColumn.CurrentSelection].KeepPanelVisible)
                            {
                                if (_plTab.PlayersColumn.Items[_plTab.PlayersColumn.CurrentSelection].ClonePed != null)
                                    _plTab.PlayersColumn.Items[_plTab.PlayersColumn.CurrentSelection].CreateClonedPed();
                                else
                                    ClearPedInPauseMenu();
                            }
                            else
                            {
                                ClearPedInPauseMenu();
                            }
                        }
                        else ClearPedInPauseMenu();
                    }
                    break;
                case 1:
                    {
                        if (Tabs[Index] is PlayerListTab plTab)
                        {
                            switch (plTab.listCol[plTab.Focus].Type)
                            {
                                case "settings":
                                    {
                                        UIMenuItem item = plTab.SettingsColumn.Items[plTab.SettingsColumn.CurrentSelection];
                                        if (!item.Enabled)
                                        {
                                            if (plTab._newStyle)
                                            {
                                                plTab.SettingsColumn.Items[plTab.SettingsColumn.CurrentSelection].Selected = false;
                                                plTab.updateFocus(plTab.Focus - 1);
                                            }
                                            else
                                            {
                                                Game.PlaySound("ERROR", "HUD_FRONTEND_DEFAULT_SOUNDSET");
                                            }
                                            return;
                                        }

                                        if (item is UIMenuListItem it)
                                        {
                                            it.Index = retVal;
                                            //ListChange(it, it.Index);
                                            it.ListChangedTrigger(it.Index);
                                        }
                                        else if (item is UIMenuSliderItem slit)
                                        {
                                            slit.Value = retVal;
                                            slit.SliderChanged(slit.Value);
                                            //SliderChange(it, it.Value);
                                        }
                                        else if (item is UIMenuProgressItem prit)
                                        {
                                            prit.Value = retVal;
                                            prit.ProgressChanged(prit.Value);
                                            //ProgressChange(it, it.Value);
                                        }
                                        else
                                        {
                                            if (plTab._newStyle)
                                            {
                                                plTab.SettingsColumn.Items[plTab.SettingsColumn.CurrentSelection].Selected = false;
                                                plTab.updateFocus(plTab.Focus - 1);
                                            }
                                        }
                                    }
                                    break;
                                case "missions":
                                    if (plTab._newStyle)
                                    {
                                        plTab.MissionsColumn.Items[plTab.MissionsColumn.CurrentSelection].Selected = false;
                                        plTab.updateFocus(plTab.Focus - 1);
                                    }
                                    break;
                                case "store":
                                    if (plTab._newStyle)
                                    {
                                        plTab.StoreColumn.Items[plTab.StoreColumn.CurrentSelection].Selected = false;
                                        plTab.updateFocus(plTab.Focus - 1);
                                    }
                                    break;
                                case "panel":
                                    plTab.updateFocus(plTab.Focus - 1);
                                    break;
                                case "players":
                                    if (plTab._newStyle)
                                    {
                                        plTab.PlayersColumn.Items[plTab.PlayersColumn.CurrentSelection].Selected = false;
                                        plTab.updateFocus(plTab.Focus - 1);
                                    }
                                    else
                                    {
                                        if (plTab.PlayersColumn.Items[plTab.PlayersColumn.CurrentSelection].ClonePed != null)
                                            plTab.PlayersColumn.Items[plTab.PlayersColumn.CurrentSelection].CreateClonedPed();
                                    }
                                    break;
                            }
                        }
                        break;
                    }
                case 2:
                    {
                        SettingsItem rightItem = Tabs[Index].LeftItemList[LeftItemIndex].ItemList[RightItemIndex] as SettingsItem;
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

                        break;
                    }
            }
        }

        public async void GoRight()
        {
            if (FocusLevel == 1)
            {
                if (Tabs[Index] is GalleryTab g)
                {
                    int iPotentialIndex = g.currentIndex;
                    int iPotentialIndexPerPage = g.CurrentSelection;

                    if (g.currentIndex == g.GalleryItems.Count - 1)
                    {
                        g.currentIndex = 0;
                        g.CurrentSelection = 0;
                        g.CurPage = 0;
                        if (g.MaxPages > 1)
                        {
                            _pause._pause.CallFunction("CLEAR_GALLERY");
                            g.SetDescriptionLabels(g.maxItemsPerPage, g.titleLabel, g.dateLabel, g.locationLabel, g.trackLabel, g.labelsVisible);
                            for (int i = 0; i < 12; i++)
                            {
                                int index = i + (g.CurPage * 12);
                                if (index <= g.GalleryItems.Count - 1)
                                {
                                    GalleryItem item = g.GalleryItems[index];
                                    _pause._pause.CallFunction("UPDATE_GALLERY_ITEM", i, i, 33, 4, 0, 1, item.Label1, item.Label2, item.TextureDictionary, item.TextureName, 1, false, item.Label3, item.Label4);
                                    if (item.Blip != null)
                                        g.Minimap.MinimapBlips.Add(item.Blip);
                                }
                                else
                                    _pause._pause.CallFunction("UPDATE_GALLERY_ITEM", i, i, 33, 0, 0, 1, "", "", "", "", 1, false);
                            }
                        }
                        g.UpdateHighlight();
                        g.UpdatePage();
                    }
                    else
                    {
                        if ((g.CurrentSelection % 4 < 4 - 1) || g.MaxPages <= 1 || (g.bigPic && g.CurrentSelection < 11))
                        {
                            iPotentialIndex++;
                            iPotentialIndexPerPage++;
                        }

                        if (g.ShouldNavigateToNewPage(iPotentialIndexPerPage))
                        {
                            g.CurPage = g.CurPage == (g.MaxPages - 1) ? 0 : g.CurPage + 1;

                            g.currentIndex = g.bigPic ? (g.CurPage * g.maxItemsPerPage) : (g.CurPage * g.maxItemsPerPage + iPotentialIndexPerPage - 3);
                            g.CurrentSelection = g.bigPic ? 0 : iPotentialIndexPerPage - 3;
                            if (g.currentIndex >= g.GalleryItems.Count || g.CurPage == 0)
                                g.CurrentSelection = 0;

                            _pause._pause.CallFunction("CLEAR_GALLERY");
                            g.SetDescriptionLabels(g.maxItemsPerPage, g.titleLabel, g.dateLabel, g.locationLabel, g.trackLabel, g.labelsVisible);
                            for (int i = 0; i < 12; i++)
                            {
                                int index = i + (g.CurPage * 12);
                                if (index <= g.GalleryItems.Count - 1)
                                {
                                    GalleryItem item = g.GalleryItems[index];
                                    _pause._pause.CallFunction("UPDATE_GALLERY_ITEM", i, i, 33, 4, 0, 1, item.Label1, item.Label2, item.TextureDictionary, item.TextureName, 1, false, item.Label3, item.Label4);
                                    if (item.Blip != null)
                                        g.Minimap.MinimapBlips.Add(item.Blip);
                                }
                                else
                                    _pause._pause.CallFunction("UPDATE_GALLERY_ITEM", i, i, 33, 0, 0, 1, "", "", "", "", 1, false);
                            }

                            g.UpdateHighlight();
                            g.UpdatePage();
                        }
                        else
                        {
                            g.currentIndex = iPotentialIndex;
                            g.CurrentSelection = iPotentialIndexPerPage;
                            g.UpdateHighlight();
                        }
                    }

                    GalleryItem it = g.GalleryItems[g.currentIndex];
                    if (g.bigPic)
                    {
                        g.SetTitle(it.TextureDictionary, it.TextureName, GalleryState.LOADED);
                    }

                    if (it.Blip != null)
                    {
                        _pause._pause.CallFunction("SET_GALLERY_PANEL_DESCRIPTION", "");
                        _pause._pause.CallFunction("SET_GALLERY_PANEL_HIDDEN", true);
                        g.Minimap.Enabled = true;
                        g.Minimap.RefreshMapPosition(new Vector2(it.Blip.Position.X, it.Blip.Position.Y));
                    }
                    else if (!string.IsNullOrEmpty(it.RightPanelDescription))
                    {
                        AddTextEntry("gallerytab_desc", it.RightPanelDescription);
                        _pause._pause.CallFunction("SET_GALLERY_PANEL_HIDDEN", false);
                        BeginScaleformMovieMethod(_pause._pause.Handle, "SET_GALLERY_PANEL_DESCRIPTION");
                        BeginTextCommandScaleformString("gallerytab_desc");
                        EndTextCommandScaleformString_2();
                        EndScaleformMovieMethod();
                    }
                    else
                    {
                        _pause._pause.CallFunction("SET_GALLERY_PANEL_DESCRIPTION", "");
                        g.Minimap.Enabled = false;
                        _pause._pause.CallFunction("SET_GALLERY_PANEL_HIDDEN", true);
                    }
                    g.IndexChanged();
                    return;
                }
            }

            int retVal = await _pause._pause.CallFunctionReturnValueInt("SET_INPUT_EVENT", 11);
            switch (FocusLevel)
            {
                case 0:
                    ClearPedInPauseMenu();
                    //_pause.HeaderGoRight();
                    if (Tabs[Index] is SubmenuTab)
                    {
                        Tabs[Index].LeftItemList[LeftItemIndex].Selected = false;
                    }
                    Index++;
                    if (Tabs[Index] is PlayerListTab _plTab)
                    {
                        if (_plTab.listCol.Any(x => x.Type == "settings") && _plTab.SettingsColumn != null && _plTab.SettingsColumn.Items.Count > 0)
                        {
                            UIMenuItem item = _plTab.SettingsColumn.Items[_plTab.SettingsColumn.CurrentSelection];
                            if (item is not UIMenuListItem && item is not UIMenuSliderItem && item is not UIMenuProgressItem)
                            {
                                item.Selected = false;
                            }
                        }
                        if (_plTab.listCol.Any(x => x.Type == "missions") && _plTab.MissionsColumn != null && _plTab.MissionsColumn.Items.Count > 0)
                            _plTab.MissionsColumn.Items[_plTab.MissionsColumn.CurrentSelection].Selected = false;
                        if (_plTab.listCol.Any(x => x.Type == "store") && _plTab.StoreColumn != null && _plTab.StoreColumn.Items.Count > 0)
                            _plTab.StoreColumn.Items[_plTab.StoreColumn.CurrentSelection].Selected = false;
                        if (_plTab.listCol.Any(x => x.Type == "players"))
                        {
                            _plTab.PlayersColumn.Items[_plTab.PlayersColumn.CurrentSelection].Selected = false;
                            if (_plTab.listCol[0].Type == "players" || _plTab.PlayersColumn.Items[_plTab.PlayersColumn.CurrentSelection].KeepPanelVisible)
                            {
                                if (_plTab.PlayersColumn.Items[_plTab.PlayersColumn.CurrentSelection].ClonePed != null)
                                    _plTab.PlayersColumn.Items[_plTab.PlayersColumn.CurrentSelection].CreateClonedPed();
                                else
                                    ClearPedInPauseMenu();
                            }
                            else
                                ClearPedInPauseMenu();
                        }
                        else ClearPedInPauseMenu();
                    }
                    break;
                case 1:
                    {
                        if (Tabs[Index] is PlayerListTab plTab)
                        {
                            switch (plTab.listCol[plTab.Focus].Type)
                            {
                                case "settings":
                                    {
                                        UIMenuItem item = plTab.SettingsColumn.Items[plTab.SettingsColumn.CurrentSelection];
                                        if (!item.Enabled)
                                        {
                                            if (plTab._newStyle)
                                            {
                                                plTab.SettingsColumn.Items[plTab.SettingsColumn.CurrentSelection].Selected = false;
                                                plTab.updateFocus(plTab.Focus + 1);
                                            }
                                            else
                                            {
                                                Game.PlaySound("ERROR", "HUD_FRONTEND_DEFAULT_SOUNDSET");
                                            }
                                            return;
                                        }

                                        if (item is UIMenuListItem it)
                                        {
                                            it.Index = retVal;
                                            //ListChange(it, it.Index);
                                            it.ListChangedTrigger(it.Index);
                                        }
                                        else if (item is UIMenuSliderItem slit)
                                        {
                                            slit.Value = retVal;
                                            slit.SliderChanged(slit.Value);
                                            //SliderChange(it, it.Value);
                                        }
                                        else if (item is UIMenuProgressItem prit)
                                        {
                                            prit.Value = retVal;
                                            prit.ProgressChanged(prit.Value);
                                            //ProgressChange(it, it.Value);
                                        }
                                        else
                                        {
                                            if (plTab._newStyle)
                                            {
                                                plTab.SettingsColumn.Items[plTab.SettingsColumn.CurrentSelection].Selected = false;
                                                plTab.updateFocus(plTab.Focus + 1);
                                            }
                                        }
                                    }
                                    break;
                                case "missions":
                                    if (plTab._newStyle)
                                    {
                                        plTab.MissionsColumn.Items[plTab.MissionsColumn.CurrentSelection].Selected = false;
                                        plTab.updateFocus(plTab.Focus + 1);
                                    }
                                    break;
                                case "store":
                                    if (plTab._newStyle)
                                    {
                                        plTab.StoreColumn.Items[plTab.StoreColumn.CurrentSelection].Selected = false;
                                        plTab.updateFocus(plTab.Focus + 1);
                                    }
                                    break;
                                case "panel":
                                    plTab.updateFocus(plTab.Focus + 1);
                                    break;
                                case "players":
                                    if (plTab._newStyle)
                                    {
                                        plTab.PlayersColumn.Items[plTab.PlayersColumn.CurrentSelection].Selected = false;
                                        plTab.updateFocus(plTab.Focus + 1);
                                    }
                                    break;
                            }
                        }
                        break;
                    }
                case 2:
                    {
                        SettingsItem rightItem = Tabs[Index].LeftItemList[LeftItemIndex].ItemList[RightItemIndex] as SettingsItem;
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
                        break;
                    }
            }

        }

        private bool firstTick = true;
        private int eventType = 0;
        private int itemId = 0;
        private int context = 0;
        private int unused = 0;
        private Tuple<string, string> headerPicture = new Tuple<string, string>("CHAR_DEFAULT", "CHAR_DEFAULT");

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

            bool successHeader = GetScaleformMovieCursorSelection(Main.PauseMenu._header.Handle, ref eventType, ref context, ref itemId, ref unused);
            if (successHeader)
            {
                switch (eventType)
                {
                    case 5: // on click pressed
                        switch (context)
                        {
                            case -1:
                                //_pause.SelectTab(itemId);
                                Index = itemId;
                                FocusLevel = 1;
                                if (Tabs[Index] is PlayerListTab tab)
                                {
                                    if (tab.listCol.Any(x => x.Type == "players"))
                                    {
                                        if (tab.PlayersColumn.Items[tab.PlayersColumn.CurrentSelection].ClonePed != null)
                                            tab.PlayersColumn.Items[tab.PlayersColumn.CurrentSelection].CreateClonedPed();
                                        else
                                            ClearPedInPauseMenu();
                                    }
                                    else
                                        ClearPedInPauseMenu();
                                }
                                else
                                    ClearPedInPauseMenu();
                                if (Tabs[Index] is GalleryTab g)
                                {
                                    GalleryItem it = g.GalleryItems[g.currentIndex];
                                    if (it.Blip != null)
                                    {
                                        _pause._pause.CallFunction("SET_GALLERY_PANEL_DESCRIPTION", "");
                                        _pause._pause.CallFunction("SET_GALLERY_PANEL_HIDDEN", true);
                                        g.Minimap.Enabled = true;
                                        g.Minimap.RefreshMapPosition(new Vector2(it.Blip.Position.X, it.Blip.Position.Y));
                                    }
                                    else if (!string.IsNullOrEmpty(it.RightPanelDescription))
                                    {
                                        AddTextEntry("gallerytab_desc", it.RightPanelDescription);
                                        _pause._pause.CallFunction("SET_GALLERY_PANEL_HIDDEN", false);
                                        BeginScaleformMovieMethod(_pause._pause.Handle, "SET_GALLERY_PANEL_DESCRIPTION");
                                        BeginTextCommandScaleformString("gallerytab_desc");
                                        EndTextCommandScaleformString_2();
                                        EndScaleformMovieMethod();
                                    }
                                    else
                                    {
                                        _pause._pause.CallFunction("SET_GALLERY_PANEL_DESCRIPTION", "");
                                        g.Minimap.Enabled = false;
                                        _pause._pause.CallFunction("SET_GALLERY_PANEL_HIDDEN", true);
                                    }
                                    g.UpdateHighlight();
                                    g.UpdatePage();
                                }
                                Game.PlaySound("SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET");
                                if (Tabs[Index].LeftItemList.All(x => !x.Enabled)) break;
                                Tabs[Index].LeftItemList[LeftItemIndex].Selected = true;
                                while (!Tabs[Index].LeftItemList[leftItemIndex].Enabled)
                                {
                                    await BaseScript.Delay(0);
                                    LeftItemIndex++;
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
                    case 6:
                        switch (context)
                        {
                            case 1000:
                                if (itemId == -1)
                                    Index--;
                                if (itemId == 1)
                                    Index++;
                                break;
                        }
                        break;
                }
            }

            bool successPause = GetScaleformMovieCursorSelection(Main.PauseMenu._pause.Handle, ref eventType, ref context, ref itemId, ref unused);
            if (successPause)
            {
                switch (eventType)
                {
                    case 5: // on click pressed
                        if (Tabs[Index] is GalleryTab g)
                        {
                            if (FocusLevel == 0)
                                FocusLevel++;
                            else if (FocusLevel == 1)
                            {
                                if (g.CurrentSelection != itemId)
                                {
                                    g.CurrentSelection = itemId;
                                    g.currentIndex = g.CurPage * g.maxItemsPerPage + itemId;
                                    g.IndexChanged();
                                }
                                else
                                {
                                    if (!g.bigPic)
                                    {
                                        g.SetTitle(g.GalleryItems[g.currentIndex].TextureDictionary, g.GalleryItems[g.currentIndex].TextureName, GalleryState.LOADED);
                                        g.ModeChanged();
                                    }
                                    else
                                    {
                                        g.GalleryItems[g.currentIndex].ItemSelected(g, g.GalleryItems[g.currentIndex], g.currentIndex, g.CurrentSelection);
                                        g.ItemSelected();
                                    }
                                }
                            }
                            GalleryItem it = g.GalleryItems[g.currentIndex];
                            if (it.Blip != null)
                            {
                                _pause._pause.CallFunction("SET_GALLERY_PANEL_DESCRIPTION", "");
                                _pause._pause.CallFunction("SET_GALLERY_PANEL_HIDDEN", true);
                                g.Minimap.Enabled = true;
                                g.Minimap.RefreshMapPosition(new Vector2(it.Blip.Position.X, it.Blip.Position.Y));
                            }
                            else if (!string.IsNullOrEmpty(it.RightPanelDescription))
                            {
                                g.Minimap.Enabled = false;
                                AddTextEntry("gallerytab_desc", it.RightPanelDescription);
                                _pause._pause.CallFunction("SET_GALLERY_PANEL_HIDDEN", false);
                                BeginScaleformMovieMethod(_pause._pause.Handle, "SET_GALLERY_PANEL_DESCRIPTION");
                                BeginTextCommandScaleformString("gallerytab_desc");
                                EndTextCommandScaleformString_2();
                                EndScaleformMovieMethod();
                            }
                            else
                            {
                                _pause._pause.CallFunction("SET_GALLERY_PANEL_DESCRIPTION", "");
                                g.Minimap.Enabled = false;
                                _pause._pause.CallFunction("SET_GALLERY_PANEL_HIDDEN", true);
                            }
                            g.UpdateHighlight();
                            g.UpdatePage();
                            return;
                        }
                        else if (FocusLevel == 1 && Tabs[Index] is PlayerListTab tab)
                        {
                            int foc = tab.Focus;
                            int curSel = 0;
                            switch (tab.listCol[foc].Type)
                            {
                                case "settings":
                                    curSel = tab.SettingsColumn.CurrentSelection;
                                    if (tab._newStyle)
                                        tab.SettingsColumn.Items[tab.SettingsColumn.CurrentSelection].Selected = false;
                                    break;
                                case "players":
                                    curSel = tab.PlayersColumn.CurrentSelection;
                                    if (tab._newStyle)
                                        tab.PlayersColumn.Items[tab.PlayersColumn.CurrentSelection].Selected = false;
                                    break;
                                case "missions":
                                    curSel = tab.MissionsColumn.CurrentSelection;
                                    if (tab._newStyle)
                                        tab.MissionsColumn.Items[tab.MissionsColumn.CurrentSelection].Selected = false;
                                    break;
                                case "store":
                                    curSel = tab.StoreColumn.CurrentSelection;
                                    if (tab._newStyle)
                                        tab.StoreColumn.Items[tab.StoreColumn.CurrentSelection].Selected = false;
                                    break;
                            }
                            tab.updateFocus(context, true);
                            int index = tab.listCol[tab.Focus].Pagination.GetMenuIndexFromScaleformIndex(itemId);
                            switch (tab.listCol[tab.Focus].Type)
                            {
                                case "settings":
                                    tab.SettingsColumn.CurrentSelection = index;
                                    break;
                                case "players":
                                    tab.PlayersColumn.CurrentSelection = index;
                                    break;
                                case "missions":
                                    tab.MissionsColumn.CurrentSelection = index;
                                    break;
                                case "store":
                                    tab.StoreColumn.CurrentSelection = index;
                                    break;
                            }
                            if (curSel != index) Game.PlaySound(AUDIO_UPDOWN, AUDIO_LIBRARY);

                            if (foc == tab.Focus && curSel == index)
                                Select(false);
                            return;
                        }
                        switch (context)
                        {
                            case 0: // going from unfocused to focused or playerListTab player selected
                                FocusLevel = 1;
                                if (Tabs[Index] is not PlayerListTab)
                                {
                                    if (Tabs[Index].LeftItemList.All(x => !x.Enabled)) break;
                                    Tabs[Index].LeftItemList[LeftItemIndex].Selected = true;
                                    while (!Tabs[Index].LeftItemList[leftItemIndex].Enabled)
                                    {
                                        await BaseScript.Delay(0);
                                        LeftItemIndex++;
                                        _pause._pause.CallFunction("SELECT_LEFT_ITEM_INDEX", leftItemIndex);
                                    }
                                }
                                else
                                {
                                    PlayerListTab _tab = Tabs[Index] as PlayerListTab;
                                    switch (_tab.listCol[_tab.Focus].Type)
                                    {
                                        case "settings":
                                            _tab.SettingsColumn.Items[_tab.SettingsColumn.CurrentSelection].Selected = true;
                                            break;
                                        case "players":
                                            _tab.PlayersColumn.Items[_tab.PlayersColumn.CurrentSelection].Selected = true;
                                            if (_tab.PlayersColumn.Items[_tab.PlayersColumn.CurrentSelection].ClonePed != null)
                                                _tab.PlayersColumn.Items[_tab.PlayersColumn.CurrentSelection].CreateClonedPed();
                                            break;
                                        case "missions":
                                            _tab.MissionsColumn.Items[_tab.MissionsColumn.CurrentSelection].Selected = true;
                                            break;
                                        case "store":
                                            _tab.StoreColumn.Items[_tab.StoreColumn.CurrentSelection].Selected = true;
                                            break;
                                    }
                                    if (_tab.listCol.Any(x => x.Type == "players"))
                                        SetPauseMenuPedLighting(FocusLevel != 0);
                                }
                                break;
                            case 1: // left item in subitem tab pressed or playerListTab item selected
                                if (Tabs[Index] is not PlayerListTab)
                                {
                                    if (FocusLevel != 1)
                                    {
                                        if (!Tabs[Index].LeftItemList[LeftItemIndex].Enabled)
                                        {
                                            Game.PlaySound(AUDIO_ERROR, AUDIO_LIBRARY);
                                            return;
                                        }
                                        FocusLevel = 1;
                                    }
                                    else if (focusLevel == 1)
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
                                    }
                                    LeftItemIndex = itemId;
                                    _pause._pause.CallFunction("SELECT_LEFT_ITEM_INDEX", itemId);
                                    Tabs[Index].LeftItemList[LeftItemIndex].Activated();
                                    SendPauseMenuLeftItemSelect();
                                }
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
                                        SettingsItem item = (Tabs[Index].LeftItemList[leftItemIndex].ItemList[RightItemIndex] as SettingsItem);
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
                    case 0: // dragged outside
                    case 8: // on not hover
                        {
                            if (Tabs[Index] is PlayerListTab plTab)
                            {
                                if (FocusLevel == 1)
                                {
                                    int index = plTab.listCol[context].Pagination.GetMenuIndexFromScaleformIndex(itemId);
                                    switch (plTab.listCol[context].Type)
                                    {
                                        case "settings":
                                            plTab.SettingsColumn.Items[index].Hovered = false;
                                            break;
                                        case "players":
                                            plTab.PlayersColumn.Items[index].Hovered = false;
                                            break;
                                        case "missions":
                                            plTab.MissionsColumn.Items[index].Hovered = false;
                                            break;
                                        case "store":
                                            plTab.StoreColumn.Items[index].Hovered = false;
                                            break;
                                    }
                                    return;
                                }
                            }

                            switch (context)
                            {
                                case 1: // left item in subitem tab pressed
                                    Tabs[Index].LeftItemList[itemId].Hovered = false;
                                    break;
                                case 2:// right settings item in subitem tab pressed
                                    BasicTabItem curIt = Tabs[Index].LeftItemList[LeftItemIndex].ItemList[itemId];
                                    if (curIt is SettingsItem)
                                    {
                                        (curIt as SettingsItem).Hovered = false;
                                    }
                                    break;
                            }
                        }
                        break;
                    case 9: // on hovered
                        {
                            if (Tabs[Index] is PlayerListTab plTab)
                            {
                                if (FocusLevel == 1)
                                {
                                    int index = plTab.listCol[context].Pagination.GetMenuIndexFromScaleformIndex(itemId);
                                    switch (plTab.listCol[context].Type)
                                    {
                                        case "settings":
                                            plTab.SettingsColumn.Items[index].Hovered = true;
                                            break;
                                        case "players":
                                            plTab.PlayersColumn.Items[index].Hovered = true;
                                            break;
                                        case "missions":
                                            plTab.MissionsColumn.Items[index].Hovered = true;
                                            break;
                                        case "store":
                                            plTab.StoreColumn.Items[index].Hovered = true;
                                            break;
                                    }
                                    return;
                                }
                            }

                            switch (context)
                            {
                                case 1: // left item in subitem tab pressed
                                    foreach (TabLeftItem item in Tabs[Index].LeftItemList)
                                        item.Hovered = Tabs[Index].LeftItemList.IndexOf(item) == itemId && item.Enabled;
                                    break;
                                case 2:// right settings item in subitem tab pressed
                                    foreach (BasicTabItem curIt in Tabs[Index].LeftItemList[LeftItemIndex].ItemList)
                                    {
                                        int idx = Tabs[Index].LeftItemList[LeftItemIndex].ItemList.IndexOf(curIt);
                                        if (curIt is SettingsItem)
                                        {
                                            (curIt as SettingsItem).Hovered = itemId == idx && (curIt as SettingsItem).Enabled;
                                        }
                                    }
                                    break;
                            }
                        }
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
            }

            if (!Visible || TemporarilyHidden || isBuilding) return;

            if (Game.IsControlJustPressed(2, Control.PhoneUp))
                GoUp();
            else if (Game.IsControlJustPressed(2, Control.PhoneDown))
                GoDown();
            else if (Game.IsControlJustPressed(2, Control.PhoneLeft))
                GoLeft();
            else if (Game.IsControlJustPressed(2, Control.PhoneRight))
                GoRight();
            else if (Game.IsControlJustPressed(2, Control.FrontendLb) || (Game.IsControlJustPressed(2, (Control)192) && Game.IsControlPressed(2, Control.Sprint) && IsUsingKeyboard(2)))
            {
                if (FocusLevel > 0) GoBack();
                GoLeft();
            }
            else if (Game.IsControlJustPressed(2, Control.FrontendRb) || (Game.IsControlJustPressed(2, (Control)192) && IsUsingKeyboard(2)))
            {
                if (FocusLevel > 0) GoBack();
                GoRight();
            }
            else if (Game.IsControlJustPressed(2, Control.FrontendAccept))
            {
                Select(true);
            }
            else if (Game.IsControlJustReleased(2, Control.PhoneCancel))
                GoBack();

            if (Game.IsControlJustPressed(1, Control.CursorScrollUp))
                _pause.SendScrollEvent(-1);
            else if (Game.IsControlJustPressed(1, Control.CursorScrollDown))
                _pause.SendScrollEvent(1);

            if (Game.IsControlPressed(2, Control.LookUpOnly) && !IsUsingKeyboard(2))
            {
                if (Main.GameTime - _timer > 175)
                {
                    _pause.SendScrollEvent(-1);
                    _timer = Main.GameTime;
                }
            }
            else if (Game.IsControlPressed(2, Control.LookDownOnly) && !IsUsingKeyboard(2))
            {
                if (Main.GameTime - _timer > 175)
                {
                    _pause.SendScrollEvent(1);
                    _timer = Main.GameTime;
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
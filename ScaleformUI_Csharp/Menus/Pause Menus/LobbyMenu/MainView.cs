using CitizenFX.Core;
using CitizenFX.Core.Native;
using ScaleformUI.Elements;
using ScaleformUI.Menu;
using ScaleformUI.Menus;
using ScaleformUI.PauseMenu;
using ScaleformUI.PauseMenus;
using ScaleformUI.PauseMenus.Elements;
using ScaleformUI.PauseMenus.Elements.Columns;
using ScaleformUI.PauseMenus.Elements.Items;
using ScaleformUI.PauseMenus.Elements.Panels;
using ScaleformUI.Scaleforms;
using static CitizenFX.Core.Native.API;

namespace ScaleformUI.LobbyMenu
{
    public delegate void LobbyMenuOpenEvent(MainView menu);
    public delegate void LobbyMenuCloseEvent(MainView menu);

    public class MainView : TabView 
    {
        public event LobbyMenuOpenEvent OnLobbyMenuOpen;
        public event LobbyMenuCloseEvent OnLobbyMenuClose;
        public bool ShowStoreBackground { internal get; set; }
        public int StoreBackgroundAnimationSpeed { internal get; set; } = 240; // should be expressed in ms
        public MinimapPanel Minimap => coronaTab.Minimap;

        public new int Index;

        public MainView(string title) : base(title)
        {
            IsCorona = true;
            coronaTab = new PlayerListTab("corona for mainview", SColor.HUD_None);
            AddTab(coronaTab);
            InstructionalButtons = new()
            {
                new InstructionalButton(Control.PhoneSelect, UIMenu._selectTextLocalized),
                new InstructionalButton(Control.PhoneCancel, UIMenu._backTextLocalized),
            };
        }
        public MainView(string title, string subtitle) : base(title, subtitle)
        {
            IsCorona = true;
            coronaTab = new PlayerListTab("corona for mainview", SColor.HUD_None);
            AddTab(coronaTab);
            InstructionalButtons = new()
            {
                new InstructionalButton(Control.PhoneSelect, UIMenu._selectTextLocalized),
                new InstructionalButton(Control.PhoneCancel, UIMenu._backTextLocalized),
            };
        }

        public MainView(string title, string subtitle, string sideTop, string sideMid, string sideBot) : base(title, subtitle, sideTop, sideMid, sideBot)
        {
            IsCorona = true;
            coronaTab = new PlayerListTab("corona for mainview", SColor.HUD_None);
            AddTab(coronaTab);
            InstructionalButtons = new()
            {
                new InstructionalButton(Control.PhoneSelect, UIMenu._selectTextLocalized),
                new InstructionalButton(Control.PhoneCancel, UIMenu._backTextLocalized),
            };
        }

        public void SelectColumn(int column) => coronaTab.SwitchColumn(column);
        public void SelectColumn(PM_COLUMNS column) => coronaTab.SwitchColumn(column);

        public void SetupLeftColumn(PM_Column column) => coronaTab.SetupLeftColumn(column);
        public void SetupCenterColumn(PM_Column column) => coronaTab.SetupCenterColumn(column);
        public void SetupRightColumn(PM_Column column) => coronaTab.SetupRightColumn(column);

        internal new void SendPauseMenuOpen()
        {
            OnLobbyMenuOpen?.Invoke(this);
        }

        internal new void SendPauseMenuClose()
        {
            OnLobbyMenuClose?.Invoke(this);
        }
    }
    //{
    //    // Button delay

    //    private bool isBuilding = false;
    //    public bool ForceFirstSelectionOnFocus { get; set; }
    //    private int time;
    //    private bool _firstDrawTick = true;
    //    private int times;
    //    private int delay = 150;
    //    internal bool _newStyle;
    //    public SettingsListColumn SettingsColumn { get; private set; }
    //    public MissionsListColumn MissionsColumn { get; private set; }
    //    public PlayerListColumn PlayersColumn { get; private set; }
    //    public StoreListColumn StoreColumn { get; private set; }
    //    public MissionDetailsPanel MissionPanel { get; private set; }
    //    public MinimapPanel Minimap { get; private set; }
    //    private int timer = 100;
    //    public int FocusLevel
    //    {
    //        get => focusLevel;
    //    }

    //    public bool TemporarilyHidden { get; set; }
    //    public bool HideTabs { get; set; }
    //    public bool DisplayHeader = true;

    //    public MainView(string title, bool newStyle = true) : this(title, "", "", "", "", newStyle)
    //    {
    //    }
    //    public MainView(string title, string subtitle, bool newStyle = true) : this(title, subtitle, "", "", "", newStyle)
    //    {
    //    }

    //    public MainView(string title, string subtitle, string sideTop, string sideMid, string sideBot, bool newStyle = true)
    //    {
    //        Title = title;
    //        SubTitle = subtitle;
    //        SideStringTop = sideTop;
    //        SideStringMiddle = sideMid;
    //        SideStringBottom = sideBot;
    //        Index = 0;
    //        TemporarilyHidden = false;
    //        InstructionalButtons = new()
    //        {
    //            new InstructionalButton(Control.PhoneSelect, UIMenu._selectTextLocalized),
    //            new InstructionalButton(Control.PhoneCancel, UIMenu._backTextLocalized),
    //        };
    //        _newStyle = newStyle;
    //        _pause = Main.PauseMenu;
    //        Minimap = new MinimapPanel(null);
    //    }

    //    public override bool Visible
    //    {
    //        get { return _visible; }
    //        set
    //        {
    //            Game.IsPaused = value;
    //            if (value)
    //            {
    //                ActivateFrontendMenu((uint)Game.GenerateHash("FE_MENU_VERSION_CORONA"), true, 0);
    //                //BuildPauseMenu();
    //                SendPauseMenuOpen();
    //                doScreenBlur();
    //                Main.InstructionalButtons.SetInstructionalButtons(InstructionalButtons);
    //                SetPlayerControl(Game.Player.Handle, false, 0);
    //                _firstDrawTick = true;
    //                MenuHandler.currentBase = this;
    //            }
    //            else
    //            {
    //                Minimap?.Dispose();
    //                _pause.Dispose();
    //                AnimpostfxStop("PauseMenuIn");
    //                AnimpostfxPlay("PauseMenuOut", 800, false);
    //                SendPauseMenuClose();
    //                SetPlayerControl(Game.Player.Handle, true, 0);
    //                MenuHandler.currentBase = null;
    //                ActivateFrontendMenu((uint)Game.GenerateHash("FE_MENU_VERSION_CORONA"), false, 0);
    //                Main.InstructionalButtons.ClearButtonList();
    //            }
    //            base.Visible = value;
    //            _visible = value;
    //            _pause.Visible = value;
    //        }
    //    }

    //    private async void doScreenBlur()
    //    {
    //        while (AnimpostfxIsRunning("PauseMenuOut"))
    //        {
    //            await BaseScript.Delay(0);
    //            AnimpostfxStop("PauseMenuOut");
    //        }
    //        AnimpostfxPlay("PauseMenuIn", 800, true);
    //    }

    //    public int Index;
    //    private bool _visible;
    //    private int focusLevel;

    //    public void SelectColumn(Column column)
    //    {
    //        int f = column.Order;
    //        SelectColumn(f);
    //    }
    //    public void SelectColumn(int column)
    //    {
    //        int f = column;
    //        if (f < 0)
    //            f = listCol.Count - 1;
    //        else if (f > listCol.Count - 1)
    //            f = 0;
    //        //updateFocus(f);
    //    }

    //    //private async void updateFocus(int value, bool isMouse = false)
    //    //{
    //    //    bool goingLeft = value < focusLevel;
    //    //    int f = value;
    //    //    if (f < 0)
    //    //        f = listCol.Count - 1;
    //    //    else if (f > listCol.Count - 1)
    //    //        f = 0;
    //    //    if (listCol[f].Type != "players")
    //    //    {
    //    //        if (PlayersColumn != null && PlayersColumn.Items.Count > 0 && !PlayersColumn.Items[PlayersColumn.CurrentSelection].KeepPanelVisible)
    //    //            API.ClearPedInPauseMenu();
    //    //    }
    //    //    focusLevel = f;
    //    //    if (listCol[focusLevel].Type == "panel" || listCol[focusLevel].Type == "minimap")
    //    //    {
    //    //        if (goingLeft)
    //    //            updateFocus(focusLevel - 1, isMouse);
    //    //        else
    //    //            updateFocus(focusLevel + 1, isMouse);
    //    //        return;
    //    //    }
    //    //    if (Visible)
    //    //    {
    //    //        int idx = await _pause._lobby.CallFunctionReturnValueInt("SET_FOCUS", focusLevel);
    //    //        if (!isMouse)
    //    //        {
    //    //            switch (listCol[FocusLevel].Type)
    //    //            {
    //    //                case "players":
    //    //                    PlayersColumn.CurrentSelection = PlayersColumn.Pagination.GetMenuIndexFromScaleformIndex(ForceFirstSelectionOnFocus ? 0 : idx);
    //    //                    if (!goingLeft || _newStyle)
    //    //                        PlayersColumn.IndexChangedEvent();
    //    //                    break;
    //    //                case "settings":
    //    //                    SettingsColumn.CurrentSelection = SettingsColumn.Pagination.GetMenuIndexFromScaleformIndex(ForceFirstSelectionOnFocus ? 0 : idx);
    //    //                    if (!goingLeft || _newStyle)
    //    //                        SettingsColumn.IndexChangedEvent();
    //    //                    break;
    //    //                case "missions":
    //    //                    MissionsColumn.CurrentSelection = MissionsColumn.Pagination.GetMenuIndexFromScaleformIndex(ForceFirstSelectionOnFocus ? 0 : idx);
    //    //                    if (!goingLeft || _newStyle)
    //    //                        MissionsColumn.IndexChangedEvent();
    //    //                    break;
    //    //                case "store":
    //    //                    StoreColumn.CurrentSelection = StoreColumn.Pagination.GetMenuIndexFromScaleformIndex(ForceFirstSelectionOnFocus ? 0 : idx);
    //    //                    if (!goingLeft || _newStyle)
    //    //                        StoreColumn.IndexChangedEvent();
    //    //                    break;
    //    //            }
    //    //        }
    //    //    }
    //    //}

    //    //public void SetUpColumns(List<Column> columns)
    //    //{
    //    //    if (columns.Count > 3)
    //    //        throw new Exception("You must have 3 columns!");
    //    //    if (columns.Count == 3 && columns[2] is PlayerListColumn)
    //    //        throw new Exception("For panel designs reasons, you can't have Players list in 3rd column!");

    //    //    listCol = columns;
    //    //    foreach (Column col in columns)
    //    //    {
    //    //        switch (col)
    //    //        {
    //    //            case SettingsListColumn:
    //    //                SettingsColumn = (SettingsListColumn)col;
    //    //                SettingsColumn.Parent = this;
    //    //                SettingsColumn.Order = columns.IndexOf(col);
    //    //                break;
    //    //            case PlayerListColumn:
    //    //                PlayersColumn = (PlayerListColumn)col;
    //    //                PlayersColumn.Parent = this;
    //    //                PlayersColumn.Order = columns.IndexOf(col);
    //    //                break;
    //    //            case MissionsListColumn:
    //    //                MissionsColumn = (MissionsListColumn)col;
    //    //                MissionsColumn.Parent = this;
    //    //                MissionsColumn.Order = columns.IndexOf(col);
    //    //                break;
    //    //            case StoreListColumn:
    //    //                StoreColumn = (StoreListColumn)col;
    //    //                StoreColumn.Parent = this;
    //    //                StoreColumn.Order = columns.IndexOf(col);
    //    //                break;
    //    //            case MissionDetailsPanel:
    //    //                MissionPanel = (MissionDetailsPanel)col;
    //    //                MissionPanel.Parent = this;
    //    //                MissionPanel.Order = columns.IndexOf(col);
    //    //                break;
    //    //        }
    //    //    }
    //    //}

    //    public void ShowHeader()
    //    {
    //        if (String.IsNullOrEmpty(SubTitle) || String.IsNullOrWhiteSpace(SubTitle))
    //            _pause.SetHeaderTitle(Title);
    //        else
    //        {
    //            _pause.ShiftCoronaDescription(true, false);
    //            _pause.SetHeaderTitle(Title, SubTitle);
    //        }

    //        if (HeaderPicture != null && !string.IsNullOrEmpty(HeaderPicture.Item1) && !string.IsNullOrEmpty(HeaderPicture.Item2))
    //            _pause.SetHeaderCharImg(HeaderPicture.Item1, HeaderPicture.Item2, true);
    //        else
    //            _pause.SetHeaderCharImg("CHAR_DEFAULT", "CHAR_DEFAULT", true);

    //        if (CrewPicture != null)
    //            _pause.SetHeaderSecondaryImg(CrewPicture.Item1, CrewPicture.Item2, true);
    //        _pause.SetHeaderDetails(SideStringTop, SideStringMiddle, SideStringBottom);
    //        _pause.AddLobbyMenuTab(listCol[0].Label, 2, listCol[0].Color);
    //        _pause.AddLobbyMenuTab(listCol[1].Label, 2, listCol[1].Color);
    //        _pause.AddLobbyMenuTab(listCol[2].Label, 2, listCol[2].Color);
    //        _pause._header.CallFunction("SET_ALL_HIGHLIGHTS", true, (int)HudColor.HUD_COLOUR_PAUSE_BG);
    //        _pause._header.CallFunction("ENABLE_DYNAMIC_WIDTH", false);

    //        _loaded = true;
    //    }

    //    private bool canBuild = true;
    //    //public async void BuildPauseMenu()
    //    //{
    //    //    isBuilding = true;
    //    //    ShowHeader();
    //    //    _pause.BGEnabled = ShowStoreBackground;
    //    //    _pause._pauseBG.CallFunction("ANIMATE_BACKGROUND", StoreBackgroundAnimationSpeed);
    //    //    switch (listCol.Count)
    //    //    {
    //    //        case 1:
    //    //            _pause._lobby.CallFunction("CREATE_MENU", listCol[0].Type);
    //    //            _pause._lobby.CallFunction("SET_COLUMN_MAXITEMS", 0, listCol[0]._maxItems);
    //    //            break;
    //    //        case 2:
    //    //            _pause._lobby.CallFunction("CREATE_MENU", listCol[0].Type, listCol[1].Type);
    //    //            _pause._lobby.CallFunction("SET_COLUMN_MAXITEMS", 0, listCol[0]._maxItems);
    //    //            _pause._lobby.CallFunction("SET_COLUMN_MAXITEMS", 1, listCol[1]._maxItems);
    //    //            break;
    //    //        case 3:
    //    //            _pause._lobby.CallFunction("CREATE_MENU", listCol[0].Type, listCol[1].Type, listCol[2].Type);
    //    //            _pause._lobby.CallFunction("SET_COLUMN_MAXITEMS", 0, listCol[0]._maxItems);
    //    //            _pause._lobby.CallFunction("SET_COLUMN_MAXITEMS", 1, listCol[1]._maxItems);
    //    //            _pause._lobby.CallFunction("SET_COLUMN_MAXITEMS", 2, listCol[2]._maxItems);
    //    //            break;
    //    //    }
    //    //    _pause._lobby.CallFunction("SET_NEWSTYLE", _newStyle);
    //    //    if (listCol.Any(x => x is PlayerListColumn))
    //    //        buildPlayers();

    //    //    if (listCol.Any(x => x is SettingsListColumn))
    //    //        buildSettings();

    //    //    if (listCol.Any(x => x is MissionsListColumn))
    //    //        buildMissions();

    //    //    if (listCol.Any(x => x is StoreListColumn))
    //    //        buildStore();

    //    //    if (listCol.Any(x => x is MissionDetailsPanel))
    //    //    {
    //    //        _pause._lobby.CallFunction("ADD_MISSION_PANEL_PICTURE", MissionPanel.TextureDict, MissionPanel.TextureName);
    //    //        _pause._lobby.CallFunction("SET_MISSION_PANEL_TITLE", MissionPanel.Title);
    //    //        if (MissionPanel.Items.Count > 0)
    //    //        {
    //    //            foreach (UIFreemodeDetailsItem item in MissionPanel.Items)
    //    //            {
    //    //                _pause._lobby.CallFunction("ADD_MISSION_PANEL_ITEM", item.Type, item.TextLeft, item.TextRight, (int)item.Icon, item.IconColor, item.Tick, item._labelFont.FontName, item._labelFont.FontID, item._rightLabelFont.FontName, item._rightLabelFont.FontID);
    //    //            }
    //    //        }
    //    //    }

    //    //    _pause._lobby.CallFunction("LOAD_MENU");
    //    //    while ((SettingsColumn != null && SettingsColumn.isBuilding) || (PlayersColumn != null && PlayersColumn.isBuilding) || (MissionsColumn != null && MissionsColumn.isBuilding)) await BaseScript.Delay(0);

    //    //    isBuilding = false;
    //    //}

    //    private bool controller = false;
    //    public override void Draw()
    //    {
    //        if (!Visible || TemporarilyHidden || isBuilding) return;
    //        Minimap.MaintainMap();
    //        base.Draw();
    //        _pause.Draw(true);
    //    }

    //    private int eventType = 0;
    //    private int itemId = 0;
    //    private int context = 0;
    //    private int unused = 0;
    //    private bool cursorPressed;
    //    public override async void ProcessMouse()
    //    {
    //        if (!IsInputDisabled(2))
    //        {
    //            return;
    //        }
    //        SetMouseCursorActiveThisFrame();
    //        SetInputExclusive(2, 239);
    //        SetInputExclusive(2, 240);
    //        SetInputExclusive(2, 237);
    //        SetInputExclusive(2, 238);

    //        //bool success = GetScaleformMovieCursorSelection(_pause._lobby.Handle, ref eventType, ref context, ref itemId, ref unused);
    //        //if (success)
    //        //{
    //        //    switch (eventType)
    //        //    {
    //        //        case 5:
    //        //            {
    //        //                int foc = FocusLevel;
    //        //                int curSel = 0;
    //        //                switch (listCol[foc].Type)
    //        //                {
    //        //                    case "settings":
    //        //                        curSel = SettingsColumn.CurrentSelection;
    //        //                        if (_newStyle)
    //        //                            SettingsColumn.Items[SettingsColumn.CurrentSelection].Selected = false;
    //        //                        break;
    //        //                    case "players":
    //        //                        curSel = PlayersColumn.CurrentSelection;
    //        //                        if (_newStyle)
    //        //                            PlayersColumn.Items[PlayersColumn.CurrentSelection].Selected = false;
    //        //                        break;
    //        //                    case "missions":
    //        //                        curSel = MissionsColumn.CurrentSelection;
    //        //                        if (_newStyle)
    //        //                            MissionsColumn.Items[MissionsColumn.CurrentSelection].Selected = false;
    //        //                        break;
    //        //                    case "store":
    //        //                        curSel = StoreColumn.CurrentSelection;
    //        //                        if (_newStyle)
    //        //                            StoreColumn.Items[StoreColumn.CurrentSelection].Selected = false;
    //        //                        break;
    //        //                }
    //        //                updateFocus(context, true);
    //        //                int index = listCol[FocusLevel].Pagination.GetMenuIndexFromScaleformIndex(itemId);
    //        //                switch (listCol[FocusLevel].Type)
    //        //                {
    //        //                    case "settings":
    //        //                        SettingsColumn.CurrentSelection = index;
    //        //                        break;
    //        //                    case "players":
    //        //                        PlayersColumn.CurrentSelection = index;
    //        //                        break;
    //        //                    case "missions":
    //        //                        MissionsColumn.CurrentSelection = index;
    //        //                        break;
    //        //                    case "store":
    //        //                        StoreColumn.CurrentSelection = index;
    //        //                        break;
    //        //                }
    //        //                if (curSel != index) Game.PlaySound(AUDIO_UPDOWN, AUDIO_LIBRARY);

    //        //                if (foc == FocusLevel && curSel == index)
    //        //                    Select();
    //        //            }
    //        //            break;
    //        //        case 8:
    //        //            {
    //        //                int index = listCol[context].Pagination.GetMenuIndexFromScaleformIndex(itemId);
    //        //                switch (listCol[context].Type)
    //        //                {
    //        //                    case "settings":
    //        //                        SettingsColumn.Items[itemId].Hovered = false;
    //        //                        break;
    //        //                    case "players":
    //        //                        PlayersColumn.Items[itemId].Hovered = false;
    //        //                        break;
    //        //                    case "missions":
    //        //                        MissionsColumn.Items[itemId].Hovered = false;
    //        //                        break;
    //        //                    case "store":
    //        //                        StoreColumn.Items[itemId].Hovered = false;
    //        //                        break;
    //        //                }
    //        //            }
    //        //            break;
    //        //        case 9:
    //        //            {
    //        //                int index = listCol[context].Pagination.GetMenuIndexFromScaleformIndex(itemId);
    //        //                switch (listCol[context].Type)
    //        //                {
    //        //                    case "settings":
    //        //                        SettingsColumn.Items[itemId].Hovered = true;
    //        //                        break;
    //        //                    case "players":
    //        //                        PlayersColumn.Items[itemId].Hovered = true;
    //        //                        break;
    //        //                    case "missions":
    //        //                        MissionsColumn.Items[itemId].Hovered = true;
    //        //                        break;
    //        //                    case "store":
    //        //                        StoreColumn.Items[itemId].Hovered = true;
    //        //                        break;
    //        //                }
    //        //            }
    //        //            break;
    //        //    }
    //        //}
    //    }

    //    public override async void ProcessControls()
    //    {
    //        //if (!Visible || TemporarilyHidden) return;
    //        //if (Game.IsControlPressed(2, Control.PhoneUp))
    //        //{
    //        //    if (Main.GameTime - time > delay)
    //        //    {
    //        //        ButtonDelay();
    //        //        GoUp();
    //        //    }
    //        //}
    //        //else if (Game.IsControlPressed(2, Control.PhoneDown))
    //        //{
    //        //    if (Main.GameTime - time > delay)
    //        //    {
    //        //        ButtonDelay();
    //        //        GoDown();
    //        //    }
    //        //}

    //        //else if (Game.IsControlPressed(2, Control.PhoneLeft))
    //        //{
    //        //    if (Main.GameTime - time > delay)
    //        //    {
    //        //        ButtonDelay();
    //        //        GoLeft();
    //        //    }
    //        //}
    //        //else if (Game.IsControlPressed(2, Control.PhoneRight))
    //        //{
    //        //    if (Main.GameTime - time > delay)
    //        //    {
    //        //        ButtonDelay();
    //        //        GoRight();
    //        //    }
    //        //}

    //        //else if (Game.IsControlJustPressed(2, Control.FrontendAccept))
    //        //{
    //        //    Select();
    //        //}

    //        //else if (Game.IsControlJustReleased(2, Control.PhoneCancel))
    //        //{
    //        //    GoBack();
    //        //}

    //        //if (Game.IsControlJustPressed(1, Control.CursorScrollUp))
    //        //{
    //        //    _pause.SendScrollEvent(-1);
    //        //}
    //        //else if (Game.IsControlJustPressed(1, Control.CursorScrollDown))
    //        //{
    //        //    _pause.SendScrollEvent(1);
    //        //}

    //        //// IsControlBeingPressed doesn't run every frame so I had to use this
    //        //if (!Game.IsControlPressed(2, Control.PhoneUp) && !Game.IsControlPressed(2, Control.PhoneDown) && !Game.IsControlPressed(2, Control.PhoneLeft) && !Game.IsControlPressed(2, Control.PhoneRight))
    //        //{
    //        //    times = 0;
    //        //    delay = 150;
    //        //}
    //    }

    //    //public async void Select()
    //    //{
    //    //    switch (listCol[FocusLevel].Type)
    //    //    {
    //    //        case "settings":
    //    //            UIMenuItem item = SettingsColumn.Items[SettingsColumn.CurrentSelection];
    //    //            if (!item.Enabled)
    //    //            {
    //    //                Game.PlaySound(AUDIO_ERROR, AUDIO_LIBRARY);
    //    //                return;
    //    //            }
    //    //            switch (item)
    //    //            {
    //    //                case UIMenuCheckboxItem:
    //    //                    {
    //    //                        UIMenuCheckboxItem it = item as UIMenuCheckboxItem;
    //    //                        it.Checked = !it.Checked;
    //    //                        it.CheckboxEventTrigger();
    //    //                        SettingsColumn.SelectItem();
    //    //                        break;
    //    //                    }

    //    //                case UIMenuListItem:
    //    //                    {
    //    //                        UIMenuListItem it = item as UIMenuListItem;
    //    //                        it.ListSelectedTrigger(it.Index);
    //    //                        SettingsColumn.SelectItem();
    //    //                        break;
    //    //                    }

    //    //                default:
    //    //                    item.ItemActivate(null);
    //    //                    SettingsColumn.SelectItem();
    //    //                    break;
    //    //            }
    //    //            _pause._lobby.CallFunction("SET_INPUT_EVENT", 16);
    //    //            break;
    //    //        case "missions":
    //    //            MissionItem mitem = MissionsColumn.Items[MissionsColumn.CurrentSelection];
    //    //            mitem.ActivateMission(null);
    //    //            MissionsColumn.SelectItem();
    //    //            break;
    //    //        case "store":
    //    //            StoreItem stItem = StoreColumn.Items[StoreColumn.CurrentSelection];
    //    //            stItem.Activate(null);
    //    //            StoreColumn.SelectItem();
    //    //            break;
    //    //        case "players":
    //    //            PlayersColumn.SelectItem();
    //    //            break;
    //    //    }
    //    //}

    //    //public async void GoBack()
    //    //{
    //    //    if (_newStyle)
    //    //    {
    //    //        if (CanPlayerCloseMenu)
    //    //            Visible = false;
    //    //    }
    //    //    else
    //    //    {
    //    //        switch (listCol[FocusLevel].Type)
    //    //        {
    //    //            case "settings":
    //    //                SettingsColumn.Items[SettingsColumn.CurrentSelection].Selected = false;
    //    //                break;
    //    //            case "store":
    //    //                StoreColumn.Items[StoreColumn.CurrentSelection].Selected = false;
    //    //                break;
    //    //            case "players":
    //    //                PlayersColumn.Items[PlayersColumn.CurrentSelection].Selected = false;
    //    //                ClearPedInPauseMenu();
    //    //                break;
    //    //            case "missions":
    //    //                MissionsColumn.Items[MissionsColumn.CurrentSelection].Selected = false;
    //    //                break;
    //    //        }
    //    //        if (FocusLevel == 0)
    //    //        {
    //    //            if (CanPlayerCloseMenu)
    //    //                Visible = false;
    //    //            return;
    //    //        }
    //    //        //updateFocus(FocusLevel - 1);
    //    //    }
    //    //}

    //    //public void GoUp()
    //    //{
    //    //    switch (listCol[FocusLevel].Type)
    //    //    {
    //    //        case "settings":
    //    //            SettingsColumn.GoUp();
    //    //            break;
    //    //        case "missions":
    //    //            MissionsColumn.GoUp();
    //    //            break;
    //    //        case "players":
    //    //            PlayersColumn.GoUp();
    //    //            break;
    //    //        case "store":
    //    //            StoreColumn.GoUp();
    //    //            break;
    //    //    }
    //    //    Game.PlaySound(AUDIO_UPDOWN, AUDIO_LIBRARY);
    //    //}

    //    //public void GoDown()
    //    //{
    //    //    switch (listCol[FocusLevel].Type)
    //    //    {
    //    //        case "settings":
    //    //            SettingsColumn.GoDown();
    //    //            break;
    //    //        case "missions":
    //    //            MissionsColumn.GoDown();
    //    //            break;
    //    //        case "players":
    //    //            PlayersColumn.GoDown();
    //    //            break;
    //    //        case "store":
    //    //            StoreColumn.GoDown();
    //    //            break;
    //    //    }
    //    //    Game.PlaySound(AUDIO_UPDOWN, AUDIO_LIBRARY);
    //    //}

    //    //public async void GoLeft()
    //    //{
    //    //    string result = await _pause._lobby.CallFunctionReturnValueString("SET_INPUT_EVENT", 10);

    //    //    int[] split = result.Split(',').Select(int.Parse).ToArray();

    //    //    if (_newStyle)
    //    //    {
    //    //        if (listCol.Any(x => x.Type == "settings"))
    //    //        {
    //    //            UIMenuItem item = SettingsColumn.Items[SettingsColumn.CurrentSelection];
    //    //            if (item is not UIMenuListItem && item is not UIMenuSliderItem && item is not UIMenuProgressItem)
    //    //            {
    //    //                item.Selected = false;
    //    //            }
    //    //        }
    //    //        if (listCol.Any(x => x.Type == "missions"))
    //    //            MissionsColumn.Items[MissionsColumn.CurrentSelection].Selected = false;
    //    //        if (listCol.Any(x => x.Type == "store"))
    //    //            StoreColumn.Items[StoreColumn.CurrentSelection].Selected = false;
    //    //        if (listCol.Any(x => x.Type == "players"))
    //    //        {
    //    //            PlayersColumn.Items[PlayersColumn.CurrentSelection].Selected = false;
    //    //            if (listCol[0].Type == "players" || PlayersColumn.Items[PlayersColumn.CurrentSelection].KeepPanelVisible)
    //    //            {
    //    //                if (PlayersColumn.Items[PlayersColumn.CurrentSelection].ClonePed != null)
    //    //                {
    //    //                    PlayersColumn.Items[PlayersColumn.CurrentSelection].CreateClonedPed();
    //    //                }
    //    //                else
    //    //                {
    //    //                    ClearPedInPauseMenu();
    //    //                }
    //    //            }
    //    //            else
    //    //            {
    //    //                ClearPedInPauseMenu();
    //    //            }
    //    //        }
    //    //        else
    //    //        {
    //    //            ClearPedInPauseMenu();
    //    //        }
    //    //    }

    //    //    switch (listCol[focusLevel].Type)
    //    //    {
    //    //        case "settings":
    //    //            {
    //    //                UIMenuItem item = SettingsColumn.Items[SettingsColumn.CurrentSelection];
    //    //                if (!item.Enabled)
    //    //                {
    //    //                    if (_newStyle)
    //    //                    {
    //    //                        SettingsColumn.Items[SettingsColumn.CurrentSelection].Selected = false;
    //    //                        //updateFocus(focusLevel - 1);
    //    //                    }
    //    //                    else
    //    //                    {
    //    //                        Game.PlaySound("ERROR", "HUD_FRONTEND_DEFAULT_SOUNDSET");
    //    //                    }
    //    //                    return;
    //    //                }

    //    //                if (item is UIMenuListItem it)
    //    //                {
    //    //                    it.Index = split[2];
    //    //                    //ListChange(it, it.Index);
    //    //                    it.ListChangedTrigger(it.Index);
    //    //                }
    //    //                else if (item is UIMenuSliderItem slit)
    //    //                {
    //    //                    slit.Value = split[2];
    //    //                    slit.SliderChanged(slit.Value);
    //    //                    //SliderChange(it, it.Value);
    //    //                }
    //    //                else if (item is UIMenuProgressItem prit)
    //    //                {
    //    //                    prit.Value = split[2];
    //    //                    prit.ProgressChanged(prit.Value);
    //    //                    //ProgressChange(it, it.Value);
    //    //                }
    //    //                else
    //    //                {
    //    //                    if (_newStyle)
    //    //                    {
    //    //                        SettingsColumn.Items[SettingsColumn.CurrentSelection].Selected = false;
    //    //                        //updateFocus(focusLevel - 1);
    //    //                    }
    //    //                }
    //    //            }
    //    //            break;
    //    //        case "missions":
    //    //            if (_newStyle)
    //    //            {
    //    //                MissionsColumn.Items[MissionsColumn.CurrentSelection].Selected = false;
    //    //                //updateFocus(focusLevel - 1);
    //    //            }
    //    //            break;
    //    //        case "store":
    //    //            if (_newStyle)
    //    //            {
    //    //                StoreColumn.Items[StoreColumn.CurrentSelection].Selected = false;
    //    //                //updateFocus(focusLevel - 1);
    //    //            }
    //    //            break;
    //    //        case "panel":
    //    //            //updateFocus(focusLevel - 1);
    //    //            break;
    //    //        case "minimap":
    //    //            //updateFocus(focusLevel - 1);
    //    //            break;
    //    //        case "players":
    //    //            if (_newStyle)
    //    //            {
    //    //                PlayersColumn.Items[PlayersColumn.CurrentSelection].Selected = false;
    //    //                //updateFocus(focusLevel - 1);
    //    //            }
    //    //            else
    //    //            {
    //    //                if (PlayersColumn.Items[PlayersColumn.CurrentSelection].ClonePed != null)
    //    //                    PlayersColumn.Items[PlayersColumn.CurrentSelection].CreateClonedPed();
    //    //            }
    //    //            break;
    //    //    }
    //    //}

    //    //public async void GoRight()
    //    //{
    //    //    string result = await _pause._lobby.CallFunctionReturnValueString("SET_INPUT_EVENT", 11);

    //    //    int[] split = result.Split(',').Select(int.Parse).ToArray();

    //    //    if (_newStyle)
    //    //    {
    //    //        if (listCol.Any(x => x.Type == "settings"))
    //    //        {
    //    //            UIMenuItem item = SettingsColumn.Items[SettingsColumn.CurrentSelection];
    //    //            if (item is not UIMenuListItem && item is not UIMenuSliderItem && item is not UIMenuProgressItem)
    //    //            {
    //    //                item.Selected = false;
    //    //            }
    //    //        }
    //    //        if (listCol.Any(x => x.Type == "missions"))
    //    //            MissionsColumn.Items[MissionsColumn.CurrentSelection].Selected = false;
    //    //        if (listCol.Any(x => x.Type == "store"))
    //    //            StoreColumn.Items[StoreColumn.CurrentSelection].Selected = false;
    //    //        if (listCol.Any(x => x.Type == "players"))
    //    //        {
    //    //            PlayersColumn.Items[PlayersColumn.CurrentSelection].Selected = false;
    //    //            if (listCol[0].Type == "players" || PlayersColumn.Items[PlayersColumn.CurrentSelection].KeepPanelVisible)
    //    //            {
    //    //                if (PlayersColumn.Items[PlayersColumn.CurrentSelection].ClonePed != null)
    //    //                {
    //    //                    PlayersColumn.Items[PlayersColumn.CurrentSelection].CreateClonedPed();
    //    //                }
    //    //                else
    //    //                {
    //    //                    ClearPedInPauseMenu();
    //    //                }

    //    //            }
    //    //            else
    //    //            {
    //    //                ClearPedInPauseMenu();
    //    //            }

    //    //        }
    //    //        else
    //    //        {
    //    //            ClearPedInPauseMenu();
    //    //        }
    //    //    }
    //    //    switch (listCol[focusLevel].Type)
    //    //    {
    //    //        case "settings":
    //    //            {
    //    //                UIMenuItem item = SettingsColumn.Items[SettingsColumn.CurrentSelection];
    //    //                if (!item.Enabled)
    //    //                {
    //    //                    if (_newStyle)
    //    //                    {
    //    //                        SettingsColumn.Items[SettingsColumn.CurrentSelection].Selected = false;
    //    //                        //updateFocus(focusLevel + 1);
    //    //                    }
    //    //                    else
    //    //                    {
    //    //                        Game.PlaySound("ERROR", "HUD_FRONTEND_DEFAULT_SOUNDSET");
    //    //                    }
    //    //                    return;
    //    //                }

    //    //                if (item is UIMenuListItem it)
    //    //                {
    //    //                    it.Index = split[2];
    //    //                    //ListChange(it, it.Index);
    //    //                    it.ListChangedTrigger(it.Index);
    //    //                }
    //    //                else if (item is UIMenuSliderItem slit)
    //    //                {
    //    //                    slit.Value = split[2];
    //    //                    slit.SliderChanged(slit.Value);
    //    //                    //SliderChange(it, it.Value);
    //    //                }
    //    //                else if (item is UIMenuProgressItem prit)
    //    //                {
    //    //                    prit.Value = split[2];
    //    //                    prit.ProgressChanged(prit.Value);
    //    //                    //ProgressChange(it, it.Value);
    //    //                }
    //    //                else
    //    //                {
    //    //                    if (_newStyle)
    //    //                    {
    //    //                        SettingsColumn.Items[SettingsColumn.CurrentSelection].Selected = false;
    //    //                        //updateFocus(focusLevel + 1);
    //    //                    }
    //    //                }
    //    //            }
    //    //            break;
    //    //        case "missions":
    //    //            if (_newStyle)
    //    //            {
    //    //                MissionsColumn.Items[MissionsColumn.CurrentSelection].Selected = false;
    //    //                //updateFocus(focusLevel + 1);
    //    //            }
    //    //            break;
    //    //        case "store":
    //    //            if (_newStyle)
    //    //            {
    //    //                StoreColumn.Items[StoreColumn.CurrentSelection].Selected = false;
    //    //                //updateFocus(focusLevel - 1);
    //    //            }
    //    //            break;
    //    //        case "panel":
    //    //            //updateFocus(focusLevel + 1);
    //    //            break;
    //    //        case "minimap":
    //    //            //updateFocus(focusLevel + 1);
    //    //            break;
    //    //        case "players":
    //    //            if (_newStyle)
    //    //            {
    //    //                PlayersColumn.Items[PlayersColumn.CurrentSelection].Selected = false;
    //    //                //updateFocus(focusLevel + 1);
    //    //            }
    //    //            else
    //    //            {
    //    //                if (PlayersColumn.Items[PlayersColumn.CurrentSelection].ClonePed != null)
    //    //                    PlayersColumn.Items[PlayersColumn.CurrentSelection].CreateClonedPed();
    //    //            }
    //    //            break;
    //    //    }
    //    //}

    //    void ButtonDelay()
    //    {
    //        // Increment the "changed indexes" counter
    //        times++;

    //        // Each time "times" is a multiple of 5 we decrease the delay.
    //        // Min delay for the scaleform is 50.. less won't change due to the
    //        // awaiting time for the scaleform itself.
    //        if (times % 5 == 0)
    //        {
    //            delay -= 10;
    //            if (delay < 50) delay = 50;
    //        }
    //        // Reset the time to the current game timer.
    //        time = Main.GameTime;
    //    }

    //    internal void SendPauseMenuOpen()
    //    {
    //        OnLobbyMenuOpen?.Invoke(this);
    //    }

    //    internal void SendPauseMenuClose()
    //    {
    //        OnLobbyMenuClose?.Invoke(this);
    //    }



    //}
}

using CitizenFX.Core;
using CitizenFX.Core.Native;
using ScaleformUI.Elements;
using ScaleformUI.Menu;
using ScaleformUI.Menus;
using ScaleformUI.PauseMenus;
using ScaleformUI.PauseMenus.Elements;
using ScaleformUI.PauseMenus.Elements.Items;
using ScaleformUI.PauseMenus.Elements.Panels;
using ScaleformUI.Scaleforms;
using System.Reflection.Emit;
using static CitizenFX.Core.Native.API;
using static CitizenFX.Core.UI.Screen;

namespace ScaleformUI.PauseMenu
{
    public delegate void PauseMenuOpenEvent(TabView menu);
    public delegate void PauseMenuCloseEvent(TabView menu);
    public delegate void PauseMenuTabChanged(TabView menu, BaseTab tab, int i);
    public delegate void PauseMenuFocusChanged(TabView menu, BaseTab tab, int focusLevel);
    public delegate void ColumnItemEvent(TabView menu, BaseTab tab, PM_COLUMNS column, int index);

    internal enum eFRONTEND_INPUT
    {
        FRONTEND_INPUT_UP = 0,
        FRONTEND_INPUT_DOWN,
        FRONTEND_INPUT_LEFT,
        FRONTEND_INPUT_RIGHT,
        FRONTEND_INPUT_RDOWN,
        FRONTEND_INPUT_RLEFT,
        FRONTEND_INPUT_RRIGHT,
        FRONTEND_INPUT_RUP,
        FRONTEND_INPUT_ACCEPT,
        FRONTEND_INPUT_X,
        FRONTEND_INPUT_Y,
        FRONTEND_INPUT_BACK,
        FRONTEND_INPUT_START,
        FRONTEND_INPUT_SPECIAL_UP,
        FRONTEND_INPUT_SPECIAL_DOWN,
        FRONTEND_INPUT_RSTICK_LEFT,
        FRONTEND_INPUT_RSTICK_RIGHT,
        FRONTEND_INPUT_LT,
        FRONTEND_INPUT_RT,
        FRONTEND_INPUT_LB,
        FRONTEND_INPUT_RB,
        FRONTEND_INPUT_LT_SPECIAL,
        FRONTEND_INPUT_RT_SPECIAL,
        FRONTEND_INPUT_SELECT,
        FRONTEND_INPUT_R3,
        // Used for pointing devices (mouse button, touch pad etc).
        FRONTEND_INPUT_CURSOR_ACCEPT,
        FRONTEND_INPUT_CURSOR_BACK,
        FRONTEND_INPUT_L3,
        FRONTEND_INPUT_MAX
    };


    public class TabView : PauseMenuBase
    {
        /*
        ShowCursorThisFrame();
        */
        public static string AUDIO_LIBRARY = "HUD_FRONTEND_DEFAULT_SOUNDSET";
        public static string AUDIO_UPDOWN = "NAV_UP_DOWN";
        public static string AUDIO_LEFTRIGHT = "NAV_LEFT_RIGHT";
        public static string AUDIO_SELECT = "SELECT";
        public static string AUDIO_BACK = "BACK";
        public static string AUDIO_ERROR = "ERROR";
        private bool isBuilding = false;
        public string Title { get; set; }
        public string SubTitle { get; set; }
        public string SideStringTop { get; set; }
        public string SideStringMiddle { get; set; }
        public string SideStringBottom { get; set; }
        public HudColor TabsColor { get; set; } = HudColor.HUD_COLOUR_PAUSE_BG;
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
        internal int hoveredColumn;
        internal PlayerListTab coronaTab;
        // thanks R*
        private int sm_uDisableInputDuration = 250; // milliseconds.
        private int  FRONTEND_ANALOGUE_THRESHOLD = 80;  // out of 128
        private int  BUTTON_PRESSED_DOWN_INTERVAL = 250;
        private int  BUTTON_PRESSED_REFIRE_ATTRITION = 45;
        private int  BUTTON_PRESSED_REFIRE_MINIMUM = 100;
        private int s_iLastRefireTimeUp = 250;
        private int s_iLastRefireTimeDn = 250;
        private int s_pressedDownTimer = GetGameTimer();
        private int s_lastGameFrame = 0;

        [Flags]
        enum CHECK_INPUT_OVERRIDE_FLAG : short
        {
            CHECK_INPUT_OVERRIDE_FLAG_NONE = 0,
            CHECK_INPUT_OVERRIDE_FLAG_WARNING_MESSAGE = (1 << 0),
            CHECK_INPUT_OVERRIDE_FLAG_STORAGE_DEVICE = (1 << 1),
            CHECK_INPUT_OVERRIDE_FLAG_RESTART_SAVED_GAME_STATE = (1 << 2),
            CHECK_INPUT_OVERRIDE_FLAG_IGNORE_ANALOGUE_STICKS = (1 << 3),
            CHECK_INPUT_OVERRIDE_FLAG_IGNORE_D_PAD = (1 << 4)
        }


        public int FocusLevel
        {
            get => focusLevel;
            set
            {
                var dir = value == focusLevel ? 0 : value < focusLevel ? -1 : 1;
                focusLevel += dir;
                _pause?.SetFocus(dir);
                if (dir > 0 && Tabs.Count > 0 && focusLevel == 1)
                    Tabs[Index].Focus();
                else if (dir < 0 && focusLevel == 0)
                    Tabs[Index].UnFocus();
                SendPauseMenuFocusChange();
            }
        }

        public async void ChangeMenuLevel(int dir)
        {
            while (isBuilding) await BaseScript.Delay(0);
            focusLevel += dir;
            _pause?.SetFocus(dir);
            if (dir > 0 && Tabs.Count > 0 && focusLevel == 1)
                Tabs[Index].Focus();
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
        public event ColumnItemEvent OnColumnItemChange;
        public event ColumnItemEvent OnColumnItemSelect;
        public bool IsCorona { get; internal set; }

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
                    Tabs[0].Visible = true;
                    MenuHandler.currentBase = this;
                    ShowHeader();
                    BuildPauseMenu();
                    SendPauseMenuOpen();
                    if (IsCorona)
                        FocusLevel = 1;
                }
                else
                {
                    Tabs[Index].Minimap?.Dispose();
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
                    SetFrontendActive(false);
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

        public void AddTab(BaseTab tab)
        {
            if(tab.Minimap != null)
                tab.Minimap.Parent = this;
            tab.Parent = this;
            Tabs.Add(tab);
        }

        private bool _visible;
        internal int focusLevel;
        private int _timer;
        public void ShowHeader()
        {
            if (String.IsNullOrEmpty(SubTitle) || String.IsNullOrWhiteSpace(SubTitle))
                _pause.SetHeaderTitle(Title);
            else
            {
                _pause.ShiftCoronaDescription(true, false);
                _pause.SetHeaderTitle(Title, SubTitle + "\n\n\n\n\n\n\n\n\n\n\n");
            }
            if (HeaderPicture != null && !string.IsNullOrEmpty(HeaderPicture.Item1) && !string.IsNullOrEmpty(HeaderPicture.Item2))
                _pause.SetHeaderCharImg(HeaderPicture.Item1, HeaderPicture.Item2, true);
            else
                _pause.SetHeaderCharImg("CHAR_DEFAULT", "CHAR_DEFAULT", true);
            if (CrewPicture != null)
                _pause.SetHeaderSecondaryImg(CrewPicture.Item1, CrewPicture.Item2, true);
            _pause.SetHeaderDetails(SideStringTop, SideStringMiddle, SideStringBottom);

            if (!IsCorona)
            {
                _pause._header.CallFunction("ENABLE_DYNAMIC_WIDTH", SetHeaderDynamicWidth);
                foreach (BaseTab tab in Tabs)
                    _pause.AddPauseMenuTab(tab.Title, 0, tab._type, tab.TabColor);
            }
            else
            {
                if (coronaTab.LeftColumn != null)
                    _pause.AddLobbyMenuTab(coronaTab.LeftColumn.Label, 2, coronaTab.LeftColumn.Color);
                if (coronaTab.CenterColumn != null)
                    _pause.AddLobbyMenuTab(coronaTab.CenterColumn.Label, 2, coronaTab.CenterColumn.Color);
                if (coronaTab.RightColumn != null)
                    _pause.AddLobbyMenuTab(coronaTab.RightColumn.Label, 2, coronaTab.RightColumn.Color);
                _pause._header.CallFunction("SET_ALL_HIGHLIGHTS", true, (int)TabsColor);
                _pause._header.CallFunction("ENABLE_DYNAMIC_WIDTH", false);
            }
            _loaded = true;
        }

        public void BuildPauseMenu()
        {
            isBuilding = true;
            if (!HasStreamedTextureDictLoaded("commonmenu"))
                RequestStreamedTextureDict("commonmenu", true);
            BaseTab tab = Tabs[Index];
            _pause._pause.CallFunction("LOAD_CHILD_PAGE", tab._identifier);
            tab.Populate();
            tab.ShowColumns();
            isBuilding = false;
        }

        private bool controller = false;
        public override async void Draw()
        {
            if (!Visible || TemporarilyHidden || isBuilding) return;
            Tabs[Index].Minimap?.MaintainMap();
            base.Draw();
            _pause.Draw();
            if(!IsCorona)
                _pause._header.CallFunction("SHOW_ARROWS");
            UpdateKeymapItems();
            GetHoveredColumn();
        }
        private async void GetHoveredColumn()
        {
            hoveredColumn = await Main.PauseMenu._pause.CallFunctionReturnValueInt("GET_HOVERED_COLUMN");
        }
        bool changed;
        private void UpdateKeymapItems()
        {
            if (!IsUsingKeyboard(2))
            {
                if (!controller)
                {
                    controller = true;
                    changed = true;
                }
            }
            else
            {
                if (controller)
                {
                    controller = false;
                    changed = true;
                }
            }

            if (changed)
            {
                if (Tabs[Index] is SubmenuTab smT)
                {
                    if(smT.currentItemType == LeftItemType.Keymap)
                    {
                        for (int i = 0; i < smT.CenterColumn.Items.Count; i++)
                        {
                            smT.CenterColumn.UpdateSlot(i);
                        }
                    }
                }
                changed = false;
            }
        }

        public void GoBack()
        {
            Game.PlaySound(AUDIO_BACK, AUDIO_LIBRARY);
            if (IsCorona)
            {
                if (CurrentTab.CurrentColumnIndex > 0)
                {
                    CurrentTab.GoBack();
                }
                else
                {
                    if (CanPlayerCloseMenu)
                    {
                        if (CurrentTab is PlayerListTab plTab)
                            plTab.Minimap.Enabled = false;
                        Visible = false;
                    }
                }
            }
            else
            {
                if (FocusLevel > 0)
                {
                    //TODO: IMPLEMENTATION PER EACH TABS
                    if (FocusLevel == 1 && CurrentTab.CurrentColumnIndex == 0)
                    {
                        Tabs[Index].UnFocus();
                        FocusLevel--;
                        if (CurrentTab is PlayerListTab plTab)
                            plTab.Minimap.Enabled = false;
                    }
                    else
                    {
                        CurrentTab.GoBack();
                    }
                }
                else
                {
                    if (CanPlayerCloseMenu)
                        Visible = false;
                }
            }
        }

        private bool firstTick = true;
        private int eventType = 0;
        private int itemId = 0;
        private int context = 0;
        private int unused = 0;
        private bool tabArrowsHovered;
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
            if (successHeader && !IsCorona)
            {
                switch (eventType)
                {
                    case 5: // on click pressed
                        switch (context)
                        {
                            case -1:
                                FocusLevel = 0;
                                CurrentTab.UnFocus();
                                _pause.SelectTab(itemId);
                                Index = itemId;
                                FocusLevel = 1;
                                Tabs[Index].Focus();
                                Game.PlaySound("SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET");
                                break;
                        }
                        break;
                    case 6:
                        switch (context)
                        {
                            case 1000:
                                FocusLevel = 0;
                                Tabs[Index].UnFocus();
                                if (itemId == -1)
                                    Index--;
                                if (itemId == 1)
                                    Index++;
                                Tabs[Index].Focus();
                                return;
                        }
                        break;
                    case 8:
                        tabArrowsHovered = false;
                        break;
                    case 9:
                        tabArrowsHovered = true;
                        break;
                }
            }

            bool successPause = GetScaleformMovieCursorSelection(Main.PauseMenu._pause.Handle, ref eventType, ref context, ref itemId, ref unused);
            if (successPause && !tabArrowsHovered)
            {
                if (eventType == 5 && FocusLevel == 0 && !tabArrowsHovered)
                {
                    FocusLevel++;
                    return;
                }

                Tabs[Index].MouseEvent(eventType, context, itemId);
            }
            if(!successPause && !successHeader && FocusLevel == 0)
            {
                if(Game.IsDisabledControlJustPressed(0, Control.CursorAccept))
                {
                    FocusLevel++;
                }
            }
        }


        float iPreviousXAxis = GetDisabledControlNormal(2, 195) * 128.0f;
        float iPreviousYAxis = GetDisabledControlNormal(2, 196) * 128.0f;
        float iPreviousXAxisR = GetDisabledControlNormal(2, 197) * 128.0f;
        float iPreviousYAxisR = GetDisabledControlNormal(2, 198) * 128.0f;
        private bool CheckInput(eFRONTEND_INPUT input, bool bPlaySound, CHECK_INPUT_OVERRIDE_FLAG OverrideFlags, bool bCheckForButtonJustPressed)
        {
            bool bOnlyCheckForDown = false;
            int interval = (input == eFRONTEND_INPUT.FRONTEND_INPUT_UP) ? s_iLastRefireTimeUp : (input == eFRONTEND_INPUT.FRONTEND_INPUT_DOWN) ? s_iLastRefireTimeDn : BUTTON_PRESSED_DOWN_INTERVAL;

            if (s_lastGameFrame != GetFrameCount() && GetGameTimer() > (s_pressedDownTimer + interval))
            {
                bOnlyCheckForDown = true;
            }

            bool bInputTriggered = false;

            // We use GetNorm() but we convert back to the old value range as the frontend might be heavely dependent on this range.
            float iXAxis = 0;
            float iYAxis = 0;
            float iYAxisR = 0;
            float iXAxisR = 0;

            bool c_ignoreDpad = (OverrideFlags & CHECK_INPUT_OVERRIDE_FLAG.CHECK_INPUT_OVERRIDE_FLAG_IGNORE_D_PAD) != 0;

            if (!OverrideFlags.HasFlag(CHECK_INPUT_OVERRIDE_FLAG.CHECK_INPUT_OVERRIDE_FLAG_IGNORE_ANALOGUE_STICKS))
            {
                iXAxis = GetDisabledControlNormal(2, 195) * 128.0f;
                iYAxis = GetDisabledControlNormal(2, 196) * 128.0f;
                iYAxisR = GetDisabledControlNormal(2, 198) * 128.0f;
                iXAxisR = GetDisabledControlNormal(2, 197) * 128.0f;
            }


            switch (input)
            {
                case eFRONTEND_INPUT.FRONTEND_INPUT_UP:
                    {
                        if (iXAxis > -FRONTEND_ANALOGUE_THRESHOLD && iXAxis < FRONTEND_ANALOGUE_THRESHOLD)
                        {
                            if (bOnlyCheckForDown)
                            {
                                if (iYAxis < -FRONTEND_ANALOGUE_THRESHOLD || (IsDisabledControlPressed(2, 188) && !c_ignoreDpad))
                                    bInputTriggered = true;
                            }
                            else if ((iPreviousYAxis > -FRONTEND_ANALOGUE_THRESHOLD && iYAxis < -FRONTEND_ANALOGUE_THRESHOLD) || (IsDisabledControlJustPressed(2, 188) && !c_ignoreDpad))
                                bInputTriggered = true;
                        }

                        if (s_lastGameFrame != GetFrameCount())
                        {
                            // can't just do bInputTriggered because we may be waiting for an up
                            if (iYAxis < -FRONTEND_ANALOGUE_THRESHOLD || (IsDisabledControlPressed(2, 188) && !c_ignoreDpad))
                            {
                                if (bInputTriggered)
                                    s_iLastRefireTimeUp = Math.Max(s_iLastRefireTimeUp - BUTTON_PRESSED_REFIRE_ATTRITION, BUTTON_PRESSED_REFIRE_MINIMUM);
                            }
                            else
                                s_iLastRefireTimeUp = BUTTON_PRESSED_DOWN_INTERVAL;
                        }
                        break;
                    }

                case eFRONTEND_INPUT.FRONTEND_INPUT_DOWN:
                    {
                        if (iXAxis > -FRONTEND_ANALOGUE_THRESHOLD && iXAxis < FRONTEND_ANALOGUE_THRESHOLD)
                        {
                            if (bOnlyCheckForDown)
                            {
                                if (iYAxis > FRONTEND_ANALOGUE_THRESHOLD || (IsDisabledControlPressed(2, 187) && !c_ignoreDpad))
                                    bInputTriggered = true;
                            }
                            else if ((iPreviousYAxis < FRONTEND_ANALOGUE_THRESHOLD && iYAxis > FRONTEND_ANALOGUE_THRESHOLD) || (IsDisabledControlJustPressed(2, 187) && !c_ignoreDpad))
                                bInputTriggered = true;
                        }

                        if (s_lastGameFrame != GetFrameCount())
                        {
                            // can't just do bInputTriggered because we may be waiting for an up
                            if (iYAxis > FRONTEND_ANALOGUE_THRESHOLD || (IsDisabledControlPressed(2, 187) && !c_ignoreDpad))
                            {
                                if (bInputTriggered)
                                    s_iLastRefireTimeDn = Math.Max(s_iLastRefireTimeDn - BUTTON_PRESSED_REFIRE_ATTRITION, BUTTON_PRESSED_REFIRE_MINIMUM);
                            }
                            else
                                s_iLastRefireTimeDn = BUTTON_PRESSED_DOWN_INTERVAL;
                        }
                        break;
                    }

                case eFRONTEND_INPUT.FRONTEND_INPUT_LEFT:
                    {
                        if (iYAxis > -FRONTEND_ANALOGUE_THRESHOLD && iYAxis < FRONTEND_ANALOGUE_THRESHOLD)
                        {
                            if (bOnlyCheckForDown)
                            {
                                if (iXAxis < -FRONTEND_ANALOGUE_THRESHOLD || (IsDisabledControlPressed(2, 189) && !c_ignoreDpad))
                                    bInputTriggered = true;
                            }
                            else if ((iPreviousXAxis > -FRONTEND_ANALOGUE_THRESHOLD && iXAxis < -FRONTEND_ANALOGUE_THRESHOLD) || (IsDisabledControlJustPressed(2, 189) && !c_ignoreDpad))
                                bInputTriggered = true;
                        }

                        break;
                    }

                case eFRONTEND_INPUT.FRONTEND_INPUT_RIGHT:
                    {
                        if (iYAxis > -FRONTEND_ANALOGUE_THRESHOLD && iYAxis < FRONTEND_ANALOGUE_THRESHOLD)
                        {
                            if (bOnlyCheckForDown)
                            {
                                if (iXAxis > FRONTEND_ANALOGUE_THRESHOLD || (IsDisabledControlPressed(2, 190) && !c_ignoreDpad))
                                    bInputTriggered = true;

                            }
                            else if ((iPreviousXAxis < FRONTEND_ANALOGUE_THRESHOLD && iXAxis > FRONTEND_ANALOGUE_THRESHOLD) || (IsDisabledControlJustPressed(2, 190) && !c_ignoreDpad))
                                bInputTriggered = true;
                        }
                        break;
                    }

                case eFRONTEND_INPUT.FRONTEND_INPUT_RUP:
                    {
                        if (bOnlyCheckForDown)
                        {
                            if (iYAxisR < -FRONTEND_ANALOGUE_THRESHOLD)
                                bInputTriggered = true;
                        }
                        else if (iPreviousYAxisR > -FRONTEND_ANALOGUE_THRESHOLD && iYAxisR < -FRONTEND_ANALOGUE_THRESHOLD)
                            bInputTriggered = true;
                        break;
                    }

                case eFRONTEND_INPUT.FRONTEND_INPUT_RDOWN:
                    {
                        if (bOnlyCheckForDown)
                        {
                            if (iYAxisR > FRONTEND_ANALOGUE_THRESHOLD)
                                bInputTriggered = true;
                        }
                        else if (iPreviousYAxisR < FRONTEND_ANALOGUE_THRESHOLD && iYAxisR > FRONTEND_ANALOGUE_THRESHOLD)
                            bInputTriggered = true;
                        break;
                    }

                case eFRONTEND_INPUT.FRONTEND_INPUT_RLEFT:
                    {
                        if (bOnlyCheckForDown)
                        {
                            if (iXAxisR < -FRONTEND_ANALOGUE_THRESHOLD)
                                bInputTriggered = true;
                        }
                        else if (iPreviousXAxisR > -FRONTEND_ANALOGUE_THRESHOLD && iXAxisR < -FRONTEND_ANALOGUE_THRESHOLD)
                            bInputTriggered = true;
                        break;
                    }

                case eFRONTEND_INPUT.FRONTEND_INPUT_RRIGHT:
                    {
                        if (bOnlyCheckForDown)
                        {
                            if (iXAxisR > FRONTEND_ANALOGUE_THRESHOLD)
                                bInputTriggered = true;
                        }
                        else if (iPreviousXAxisR < FRONTEND_ANALOGUE_THRESHOLD && iXAxisR > FRONTEND_ANALOGUE_THRESHOLD)
                            bInputTriggered = true;
                        break;
                    }

                case eFRONTEND_INPUT.FRONTEND_INPUT_ACCEPT:
                    {
                        bool bAcceptHasBeenPressed = false;

                        if (bCheckForButtonJustPressed)
                        {
                            if (IsDisabledControlJustPressed(2, 201))
                                bAcceptHasBeenPressed = true;
                        }
                        else
                        {
                            if (IsDisabledControlJustReleased(2, 201))
                                bAcceptHasBeenPressed = true;
                        }

                        if (bAcceptHasBeenPressed)
                            bInputTriggered = true;
                        break;
                    }

                case eFRONTEND_INPUT.FRONTEND_INPUT_X:
                    {
                        if (IsDisabledControlJustReleased(2, 203))
                            bInputTriggered = true;
                        break;
                    }

                case eFRONTEND_INPUT.FRONTEND_INPUT_Y:
                    {
                        if (IsDisabledControlJustReleased(2, 204))
                            bInputTriggered = true;
                        break;
                    }

                case eFRONTEND_INPUT.FRONTEND_INPUT_BACK:
                    {
                        if (bCheckForButtonJustPressed)
                        {
                            if (IsDisabledControlJustPressed(2, 202))
                                bInputTriggered = true;
                        }
                        else
                        {
                            if (IsDisabledControlJustReleased(2, 202))
                                bInputTriggered = true;
                        }
                        // allowed fall through
                        break;
                    }

                case eFRONTEND_INPUT.FRONTEND_INPUT_CURSOR_BACK:
                    {
                        if (bCheckForButtonJustPressed)
                        {
                            if (IsDisabledControlJustPressed(0, 238))
                                bInputTriggered = true;
                        }
                        else
                        {
                            if (IsDisabledControlJustReleased(0, 238))
                                bInputTriggered = true;
                        }

                        break;
                    }

                case eFRONTEND_INPUT.FRONTEND_INPUT_START:
                    {
                        if (IsDisabledControlJustReleased(0, 199))
                        {
                            bInputTriggered = true;
                            break;
                        }

                        if (IsDisabledControlJustReleased(0, 200))
                        {
                            bInputTriggered = true;
                            break;
                        }


                        break;
                    }

                case eFRONTEND_INPUT.FRONTEND_INPUT_SPECIAL_UP:
                    {
                        //if (GetPreviousYAxisR() > -FRONTEND_ANALOGUE_THRESHOLD && iYAxisR < -FRONTEND_ANALOGUE_THRESHOLD)
                        if (iYAxisR < -FRONTEND_ANALOGUE_THRESHOLD)
                            bInputTriggered = true;
                        break;
                    }

                case eFRONTEND_INPUT.FRONTEND_INPUT_SPECIAL_DOWN:
                    {
                        //if (GetPreviousYAxisR() < FRONTEND_ANALOGUE_THRESHOLD && iYAxisR > FRONTEND_ANALOGUE_THRESHOLD)
                        if (iYAxisR > FRONTEND_ANALOGUE_THRESHOLD)
                            bInputTriggered = true;
                        break;
                    }

                case eFRONTEND_INPUT.FRONTEND_INPUT_RT_SPECIAL:
                case eFRONTEND_INPUT.FRONTEND_INPUT_RT:
                    {
                        if(IsDisabledControlJustPressed(2, 208))
                            bInputTriggered = true;
                        break;
                    }

                case eFRONTEND_INPUT.FRONTEND_INPUT_LT_SPECIAL:
                case eFRONTEND_INPUT.FRONTEND_INPUT_LT:
                    {
                        if (IsDisabledControlJustPressed(2, 207))
                            bInputTriggered = true;
                        break;
                    }
                case eFRONTEND_INPUT.FRONTEND_INPUT_LB:
                    {
                        if (IsDisabledControlJustPressed(2, 205))
                            bInputTriggered = true;
                        break;
                    }

                case eFRONTEND_INPUT.FRONTEND_INPUT_RB:
                    {
                        if (IsDisabledControlJustPressed(2, 206))
                            bInputTriggered = true;
                        break;
                    }

                case eFRONTEND_INPUT.FRONTEND_INPUT_RSTICK_LEFT:
                    {
                        if (iXAxisR > FRONTEND_ANALOGUE_THRESHOLD)
                            bInputTriggered = true;
                    }
                    break;

                case eFRONTEND_INPUT.FRONTEND_INPUT_RSTICK_RIGHT:
                    {
                        if (iXAxisR < -FRONTEND_ANALOGUE_THRESHOLD)
                            bInputTriggered = true;
                    }
                    break;

                case eFRONTEND_INPUT.FRONTEND_INPUT_SELECT:
                    {
                        if (IsDisabledControlJustReleased(2, 217))
                            bInputTriggered = true;
                    }
                    break;

                case eFRONTEND_INPUT.FRONTEND_INPUT_R3:
                    {
                        if (IsDisabledControlJustReleased(2, 231))
                            bInputTriggered = true;
                    }
                    break;

                case eFRONTEND_INPUT.FRONTEND_INPUT_L3:
                    {
                        if (IsDisabledControlJustReleased(2, 230))
                            bInputTriggered = true;
                    }
                    break;

                case eFRONTEND_INPUT.FRONTEND_INPUT_CURSOR_ACCEPT:
                    {
                        if (IsDisabledControlJustReleased(2, 237))
                            bInputTriggered = true;
                    }
                    break;
            }

            if (bInputTriggered)
            {
                if (s_lastGameFrame != GetFrameCount())
                {
                    s_pressedDownTimer = GetGameTimer();  // reset the timer to check for holding button down
                    s_lastGameFrame = GetFrameCount();
                    iPreviousXAxis = iXAxis;
                    iPreviousYAxis = iYAxis;
                    iPreviousXAxisR = iXAxisR;
                    iPreviousYAxisR = iYAxisR;
                }

                //if (bPlaySound)
                //{
                //    PlayInputSound(input);
                //}

                //if(input == eFRONTEND_INPUT.FRONTEND_INPUT_CURSOR_ACCEPT)
                //{
                //    Main.PauseMenu._pause.CallFunction("CLEAR_ALL_HOVER");
                //}
            }
            return (bInputTriggered);
        }


        public override void ProcessControls()
        {
            if (firstTick)
            {
                firstTick = false;
                return;
            }

            if (!Visible || TemporarilyHidden || isBuilding) return;

            //if (Game.IsDisabledControlJustPressed(2, Control.FrontendUp))
            //    GoUp();
            if (CheckInput(eFRONTEND_INPUT.FRONTEND_INPUT_UP, false, CHECK_INPUT_OVERRIDE_FLAG.CHECK_INPUT_OVERRIDE_FLAG_NONE, false))
            {
                CurrentTab.GoUp();
            }
            else if (CheckInput(eFRONTEND_INPUT.FRONTEND_INPUT_DOWN, false, CHECK_INPUT_OVERRIDE_FLAG.CHECK_INPUT_OVERRIDE_FLAG_NONE, false))
            {
                CurrentTab.GoDown();
            }
            else if (CheckInput(eFRONTEND_INPUT.FRONTEND_INPUT_LEFT, false, CHECK_INPUT_OVERRIDE_FLAG.CHECK_INPUT_OVERRIDE_FLAG_NONE, false))
            {
                if (FocusLevel == 0 && !IsCorona)
                    Index--;
                else
                    CurrentTab.GoLeft();
            }
            else if (CheckInput(eFRONTEND_INPUT.FRONTEND_INPUT_RIGHT, false, CHECK_INPUT_OVERRIDE_FLAG.CHECK_INPUT_OVERRIDE_FLAG_NONE, false))
            {
                if (FocusLevel == 0 && !IsCorona)
                    Index++;
                else
                    CurrentTab.GoRight();
            }
            else if (CheckInput(eFRONTEND_INPUT.FRONTEND_INPUT_LB, false, CHECK_INPUT_OVERRIDE_FLAG.CHECK_INPUT_OVERRIDE_FLAG_NONE, false)
                || (Game.IsDisabledControlJustPressed(2, (Control)192) && Game.IsControlPressed(2, Control.Sprint) && IsUsingKeyboard(2)))
            {
                if (IsCorona) return;
                if (FocusLevel > 0)
                    FocusLevel = 0;
                Index--;
            }
            else if (CheckInput(eFRONTEND_INPUT.FRONTEND_INPUT_RB, false, CHECK_INPUT_OVERRIDE_FLAG.CHECK_INPUT_OVERRIDE_FLAG_NONE, false)
                || (Game.IsDisabledControlJustPressed(2, (Control)192) && IsUsingKeyboard(2)))
            {
                if (IsCorona) return;
                if (FocusLevel > 0)
                    FocusLevel = 0;
                Index++;
            }
            else if (CheckInput(eFRONTEND_INPUT.FRONTEND_INPUT_ACCEPT, false, CHECK_INPUT_OVERRIDE_FLAG.CHECK_INPUT_OVERRIDE_FLAG_NONE, false) || CheckInput(eFRONTEND_INPUT.FRONTEND_INPUT_CURSOR_ACCEPT, false, CHECK_INPUT_OVERRIDE_FLAG.CHECK_INPUT_OVERRIDE_FLAG_NONE, false))
            {
                if (focusLevel == 0)
                {
                    Tabs[Index].Focus();
                    FocusLevel++;
                }
                else
                {
                    CurrentTab.Select();
                }
            }
            else if (CheckInput(eFRONTEND_INPUT.FRONTEND_INPUT_BACK, false, CHECK_INPUT_OVERRIDE_FLAG.CHECK_INPUT_OVERRIDE_FLAG_NONE, false) || CheckInput(eFRONTEND_INPUT.FRONTEND_INPUT_CURSOR_BACK, false, CHECK_INPUT_OVERRIDE_FLAG.CHECK_INPUT_OVERRIDE_FLAG_NONE, false))
            {
                GoBack();
            }
            else if (CheckInput(eFRONTEND_INPUT.FRONTEND_INPUT_RUP, false, CHECK_INPUT_OVERRIDE_FLAG.CHECK_INPUT_OVERRIDE_FLAG_NONE, true))
            {
                if (!CurrentTab.Focused) return;
                if (CurrentTab is TextTab tTab)
                {
                    tTab.MouseEvent(10, 0, -1);
                    Main.PauseMenu._pause.CallFunction("SET_COLUMN_INPUT_EVENT", 0, 8);
                }
                else if (CurrentTab is SubmenuTab smTab)
                {
                    if (smTab.currentItemType == LeftItemType.Info || smTab.currentItemType == LeftItemType.Statistics)
                    {
                        Game.PlaySound(AUDIO_UPDOWN, AUDIO_LIBRARY);
                        Main.PauseMenu._pause.CallFunction("SET_COLUMN_INPUT_EVENT", 1, 8);
                    }
                }
            }
            else if (CheckInput(eFRONTEND_INPUT.FRONTEND_INPUT_RDOWN, false, CHECK_INPUT_OVERRIDE_FLAG.CHECK_INPUT_OVERRIDE_FLAG_NONE, true))
            {
                if (!CurrentTab.Focused) return;
                if (CurrentTab is TextTab tTab)
                {
                    tTab.MouseEvent(11, 0, -1);
                    Main.PauseMenu._pause.CallFunction("SET_COLUMN_INPUT_EVENT", 0, 9);
                }
                else if (CurrentTab is SubmenuTab smTab)
                {
                    if (smTab.currentItemType == LeftItemType.Info || smTab.currentItemType == LeftItemType.Statistics)
                    {
                        Game.PlaySound(AUDIO_UPDOWN, AUDIO_LIBRARY);
                        Main.PauseMenu._pause.CallFunction("SET_COLUMN_INPUT_EVENT", 1, 9);
                    }
                }
            }
        }

        public BaseTab CurrentTab => Tabs[Index];

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

        internal void SendColumnItemSelect(PM_Column col)
        {
            OnColumnItemSelect.Invoke(this, CurrentTab, col.position, col.Index);
        }
        internal void SendColumnItemChange(PM_Column col)
        {
            OnColumnItemSelect.Invoke(this, CurrentTab, col.position, col.Index);
        }
    }
}
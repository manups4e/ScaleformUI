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
    public delegate void LobbyMenuOpenEvent(MainView menu);
    public delegate void LobbyMenuCloseEvent(MainView menu);

    public class MainView : PauseMenuBase
    {
        // Button delay
        private int time;
        private bool _firstDrawTick = true;
        private int times;
        private int delay = 150;
        internal List<Column> listCol;
        internal PauseMenuScaleform _pause;
        internal bool _loaded;
        internal readonly static string _browseTextLocalized = Game.GetGXTEntry("HUD_INPUT1C");
        public event LobbyMenuOpenEvent OnLobbyMenuOpen;
        public event LobbyMenuCloseEvent OnLobbyMenuClose;
        public string Title { get; set; }
        public string SubTitle { get; set; }
        public string SideStringTop { get; set; }
        public string SideStringMiddle { get; set; }
        public string SideStringBottom { get; set; }
        public Tuple<string, string> HeaderPicture { internal get; set; }
        public Tuple<string, string> CrewPicture { internal get; set; }
        public SettingsListColumn SettingsColumn { get; private set; }
        public PlayerListColumn PlayersColumn { get; private set; }
        public MissionDetailsPanel MissionPanel { get; private set; }
        public int FocusLevel
        {
            get => focusLevel;
            set
            {
                focusLevel = value;
                if (_pause is not null)
                    _pause._lobby.CallFunction("SET_FOCUS", value);
            }
        }

        public bool TemporarilyHidden { get; set; }
        public bool HideTabs { get; set; }
        public bool DisplayHeader = true;
        public List<InstructionalButton> InstructionalButtons = new()
        {
            new InstructionalButton(Control.PhoneSelect, UIMenu._selectTextLocalized),
            new InstructionalButton(Control.PhoneCancel, UIMenu._backTextLocalized),
        };

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
                    DontRenderInGameUi(true);
                    AnimpostfxPlay("PauseMenuIn", 800, true);
                    ScaleformUI.InstructionalButtons.SetInstructionalButtons(InstructionalButtons);
                    SetPlayerControl(Game.Player.Handle, false, 0);
                    _firstDrawTick = true;
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

        public int Index;
        private bool _visible;
        private int focusLevel;

        public void SetUpColumns(List<Column> columns)
        {
            listCol = columns;
            foreach (var col in columns)
            {
                switch (col)
                {
                    case SettingsListColumn:
                        SettingsColumn = col as SettingsListColumn;
                        SettingsColumn.Parent = this;
                        SettingsColumn.Order = columns.IndexOf(col);
                        break;
                    case PlayerListColumn:
                        PlayersColumn = col as PlayerListColumn;
                        PlayersColumn.Parent = this;
                        PlayersColumn.Order = columns.IndexOf(col);
                        break;
                    case MissionDetailsPanel:
                        MissionPanel = col as MissionDetailsPanel;
                        MissionPanel.Parent = this;
                        MissionPanel.Order = columns.IndexOf(col);
                        break;
                }
            }
        }
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
            _pause.AddLobbyMenuTab(listCol[0].Label, 2, 0, listCol[0].Color);
            _pause.AddLobbyMenuTab(listCol[1].Label, 2, 0, listCol[1].Color);
            _pause.AddLobbyMenuTab(listCol[2].Label, 2, 0, listCol[2].Color);
            _pause._header.CallFunction("SET_ALL_HIGHLIGHTS", true, (int)HudColor.HUD_COLOUR_PAUSE_BG);

            _loaded = true;
        }

        private bool canBuild = true;
        public async void BuildPauseMenu()
        {
            ShowHeader();
            _pause._lobby.CallFunction("CREATE_MENU", SettingsColumn.Order, PlayersColumn.Order, MissionPanel.Order);
            buildSettings();
            await BaseScript.Delay(50);
            buildPlayers();
            _pause._lobby.CallFunction("ADD_MISSION_PANEL_PICTURE", MissionPanel.TextureDict, MissionPanel.TextureName);
            _pause._lobby.CallFunction("SET_MISSION_PANEL_TITLE", MissionPanel.Title);
            foreach (var item in MissionPanel.Items)
            {
                _pause._lobby.CallFunction("ADD_MISSION_PANEL_ITEM", item.Type, item.TextLeft, item.TextRight, (int)item.Icon, (int)item.IconColor, item.Tick);
            }
        }

        public async void buildSettings()
        {
            var i = 0;
            while (i < SettingsColumn.Items.Count)
            {
                await BaseScript.Delay(1);
                if (!canBuild) break;
                var item = SettingsColumn.Items[i];
                var index = SettingsColumn.Items.IndexOf(item);
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
                i++;
            }
            SettingsColumn.CurrentSelection = 0;
        }

        public async void buildPlayers()
        {
            var i = 0;
            while (i < PlayersColumn.Items.Count)
            {
                var item = PlayersColumn.Items[i];
                var index = PlayersColumn.Items.IndexOf(item);
                switch (item)
                {
                    case FriendItem:
                        var fi = (FriendItem)item;
                        _pause._lobby.CallFunction("ADD_PLAYER_ITEM", 1, 1, fi.Label, (int)fi.ItemColor, fi.ColoredTag, fi.iconL, fi.boolL, fi.iconR, fi.boolR, fi.Status, (int)fi.StatusColor, fi.Rank, fi.CrewTag);
                        break;
                }
                if (item.Panel != null)
                {
                    item.Panel.UpdatePanel(true);
                }
                i++;
            }
            PlayersColumn.CurrentSelection = 0;
        }

        private bool controller = false;
        public override async void Draw()
        {
            if (!Visible || TemporarilyHidden) return;
            _pause.Draw(true);
            if (_firstDrawTick)
            {
                _pause._lobby.CallFunction("FADE_IN");
                _firstDrawTick = false;
            }
        }

        private int eventType = 0;
        private int itemId = 0;
        private int context = 0;
        private int unused = 0;
        private bool cursorPressed;
        public override void ProcessMouse()
        {
            if (!IsInputDisabled(2))
            {
                return;
            }
            SetMouseCursorActiveThisFrame();
            SetInputExclusive(2, 239);
            SetInputExclusive(2, 240);
            SetInputExclusive(2, 237);
            SetInputExclusive(2, 238);

            var success = GetScaleformMovieCursorSelection(_pause._lobby.Handle, ref eventType, ref context, ref itemId, ref unused);
            if (success)
            {
                switch (eventType)
                {
                    case 5:
                        if (FocusLevel != context)
                            FocusLevel = context;
                        switch (listCol[context])
                        {
                            case SettingsListColumn:
                                {
                                    var col = listCol[context] as SettingsListColumn;
                                    foreach (var p in PlayersColumn.Items) p.Selected = false;
                                    if (!col.Items[col.CurrentSelection].Enabled)
                                    {
                                        Game.PlaySound("ERROR", "HUD_FRONTEND_DEFAULT_SOUNDSET");
                                        return;
                                    }
                                    if (col.Items[itemId].Selected)
                                    {
                                        BeginScaleformMovieMethod(_pause._lobby.Handle, "SET_INPUT_EVENT");
                                        ScaleformMovieMethodAddParamInt(16);
                                        EndScaleformMovieMethod();
                                        var item = col.Items[itemId];
                                        switch (item)
                                        {
                                            case UIMenuCheckboxItem:
                                                var cbIt = item as UIMenuCheckboxItem;
                                                cbIt.Checked = !cbIt.Checked;
                                                cbIt.CheckboxEventTrigger();
                                                break;
                                            default:
                                                item.ItemActivate(null);
                                                break;
                                        }
                                        return;
                                    }
                                    col.CurrentSelection = itemId;
                                }
                                break;
                            case PlayerListColumn:
                                {
                                    var col = listCol[context] as PlayerListColumn;
                                    foreach (var p in SettingsColumn.Items) p.Selected = false;
                                    if (!col.Items[col.CurrentSelection].Enabled)
                                    {
                                        Game.PlaySound("ERROR", "HUD_FRONTEND_DEFAULT_SOUNDSET");
                                        return;
                                    }
                                    if (col.Items[itemId].Selected)
                                    {
                                        // do something
                                        return;
                                    }
                                    col.CurrentSelection = itemId;
                                }
                                break;
                        }
                        break;
                }
            }
            /*
            Notifications.DrawText(0.3f, 0.775f, $"success:{success}");
            Notifications.DrawText(0.3f, 0.8f, $"eventType:{eventType}");
            Notifications.DrawText(0.3f, 0.825f, $"itemId:{itemId}");
            Notifications.DrawText(0.3f, 0.85f, $"context:{context}");
            */
        }

        public override async void ProcessControls()
        {
            if (!Visible || TemporarilyHidden) return;
            if (Game.IsControlPressed(2, Control.PhoneUp))
            {
                if (Game.GameTime - time > delay)
                {
                    ButtonDelay();
                    GoUp();
                }
            }
            else if (Game.IsControlPressed(2, Control.PhoneDown))
            {
                if (Game.GameTime - time > delay)
                {
                    ButtonDelay();
                    GoDown();
                }
            }

            else if (Game.IsControlPressed(2, Control.PhoneLeft))
            {
                if (Game.GameTime - time > delay)
                {
                    ButtonDelay();
                    GoLeft();
                }
            }
            else if (Game.IsControlPressed(2, Control.PhoneRight))
            {
                if (Game.GameTime - time > delay)
                {
                    ButtonDelay();
                    GoRight();
                }
            }

            else if (Game.IsControlJustPressed(2, Control.FrontendAccept))
            {
                Select();
            }

            else if (Game.IsControlJustPressed(2, Control.PhoneCancel))
            {
                GoBack();
            }

            if (Game.IsControlJustPressed(1, Control.CursorScrollUp))
            {
                _pause.SendScrollEvent(-1);
            }
            else if (Game.IsControlJustPressed(1, Control.CursorScrollDown))
            {
                _pause.SendScrollEvent(1);
            }

            // IsControlBeingPressed doesn't run every frame so I had to use this
            if (!Game.IsControlPressed(2, Control.PhoneUp) && !Game.IsControlPressed(2, Control.PhoneDown) && !Game.IsControlPressed(2, Control.PhoneLeft) && !Game.IsControlPressed(2, Control.PhoneRight))
            {
                times = 0;
                delay = 150;
            }
        }

        public async void Select()
        {
            BeginScaleformMovieMethod(_pause._lobby.Handle, "SET_INPUT_EVENT");
            ScaleformMovieMethodAddParamInt(16);
            var ret = EndScaleformMovieMethodReturnValue();
            while (!IsScaleformMovieMethodReturnValueReady(ret)) await BaseScript.Delay(0);
            var result = GetScaleformMovieFunctionReturnString(ret);

            var split = result.Split(',').Select(int.Parse).ToArray();
            if (FocusLevel == SettingsColumn.Order)
            {
                var item = SettingsColumn.Items[SettingsColumn.CurrentSelection];
                if (!item.Enabled)
                {
                    Game.PlaySound("ERROR", "HUD_FRONTEND_DEFAULT_SOUNDSET");
                    return;
                }
                switch (item)
                {
                    case UIMenuCheckboxItem:
                        var cbIt = item as UIMenuCheckboxItem;
                        cbIt.Checked = !cbIt.Checked;
                        cbIt.CheckboxEventTrigger();
                        break;
                    default:
                        item.ItemActivate(null);
                        break;
                }
            }
            else if (FocusLevel == PlayersColumn.Order)
            {

            }
        }

        public async void GoBack()
        {
            if(CanPlayerCloseMenu)
                Visible = false;
        }

        public async void GoUp()
        {
            BeginScaleformMovieMethod(_pause._lobby.Handle, "SET_INPUT_EVENT");
            ScaleformMovieMethodAddParamInt(8);
            var ret = EndScaleformMovieMethodReturnValue();
            while (!IsScaleformMovieMethodReturnValueReady(ret)) await BaseScript.Delay(0);
            var result = GetScaleformMovieFunctionReturnString(ret);

            var split = result.Split(',').Select(int.Parse).ToArray();
            FocusLevel = split[0];
            if (FocusLevel == SettingsColumn.Order)
            {
                SettingsColumn.CurrentSelection = split[1];
                SettingsColumn.IndexChangedEvent();
            }
            else if (FocusLevel == PlayersColumn.Order)
            {
                PlayersColumn.CurrentSelection = split[1];
                PlayersColumn.IndexChangedEvent();
            }
        }

        public async void GoDown()
        {
            BeginScaleformMovieMethod(_pause._lobby.Handle, "SET_INPUT_EVENT");
            ScaleformMovieMethodAddParamInt(9);
            var ret = EndScaleformMovieMethodReturnValue();
            while (!IsScaleformMovieMethodReturnValueReady(ret)) await BaseScript.Delay(0);
            var result = GetScaleformMovieFunctionReturnString(ret);

            var split = result.Split(',').Select(int.Parse).ToArray();
            FocusLevel = split[0];
            if (FocusLevel == SettingsColumn.Order)
            {
                SettingsColumn.CurrentSelection = split[1];
                SettingsColumn.IndexChangedEvent();
            }
            else if (FocusLevel == PlayersColumn.Order)
            {
                PlayersColumn.CurrentSelection = split[1];
                PlayersColumn.IndexChangedEvent();
            }
        }

        public async void GoLeft()
        {
            BeginScaleformMovieMethod(_pause._lobby.Handle, "SET_INPUT_EVENT");
            ScaleformMovieMethodAddParamInt(10);
            var ret = EndScaleformMovieMethodReturnValue();
            while (!IsScaleformMovieMethodReturnValueReady(ret)) await BaseScript.Delay(0);
            var result = GetScaleformMovieFunctionReturnString(ret);

            var split = result.Split(',').Select(int.Parse).ToArray();

            if (split[2] == -1)
            {
                FocusLevel = split[0];
                if (FocusLevel == SettingsColumn.Order)
                {
                    SettingsColumn.CurrentSelection = split[1];
                    SettingsColumn.IndexChangedEvent();
                }
                else if (FocusLevel == PlayersColumn.Order)
                {
                    PlayersColumn.CurrentSelection = split[1];
                    PlayersColumn.IndexChangedEvent();
                }
            }
            else
            {
                var item = SettingsColumn.Items[SettingsColumn.CurrentSelection];
                if (!item.Enabled)
                {
                    Game.PlaySound("ERROR", "HUD_FRONTEND_DEFAULT_SOUNDSET");
                    return;
                }
                switch (item)
                {
                    case UIMenuListItem:
                        {
                            UIMenuListItem it = (UIMenuListItem)item;
                            it.Index = split[2];
                            //ListChange(it, it.Index);
                            it.ListChangedTrigger(it.Index);
                            break;
                        }
                    case UIMenuSliderItem:
                        {
                            UIMenuSliderItem it = (UIMenuSliderItem)item;
                            it.Value = split[2];
                            //SliderChange(it, it.Value);
                            break;
                        }
                    case UIMenuProgressItem:
                        {
                            UIMenuProgressItem it = (UIMenuProgressItem)item;
                            it.Value = split[2];
                            //ProgressChange(it, it.Value);
                            break;
                        }
                }
            }
        }

        public async void GoRight()
        {
            BeginScaleformMovieMethod(_pause._lobby.Handle, "SET_INPUT_EVENT");
            ScaleformMovieMethodAddParamInt(11);
            var ret = EndScaleformMovieMethodReturnValue();
            while (!IsScaleformMovieMethodReturnValueReady(ret)) await BaseScript.Delay(0);
            var result = GetScaleformMovieFunctionReturnString(ret);

            var split = result.Split(',').Select(int.Parse).ToArray();

            if (split[2] == -1)
            {
                FocusLevel = split[0];
                if (FocusLevel == SettingsColumn.Order)
                {
                    SettingsColumn.CurrentSelection = split[1];
                    SettingsColumn.IndexChangedEvent();
                }
                else if (FocusLevel == PlayersColumn.Order)
                {
                    PlayersColumn.CurrentSelection = split[1];
                    PlayersColumn.IndexChangedEvent();
                }
            }
            else
            {
                var item = SettingsColumn.Items[SettingsColumn.CurrentSelection];
                if (!item.Enabled)
                {
                    Game.PlaySound("ERROR", "HUD_FRONTEND_DEFAULT_SOUNDSET");
                    return;
                }
                switch (item)
                {
                    case UIMenuListItem:
                        {
                            UIMenuListItem it = (UIMenuListItem)item;
                            it.Index = split[2];
                            //ListChange(it, it.Index);
                            it.ListChangedTrigger(it.Index);
                            break;
                        }
                    case UIMenuSliderItem:
                        {
                            UIMenuSliderItem it = (UIMenuSliderItem)item;
                            it.Value = split[2];
                            //SliderChange(it, it.Value);
                            break;
                        }
                    case UIMenuProgressItem:
                        {
                            UIMenuProgressItem it = (UIMenuProgressItem)item;
                            it.Value = split[2];
                            //ProgressChange(it, it.Value);
                            break;
                        }
                }
            }
        }

        void ButtonDelay()
        {
            // Increment the "changed indexes" counter
            times++;

            // Each time "times" is a multiple of 5 we decrease the delay.
            // Min delay for the scaleform is 50.. less won't change due to the
            // awaiting time for the scaleform itself.
            if (times % 5 == 0)
            {
                delay -= 10;
                if (delay < 50) delay = 50;
            }
            // Reset the time to the current game timer.
            time = Game.GameTime;
        }

        internal void SendPauseMenuOpen()
        {
            OnLobbyMenuOpen?.Invoke(this);
        }

        internal void SendPauseMenuClose()
        {
            OnLobbyMenuClose?.Invoke(this);
        }



    }
}
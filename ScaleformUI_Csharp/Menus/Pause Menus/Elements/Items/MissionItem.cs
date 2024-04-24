using ScaleformUI.Elements;
using ScaleformUI.LobbyMenu;
using ScaleformUI.Menu;
using ScaleformUI.PauseMenu;
using ScaleformUI.PauseMenus.Elements.Columns;
using ScaleformUI.Scaleforms;

namespace ScaleformUI.PauseMenus.Elements.Items
{
    public delegate void MissionActivated(PlayerListTab tab, MissionsListColumn column, MissionItem item);
    public class MissionItem
    {
        private bool enabled = true;

        public MissionsListColumn ParentColumn { get; internal set; }
        public string Label { get; private set; }
        public SColor MainColor { get; private set; } = SColor.FromHudColor(HudColor.HUD_COLOUR_PAUSE_BG);
        public SColor HighlightColor { get; private set; } = SColor.FromHudColor(HudColor.HUD_COLOUR_WHITE);
        public BadgeIcon LeftIcon { get; private set; } = BadgeIcon.NONE;
        public SColor LeftIconColor { get; private set; } = SColor.FromHudColor(HudColor.HUD_COLOUR_WHITE);
        public BadgeIcon RightIcon { get; private set; } = BadgeIcon.NONE;
        public SColor RightIconColor { get; private set; } = SColor.FromHudColor(HudColor.HUD_COLOUR_WHITE);
        public bool RightIconChecked { get; private set; }
        public bool Selected { get; internal set; }
        public bool Hovered { get; internal set; }
        public bool Enabled
        {
            get => enabled; set
            {
                enabled = value;
                if (ParentColumn != null)
                {
                    if (ParentColumn.Parent is MainView lobby)
                    {
                        lobby._pause._lobby.CallFunction("SET_MISSION_ITEM_ENABLED", ParentColumn.Items.IndexOf(this), value);
                    }
                    else if (ParentColumn.Parent is TabView pause && ParentColumn.ParentTab.Visible)
                    {
                        pause._pause._pause.CallFunction("SET_PLAYERS_TAB_MISSION_ITEM_ENABLED", ParentColumn.Items.IndexOf(this), value);
                    }
                }
            }
        }

        public event MissionActivated MissionActivated;
        public void ActivateMission(PlayerListTab tab)
        {
            MissionActivated?.Invoke(tab, ParentColumn, this);
        }

        public MissionItem(string label) : this(label, SColor.FromHudColor(HudColor.HUD_COLOUR_PAUSE_BG), SColor.FromHudColor(HudColor.HUD_COLOUR_WHITE)) { }

        public MissionItem(string label, SColor mainColor, SColor highlightColor)
        {
            Label = label;
            MainColor = mainColor;
            HighlightColor = highlightColor;
        }

        public void SetLeftIcon(BadgeIcon icon, SColor color)
        {
            LeftIcon = icon;
            LeftIconColor = color;
            if (ParentColumn != null)
            {
                if (ParentColumn.Parent is MainView lobby)
                {
                    lobby._pause._lobby.CallFunction("SET_MISSION_ITEM_LEFT_ICON", ParentColumn.Items.IndexOf(this), (int)icon, color);
                }
                else if (ParentColumn.Parent is TabView pause && ParentColumn.ParentTab.Visible)
                {
                    pause._pause._pause.CallFunction("SET_PLAYERS_TAB_MISSION_ITEM_LEFT_ICON", ParentColumn.Items.IndexOf(this), (int)icon, color);
                }
            }
        }
        public void SetRightIcon(BadgeIcon icon, SColor color, bool @checked = false)
        {
            RightIcon = icon;
            RightIconColor = color;
            RightIconChecked = @checked;
            if (ParentColumn != null)
            {
                if (ParentColumn.Parent is MainView lobby)
                {
                    lobby._pause._lobby.CallFunction("SET_MISSION_ITEM_RIGHT_ICON", ParentColumn.Items.IndexOf(this), (int)icon, @checked, color);
                }
                else if (ParentColumn.Parent is TabView pause && ParentColumn.ParentTab.Visible)
                {
                    pause._pause._pause.CallFunction("SET_PLAYERS_TAB_MISSION_ITEM_RIGHT_ICON", ParentColumn.Items.IndexOf(this), (int)icon, @checked, color);
                }
            }
        }
    }
}

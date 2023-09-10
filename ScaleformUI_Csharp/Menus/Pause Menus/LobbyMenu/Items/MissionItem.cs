using ScaleformUI.LobbyMenu;
using ScaleformUI.Menu;
using ScaleformUI.PauseMenu;
using ScaleformUI.Scaleforms;

namespace ScaleformUI
{
    public class MissionItem
    {
        private bool enabled = true;

        public MissionsListColumn ParentColumn { get; internal set; }
        public string Label { get; private set; }
        public HudColor MainColor { get; private set; } = HudColor.HUD_COLOUR_PAUSE_BG;
        public HudColor HighlightColor { get; private set; } = HudColor.HUD_COLOUR_WHITE;
        public BadgeIcon LeftIcon { get; private set; } = BadgeIcon.NONE;
        public HudColor LeftIconColor { get; private set; } = HudColor.HUD_COLOUR_WHITE;
        public BadgeIcon RightIcon { get; private set; } = BadgeIcon.NONE;
        public HudColor RightIconColor { get; private set; } = HudColor.HUD_COLOUR_WHITE;
        public bool RightIconChecked { get; private set; }
        public bool Selected { get; internal set; }
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
                    else if (ParentColumn.Parent is TabView pause)
                    {
                        pause._pause._pause.CallFunction("SET_PLAYERS_TAB_MISSION_ITEM_ENABLED", ParentColumn.Items.IndexOf(this), value);
                    }
                }
            }
        }

        public MissionItem(string label) : this(label, HudColor.HUD_COLOUR_PAUSE_BG, HudColor.HUD_COLOUR_WHITE) { }

        public MissionItem(string label, HudColor mainColor, HudColor highlightColor)
        {
            Label = label;
            MainColor = mainColor;
            HighlightColor = highlightColor;
        }

        public void SetLeftIcon(BadgeIcon icon, HudColor color)
        {
            LeftIcon = icon;
            LeftIconColor = color;
            if (ParentColumn != null)
            {
                if (ParentColumn.Parent is MainView lobby)
                {
                    lobby._pause._lobby.CallFunction("SET_MISSION_ITEM_LEFT_ICON", (int)icon, color);
                }
                else if (ParentColumn.Parent is TabView pause)
                {
                    pause._pause._pause.CallFunction("SET_PLAYERSTAB_MISSION_ITEM_LEFT_ICON", ParentColumn.ParentTab, (int)icon, color);
                }
            }
        }
        public void SetRightIcon(BadgeIcon icon, HudColor color, bool @checked = false)
        {
            RightIcon = icon;
            RightIconColor = color;
            RightIconChecked = @checked;
            if (ParentColumn != null)
            {
                if (ParentColumn.Parent is MainView lobby)
                {
                    lobby._pause._lobby.CallFunction("SET_MISSION_ITEM_RIGHT_ICON", (int)icon, @checked, color);
                }
                else if (ParentColumn.Parent is TabView pause)
                {
                    pause._pause._pause.CallFunction("SET_PLAYERSTAB_MISSION_ITEM_RIGHT_ICON", ParentColumn.ParentTab, (int)icon, @checked, color);
                }
            }
        }
    }
}

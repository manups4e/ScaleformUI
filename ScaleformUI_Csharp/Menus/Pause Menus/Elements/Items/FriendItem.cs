using ScaleformUI.Elements;
using ScaleformUI.LobbyMenu;
using ScaleformUI.Menu;
using ScaleformUI.PauseMenu;
using ScaleformUI.PauseMenus.Elements.Panels;
using ScaleformUI.Scaleforms;

namespace ScaleformUI.PauseMenus.Elements.Items
{
    public enum LobbyBadgeIcon
    {
        NONE = 0,
        ACTIVE_HEADSET = 47,
        INACTIVE_HEADSET = 48,
        MUTED_HEADSET = 49,
        GTAV = 54,
        WORLD = 63,
        KICK = 64,
        RANK_FREEMODE = 65,
        SPECTATOR = 66,
        IS_CONSOLE_PLAYER = 119,
        IS_PC_PLAYER = 120
    }

    public class FriendItem : LobbyItem
    {
        private string label;
        private SColor itemColor;
        private int rank;
        private string status;
        private SColor statusColor = SColor.FromHudColor(HudColor.NONE);
        private CrewTag crewTag;
        internal int iconL;
        internal int iconR;
        internal bool boolL;
        internal bool boolR;
        private bool coloredTag;

        public string Label
        {
            get => label;
            set
            {
                label = value;
                if (ParentColumn is not null && ParentColumn.Parent is not null && ParentColumn.Parent.Visible && ParentColumn.Pagination.IsItemVisible(ParentColumn.Items.IndexOf(this)))
                {
                    int idx = ParentColumn.Pagination.GetScaleformIndex(ParentColumn.Items.IndexOf(this));
                    if (ParentColumn.Parent is MainView lobby)
                        lobby._pause._lobby.CallFunction("SET_PLAYER_ITEM_LABEL", idx, label);
                    else if (ParentColumn.Parent is TabView pause && ParentColumn.ParentTab.Visible)
                        pause._pause._pause.CallFunction("SET_PLAYERS_TAB_PLAYER_ITEM_LABEL", idx, label);
                }
            }
        }
        public SColor ItemColor
        {
            get => itemColor;
            set
            {
                itemColor = value;
                if (ParentColumn is not null && ParentColumn.Parent is not null && ParentColumn.Parent.Visible && ParentColumn.Pagination.IsItemVisible(ParentColumn.Items.IndexOf(this)))
                {
                    int idx = ParentColumn.Pagination.GetScaleformIndex(ParentColumn.Items.IndexOf(this));
                    if (ParentColumn.Parent is MainView lobby)
                        lobby._pause._lobby.CallFunction("SET_PLAYER_ITEM_COLOUR", idx, itemColor, coloredTag);
                    else if (ParentColumn.Parent is TabView pause && ParentColumn.ParentTab.Visible)
                        pause._pause._pause.CallFunction("SET_PLAYERS_TAB_PLAYER_ITEM_COLOUR", idx, itemColor, coloredTag);
                }
            }
        }
        public bool ColoredTag
        {
            get => coloredTag;
            set
            {
                coloredTag = value;
                if (ParentColumn is not null && ParentColumn.Parent is not null && ParentColumn.Parent.Visible && ParentColumn.Pagination.IsItemVisible(ParentColumn.Items.IndexOf(this)))
                {
                    int idx = ParentColumn.Pagination.GetScaleformIndex(ParentColumn.Items.IndexOf(this));
                    if (ParentColumn.Parent is MainView lobby)
                        lobby._pause._lobby.CallFunction("SET_PLAYER_ITEM_COLOUR", idx, itemColor, coloredTag);
                    else if (ParentColumn.Parent is TabView pause && ParentColumn.ParentTab.Visible)
                        pause._pause._pause.CallFunction("SET_PLAYERS_TAB_PLAYER_ITEM_COLOUR", idx, itemColor, coloredTag);
                }
            }
        }
        public int Rank
        {
            get => rank;
            set
            {
                rank = value;
                if (ParentColumn is not null && ParentColumn.Parent is not null && ParentColumn.Parent.Visible && ParentColumn.Pagination.IsItemVisible(ParentColumn.Items.IndexOf(this)))
                {
                    int idx = ParentColumn.Pagination.GetScaleformIndex(ParentColumn.Items.IndexOf(this));
                    if (ParentColumn.Parent is MainView lobby)
                        lobby._pause._lobby.CallFunction("SET_PLAYER_ITEM_RANK", idx, rank);
                    else if (ParentColumn.Parent is TabView pause && ParentColumn.ParentTab.Visible)
                        pause._pause._pause.CallFunction("SET_PLAYERS_TAB_PLAYER_ITEM_RANK", idx, rank);
                }
            }
        }
        public string Status
        {
            get => status;
            set
            {
                status = value;
                if (ParentColumn is not null && ParentColumn.Parent is not null && ParentColumn.Parent.Visible && ParentColumn.Pagination.IsItemVisible(ParentColumn.Items.IndexOf(this)))
                {
                    int idx = ParentColumn.Pagination.GetScaleformIndex(ParentColumn.Items.IndexOf(this));
                    if (ParentColumn.Parent is MainView lobby)
                        lobby._pause._lobby.CallFunction("SET_PLAYER_ITEM_STATUS", idx, status, statusColor);
                    else if (ParentColumn.Parent is TabView pause && ParentColumn.ParentTab.Visible)
                        pause._pause._pause.CallFunction("SET_PLAYERS_TAB_PLAYER_ITEM_STATUS", idx, status, statusColor);
                }
            }
        }
        public SColor StatusColor
        {
            get => statusColor;
            set
            {
                statusColor = value;
                if (ParentColumn is not null && ParentColumn.Parent is not null && ParentColumn.Parent.Visible && ParentColumn.Pagination.IsItemVisible(ParentColumn.Items.IndexOf(this)))
                {
                    int idx = ParentColumn.Pagination.GetScaleformIndex(ParentColumn.Items.IndexOf(this));
                    if (ParentColumn.Parent is MainView lobby)
                        lobby._pause._lobby.CallFunction("SET_PLAYER_ITEM_STATUS", idx, status, statusColor);
                    else if (ParentColumn.Parent is TabView pause && ParentColumn.ParentTab.Visible)
                        pause._pause._pause.CallFunction("SET_PLAYERS_TAB_PLAYER_ITEM_STATUS", idx, status, statusColor);
                }
            }
        }
        public CrewTag CrewTag
        {
            get => crewTag;
            set
            {
                crewTag = value;
                if (crewTag == null)
                    crewTag = new CrewTag();
                if (ParentColumn is not null && ParentColumn.Parent is not null && ParentColumn.Parent.Visible && ParentColumn.Pagination.IsItemVisible(ParentColumn.Items.IndexOf(this)))
                {
                    int idx = ParentColumn.Pagination.GetScaleformIndex(ParentColumn.Items.IndexOf(this));
                    if (ParentColumn.Parent is MainView lobby)
                        lobby._pause._lobby.CallFunction("SET_PLAYER_ITEM_CREW", idx, crewTag.TAG);
                    else if (ParentColumn.Parent is TabView pause && ParentColumn.ParentTab.Visible)
                        pause._pause._pause.CallFunction("SET_PLAYERS_TAB_PLAYER_ITEM_CREW", idx, crewTag.TAG);
                }
            }
        }

        public FriendItem(string label, SColor itemColor, bool coloredTag, int rank, string status = "", CrewTag crewTag = null)
        {
            _type = 1;
            this.label = label;
            this.itemColor = itemColor;
            this.coloredTag = coloredTag;
            this.rank = rank;
            this.status = status;
            this.CrewTag = crewTag;
            if (this.itemColor == SColor.FromHudColor(HudColor.NONE))
                this.itemColor = SColor.FromHudColor(HudColor.HUD_COLOUR_BLUE);
            if (this.statusColor == SColor.FromHudColor(HudColor.NONE))
                this.statusColor = this.itemColor;
            this.iconL = 0;
            this.iconR = 65;
        }

        public void SetLeftIcon(LobbyBadgeIcon icon)
        {
            iconL = (int)icon;
            boolL = false;
            if (ParentColumn is not null && ParentColumn.Parent is not null && ParentColumn.Parent.Visible && ParentColumn.Pagination.IsItemVisible(ParentColumn.Items.IndexOf(this)))
            {
                int idx = ParentColumn.Pagination.GetScaleformIndex(ParentColumn.Items.IndexOf(this));
                if (ParentColumn.Parent is MainView lobby)
                    lobby._pause._lobby.CallFunction("SET_PLAYER_ITEM_ICON_LEFT", idx, iconL, boolL);
                else if (ParentColumn.Parent is TabView pause && ParentColumn.ParentTab.Visible)
                    pause._pause._pause.CallFunction("SET_PLAYERS_TAB_PLAYER_ICON_LEFT", idx, iconL, boolL);
            }
        }
        public void SetLeftIcon(BadgeIcon icon)
        {
            iconL = (int)icon;
            boolL = true;
            if (ParentColumn is not null && ParentColumn.Parent is not null && ParentColumn.Parent.Visible && ParentColumn.Pagination.IsItemVisible(ParentColumn.Items.IndexOf(this)))
            {
                int idx = ParentColumn.Pagination.GetScaleformIndex(ParentColumn.Items.IndexOf(this));
                if (ParentColumn.Parent is MainView lobby)
                    lobby._pause._lobby.CallFunction("SET_PLAYER_ITEM_ICON_LEFT", idx, iconL, boolL);
                else if (ParentColumn.Parent is TabView pause && ParentColumn.ParentTab.Visible)
                    pause._pause._pause.CallFunction("SET_PLAYERS_TAB_PLAYER_ICON_LEFT", idx, iconL, boolL);
            }
        }

        public void SetRightIcon(LobbyBadgeIcon icon)
        {
            iconR = (int)icon;
            boolR = false;
            if (ParentColumn is not null && ParentColumn.Parent is not null && ParentColumn.Parent.Visible && ParentColumn.Pagination.IsItemVisible(ParentColumn.Items.IndexOf(this)))
            {
                int idx = ParentColumn.Pagination.GetScaleformIndex(ParentColumn.Items.IndexOf(this));
                if (ParentColumn.Parent is MainView lobby)
                    lobby._pause._lobby.CallFunction("SET_PLAYER_ITEM_ICON_RIGHT", idx, iconR, boolR);
                else if (ParentColumn.Parent is TabView pause && ParentColumn.ParentTab.Visible)
                    pause._pause._pause.CallFunction("SET_PLAYERS_TAB_PLAYER_ICON_RIGHT", idx, iconR, boolR);
            }
        }
        public void SetRightIcon(BadgeIcon icon)
        {
            iconR = (int)icon;
            boolR = true;
            if (ParentColumn is not null && ParentColumn.Parent is not null && ParentColumn.Parent.Visible && ParentColumn.Pagination.IsItemVisible(ParentColumn.Items.IndexOf(this)))
            {
                int idx = ParentColumn.Pagination.GetScaleformIndex(ParentColumn.Items.IndexOf(this));
                if (ParentColumn.Parent is MainView lobby)
                    lobby._pause._lobby.CallFunction("SET_PLAYER_ITEM_ICON_RIGHT", idx, iconR, boolR);
                else if (ParentColumn.Parent is TabView pause && ParentColumn.ParentTab.Visible)
                    pause._pause._pause.CallFunction("SET_PLAYERS_TAB_PLAYER_ICON_RIGHT", idx, iconR, boolR);
            }
        }


        public void AddPanel(PlayerStatsPanel panel)
        {
            panel.ParentItem = this;
            this.Panel = panel;
            Panel.UpdatePanel();
        }
    }
}

using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ScaleformUI.LobbyMenu
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
        private HudColor itemColor;
        private int rank;
        private string status;
        private HudColor statusColor = HudColor.NONE;
        private string crewTag;
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
                if (ParentLobby != null && ParentLobby.Visible)
                {
                    var idx = ParentLobby.CenterItems.IndexOf(this);
                    ParentLobby._pause._lobby.CallFunction("SET_PLAYER_ITEM_LABEL", idx, label);
                }
            }
        }
        public HudColor ItemColor
        {
            get => itemColor;
            set
            {
                itemColor = value;
                if (ParentLobby != null && ParentLobby.Visible)
                {
                    var idx = ParentLobby.CenterItems.IndexOf(this);
                    ParentLobby._pause._lobby.CallFunction("SET_PLAYER_ITEM_COLOUR", idx, itemColor, coloredTag);
                }
            }
        }
        public bool ColoredTag
        {
            get => coloredTag;
            set
            {
                coloredTag = value;
                if (ParentLobby != null && ParentLobby.Visible)
                {
                    var idx = ParentLobby.CenterItems.IndexOf(this);
                    ParentLobby._pause._lobby.CallFunction("SET_PLAYER_ITEM_COLOUR", idx, (int)itemColor, coloredTag);
                }
            }
        }
        public int Rank
        {
            get => rank;
            set
            {
                rank = value;
                if (ParentLobby != null && ParentLobby.Visible)
                {
                    var idx = ParentLobby.CenterItems.IndexOf(this);
                    ParentLobby._pause._lobby.CallFunction("SET_PLAYER_ITEM_RANK", idx, rank);
                }
            }
        }
        public string Status
        {
            get => status;
            set
            {
                status = value;
                if (ParentLobby != null && ParentLobby.Visible)
                {
                    var idx = ParentLobby.CenterItems.IndexOf(this);
                    ParentLobby._pause._lobby.CallFunction("SET_PLAYER_ITEM_STATUS", idx, status, (int)statusColor);
                }
            }
        }
        public HudColor StatusColor
        {
            get => statusColor;
            set
            {
                statusColor = value;
                if (ParentLobby != null && ParentLobby.Visible)
                {
                    var idx = ParentLobby.CenterItems.IndexOf(this);
                    ParentLobby._pause._lobby.CallFunction("SET_PLAYER_ITEM_STATUS", idx, status, (int)statusColor);
                }
            }
        }
        public string CrewTag
        {
            get => crewTag;
            set
            {
                crewTag = value;
                if (ParentLobby != null && ParentLobby.Visible)
                {
                    var idx = ParentLobby.CenterItems.IndexOf(this);
                    ParentLobby._pause._lobby.CallFunction("SET_PLAYER_ITEM_CREW", idx, crewTag);
                }
            }
        }

        public FriendItem(string label, HudColor itemColor, bool coloredTag, int rank, string status = "", string crewTag = "")
        {
            _type = 1;
            this.label = label;
            this.itemColor = itemColor;
            this.coloredTag = coloredTag;
            this.rank = rank;
            this.status = status;
            this.crewTag = crewTag;
            if (this.itemColor == HudColor.NONE)
                this.itemColor = HudColor.HUD_COLOUR_BLUE;
            if (this.statusColor == HudColor.NONE)
                this.statusColor = this.itemColor;
            this.iconL = 0;
            this.iconR = 65;
        }

        public void SetLeftIcon(LobbyBadgeIcon icon)
        {
            iconL = (int)icon;
            boolL = false;
            if (ParentLobby != null && ParentLobby.Visible)
            {
                var idx = ParentLobby.CenterItems.IndexOf(this);
                ParentLobby._pause._lobby.CallFunction("SET_PLAYER_ITEM_ICON_RIGHT", idx, iconL, boolL);
            }
        }
        public void SetLeftIcon(BadgeIcon icon)
        {
            iconL = (int)icon;
            boolL = true;
            if (ParentLobby != null && ParentLobby.Visible)
            {
                var idx = ParentLobby.CenterItems.IndexOf(this);
                ParentLobby._pause._lobby.CallFunction("SET_PLAYER_ITEM_ICON_RIGHT", idx, iconL, boolL);
            }
        }

        public void SetRightIcon(LobbyBadgeIcon icon)
        {
            iconR = (int)icon;
            boolR = false;
            if (ParentLobby != null && ParentLobby.Visible)
            {
                var idx = ParentLobby.CenterItems.IndexOf(this);
                ParentLobby._pause._lobby.CallFunction("SET_PLAYER_ITEM_ICON_RIGHT", idx, iconR, boolR);
            }
        }
        public void SetRightIcon(BadgeIcon icon)
        {
            iconR = (int)icon;
            boolR = true;
            if (ParentLobby != null && ParentLobby.Visible)
            {
                var idx = ParentLobby.CenterItems.IndexOf(this);
                ParentLobby._pause._lobby.CallFunction("SET_PLAYER_ITEM_ICON_RIGHT", idx, iconR, boolR);
            }
        }

    }
}

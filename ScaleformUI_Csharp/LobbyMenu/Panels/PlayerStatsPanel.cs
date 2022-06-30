using CitizenFX.Core;
using ScaleformUI.PauseMenu;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ScaleformUI.LobbyMenu
{
    public class PlayerStatsPanel
    {
        public LobbyItem ParentItem { get; set; }
        private string title;
        private string description;
        private HudColor titleColor = HudColor.HUD_COLOUR_FREEMODE;
        private bool hasPlane = false;
        private bool hasVehicle = false;
        private bool hasBoat = false;
        private bool hasHeli = false;

        public UpperInformation RankInfo { get; set; }
        public string Title
        {
            get => title;
            set
            {
                title = value;
                UpdatePanel();
            }
        }
        public HudColor TitleColor
        {
            get => titleColor;
            set
            {
                titleColor = value;
                UpdatePanel();
            }
        }
        public string Description
        {
            get => description;
            set
            {
                description = value;
                UpdatePanel();
            }
        }
        public bool HasPlane
        {
            get => hasPlane;
            set
            {
                hasPlane = value;
                UpdatePanel();
            }
        }
        public bool HasHeli
        {
            get => hasHeli;
            set
            {
                hasHeli = value;
                UpdatePanel();
            }
        }
        public bool HasBoat
        {
            get => hasBoat;
            set
            {
                hasBoat = value;
                UpdatePanel();
            }
        }
        public bool HasVehicle
        {
            get => hasVehicle;
            set
            {
                hasVehicle = value;
                UpdatePanel();
            }
        }
        public List<PlayerStatsPanelStatItem> Items { get; private set; }
        public PlayerStatsPanel(string title, HudColor titleColor)
        {
            this.title = title;
            this.titleColor = titleColor;
            this.description = string.Empty;
            RankInfo = new(this);
            Items = new();
        }

        public void AddStat(PlayerStatsPanelStatItem item)
        {
            item.Parent = this;
            item.idx = Items.Count;
            Items.Add(item);
            UpdatePanel();
        }

        public void UpdatePanel(bool _override = false)
        {
            if ((ParentItem!= null && ParentItem.ParentColumn != null && ParentItem.ParentColumn.Parent != null && ParentItem.ParentColumn.Parent.Visible) || _override)
            {
                var idx = ParentItem.ParentColumn.Items.IndexOf(ParentItem);
                if (ParentItem.ParentColumn.Parent is MainView lobby)
                {
                    lobby._pause._lobby.CallFunction("SET_PLAYER_ITEM_PANEL", idx, 0, ParentItem.ClonePed != null, Title, Description, (int)TitleColor, RankInfo.RankLevel, HasPlane, HasHeli, HasBoat, HasVehicle, 0, RankInfo.LowLabel, 0, 0, RankInfo.MidLabel, 0, 0, RankInfo.UpLabel, 0, 0);
                    if (!string.IsNullOrWhiteSpace(Description))
                        lobby._pause._lobby.CallFunction("SET_PLAYER_ITEM_PANEL_DESCRIPTION", idx, Description, 0, "", ParentItem.ClonePed != null);
                    foreach (var stat in Items)
                        lobby._pause._lobby.CallFunction("SET_PLAYER_ITEM_PANEL_STAT", idx, stat.idx, 0, stat.Label, stat.Description, stat.Value);
                }
                else if (ParentItem.ParentColumn.Parent is TabView pause)
                {
                    pause._pause._pause.CallFunction("SET_PLAYERS_TAB_PLAYER_ITEM_PANEL", ParentItem.ParentColumn.ParentTab, idx, 0,ParentItem.ClonePed != null,  Title, Description, (int)TitleColor, RankInfo.RankLevel, HasPlane, HasHeli, HasBoat, HasVehicle, 0, RankInfo.LowLabel, 0, 0, RankInfo.MidLabel, 0, 0, RankInfo.UpLabel, 0, 0);
                    if (!string.IsNullOrWhiteSpace(Description))
                        pause._pause._pause.CallFunction("SET_PLAYERS_TAB_PLAYER_ITEM_PANEL_DESCRIPTION", ParentItem.ParentColumn.ParentTab, idx, Description, 0, "", ParentItem.ClonePed != null);
                    foreach (var stat in Items)
                        pause._pause._pause.CallFunction("SET_PLAYERS_TAB_PLAYER_ITEM_PANEL_STAT", ParentItem.ParentColumn.ParentTab, idx, stat.idx, 0, stat.Label, stat.Description, stat.Value);
                }
            }
        }
    }

    public sealed class UpperInformation
    {
        internal PlayerStatsPanel _parent;
        private int rankLevel = 0;
        private string upLabel = "";
        private string lowLabel = "";
        private string midLabel = "";

        public int RankLevel
        {
            get => rankLevel;
            set
            {
                rankLevel = value;
                _parent.UpdatePanel();
            }
        }
        public string UpLabel
        {
            get => upLabel;
            set
            {
                upLabel = value;
                _parent.UpdatePanel();
            }
        }
        public string MidLabel
        {
            get => midLabel;
            set
            {
                midLabel = value;
                _parent.UpdatePanel();
            }
        }
        public string LowLabel
        {
            get => lowLabel;
            set
            {
                lowLabel = value;
                _parent.UpdatePanel();
            }
        }
        public UpperInformation(PlayerStatsPanel parent)
        {
            _parent = parent;
        }
    }

    public sealed class PlayerStatsPanelStatItem
    {

        internal int idx;
        private int _value;
        private string description;
        private string label;
        public PlayerStatsPanel Parent { get; internal set; }
        public string Label
        {
            get => label;
            set
            {
                label = value;
                Parent.UpdatePanel();
            }
        }
        public string Description
        {
            get => description;
            set
            {
                description = value;
                Parent.UpdatePanel();
            }
        }
        public int Value
        {
            get => _value;
            set
            {
                _value = value;
                Parent.UpdatePanel();
            }
        }

        public PlayerStatsPanelStatItem(string label, string description, int value)
        {
            this.label = label;
            this.description = description;
            this._value = value;
        }
    }
}

using ScaleformUI.Elements;
using ScaleformUI.LobbyMenu;
using ScaleformUI.Menu;
using ScaleformUI.Menus;
using ScaleformUI.PauseMenu;
using ScaleformUI.PauseMenus.Elements.Items;
using ScaleformUI.Scaleforms;
using System.Collections.Generic;
using static CitizenFX.Core.Native.API;

namespace ScaleformUI.PauseMenus.Elements.Panels
{
    public class PlayerStatsPanel : PM_Column
    {
        public FriendItem ParentItem { get; set; }
        private string title;
        private ScaleformLabel description = "";
        private SColor titleColor = SColor.FromHudColor(HudColor.HUD_COLOUR_FREEMODE);
        private bool hasPlane = false;
        private bool hasVehicle = false;
        private bool hasBoat = false;
        private bool hasHeli = false;

        public UpperInformation RankInfo { get; set; }
        public BottomInformation CrewInfo { get; set; }

        public string Title
        {
            get => title;
            set
            {
                title = value;
                if (visible)
                    UpdatePanel();
            }
        }
        public SColor TitleColor
        {
            get => titleColor;
            set
            {
                titleColor = value;
                if (visible)
                    UpdatePanel();
            }
        }
        public ScaleformLabel Description
        {
            get => description;
            set
            {
                description = value;
                if (visible)
                    UpdatePanel();
            }
        }
        public bool HasPlane
        {
            get => hasPlane;
            set
            {
                hasPlane = value;
                if (visible)
                    UpdatePanel();
            }
        }
        public bool HasHeli
        {
            get => hasHeli;
            set
            {
                hasHeli = value;
                if (visible)
                    UpdatePanel();
            }
        }
        public bool HasBoat
        {
            get => hasBoat;
            set
            {
                hasBoat = value;
                if(visible)
                    UpdatePanel();
            }
        }
        public bool HasVehicle
        {
            get => hasVehicle;
            set
            {
                hasVehicle = value;
                if(visible)
                    UpdatePanel();
            }
        }
        public bool HardwareVisible { get; set; } = true;
        public List<UIFreemodeDetailsItem> DetailsItems { get; private set; }
        public PlayerStatsPanel(string title, SColor titleColor) : base(PM_COLUMNS.RIGHT)
        {
            VisibleItems = 10;
            this.title = title;
            this.titleColor = titleColor;
            this.description = string.Empty;
            RankInfo = new(this);
            CrewInfo = new(this);
            Items = new();
            DetailsItems = new();
        }

        public void AddStat(PlayerStatsPanelStatItem item)
        {
            item.Parent = this;
            Items.Add(item);
            if(visible)
                UpdatePanel();
        }

        public void AddDescriptionStatItem(UIFreemodeDetailsItem item)
        {
            DetailsItems.Add(item);
            if(visible)
                UpdatePanel();
        }

        public void UpdatePanel(bool _override = false)
        {
            if (ParentItem != null && ParentItem.ParentColumn != null && ParentItem.ParentColumn.visible || _override)
            {
                position = ParentItem?.ClonePed == null ? PM_COLUMNS.EXTRA3 : PM_COLUMNS.EXTRA4;
                Parent = ParentItem?.ParentColumn?.Parent;
                Populate();
                ShowColumn();
            }
        }

        public override void Populate()
        {
            Main.PauseMenu._pause.CallFunction("SET_DATA_SLOT_EMPTY", (int)position);
            if(CrewInfo.isFilled)
                Main.PauseMenu._pause.CallFunction("SET_COLUMN_TITLE", (int)position, Title, CrewInfo.CrewName, TitleColor, "", CrewInfo.RankName, ParentItem.CrewTag != null ? ParentItem.CrewTag.TAG : "", CrewInfo.CrewDict, CrewInfo.CrewTxtr, CrewInfo.CrewTag, CrewInfo.CrewColor.R, CrewInfo.CrewColor.G, CrewInfo.CrewColor.B, 0, "");
            else
                Main.PauseMenu._pause.CallFunction("SET_COLUMN_TITLE", (int)position, Title, "", TitleColor, "", "", ParentItem.CrewTag != null ? ParentItem.CrewTag.TAG : "", "", "", "", 0, 0, 0, 0, "");
            Main.PauseMenu._pause.CallFunction("SET_DATA_SLOT", (int)position, 0, 0, 0, 0, HasPlane, HasHeli, HasBoat, HasVehicle, 0, RankInfo.RankLevel, RankInfo.LowLabel, 0, 0, RankInfo.MidLabel, 0, 0, RankInfo.UpLabel, 0, 0, HardwareVisible);
            for (int i = 0; i < Items.Count; i++)
            {
                PlayerStatsPanelStatItem stat = (PlayerStatsPanelStatItem)Items[i];
                Main.PauseMenu._pause.CallFunction("SET_DATA_SLOT", (int)position, 1, i, 0, stat.Label, stat.Description, stat.Value);
            }
            if (DetailsItems.Count > 0 && position == PM_COLUMNS.EXTRA3)
            {
                for (int i = 0; i < DetailsItems.Count; i++)
                {
                    UIFreemodeDetailsItem item = DetailsItems[i];
                    BeginScaleformMovieMethod(Main.PauseMenu._pause.Handle, "SET_DATA_SLOT");
                    PushScaleformMovieFunctionParameterInt((int)position);
                    PushScaleformMovieFunctionParameterInt(2);
                    PushScaleformMovieFunctionParameterInt(i);
                    PushScaleformMovieFunctionParameterInt(0);
                    PushScaleformMovieFunctionParameterInt(0);
                    PushScaleformMovieFunctionParameterInt(item.Type);
                    PushScaleformMovieFunctionParameterInt(0);
                    PushScaleformMovieFunctionParameterBool(true);
                    var labels = item.Label.SplitLabel;
                    BeginTextCommandScaleformString("CELL_EMAIL_BCON");
                    for (var j = 0; j < labels?.Length; j++)
                        AddTextComponentScaleform(labels[j]);
                    EndTextCommandScaleformString_2();
                    PushScaleformMovieFunctionParameterString(item.TextRight);
                    switch (item.Type)
                    {
                        case 2:
                            PushScaleformMovieFunctionParameterInt((int)item.Icon);
                            PushScaleformMovieFunctionParameterInt(item.IconColor.ArgbValue);
                            PushScaleformMovieFunctionParameterBool(item.Tick);
                            break;
                        case 3:
                            PushScaleformMovieFunctionParameterString(item.CrewTag.TAG);
                            PushScaleformMovieFunctionParameterBool(false);
                            break;
                    }
                    PushScaleformMovieFunctionParameterString(item.LabelFont.FontName);
                    PushScaleformMovieFunctionParameterString(item._rightLabelFont.FontName);
                    EndScaleformMovieMethod();
                }
            }
            else if (!string.IsNullOrWhiteSpace(Description.Label) && !CrewInfo.isFilled)
            {
                BeginScaleformMovieMethod(Main.PauseMenu._pause.Handle, "SET_DESCRIPTION");
                PushScaleformMovieFunctionParameterInt((int)position);
                var labels = description.SplitLabel;
                BeginTextCommandScaleformString("CELL_EMAIL_BCON");
                for (var j = 0; j < labels?.Length; j++)
                    AddTextComponentScaleform(labels[j]);
                EndTextCommandScaleformString_2();
                PushScaleformMovieFunctionParameterInt(0);
                PushScaleformMovieFunctionParameterString(ParentItem.CrewTag != null ? ParentItem.CrewTag.TAG : "");//crewtag?
                PushScaleformMovieFunctionParameterBool(ParentItem.ClonePed != null);
                EndScaleformMovieMethod();

            }
        }

        public override void SetDataSlot(int index)
        {
            Populate();
        }


        public override void UpdateSlot(int index)
        {
            if (index >= Items.Count) return;
            if (visible)
                Populate();
        }

        public override void AddSlot(int index)
        {
            if (index >= Items.Count) return;
            if (visible)
                Populate();
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
                if (_parent.visible)
                    _parent.UpdatePanel();
            }
        }
        public string UpLabel
        {
            get => upLabel;
            set
            {
                upLabel = value;
                if (_parent.visible)
                    _parent.UpdatePanel();
            }
        }
        public string MidLabel
        {
            get => midLabel;
            set
            {
                midLabel = value;
                if (_parent.visible)
                    _parent.UpdatePanel();
            }
        }
        public string LowLabel
        {
            get => lowLabel;
            set
            {
                lowLabel = value;
                if (_parent.visible)
                    _parent.UpdatePanel();
            }
        }
        public UpperInformation(PlayerStatsPanel parent)
        {
            _parent = parent;
        }
    }

    public sealed class BottomInformation
    {
        internal bool isFilled => !string.IsNullOrWhiteSpace(CrewName) && !string.IsNullOrWhiteSpace(RankName) && !string.IsNullOrWhiteSpace(CrewDict) && !string.IsNullOrWhiteSpace(CrewTxtr) && !string.IsNullOrWhiteSpace(CrewTag);
        private PlayerStatsPanel _parent;
        private string crewName = "";
        private string rankName = "";
        private string crewDict = "";
        private string crewTxtr = "";
        private string crewtag = "";
        private SColor crewColor = SColor.HUD_Pure_white;

        public string CrewName
        {
            get => crewName;
            set
            {
                crewName = value;
                if (_parent.visible)
                    _parent.UpdatePanel();
            }
        }
        public string RankName
        {
            get => rankName;
            set
            {
                rankName = value;
                if (_parent.visible)
                    _parent.UpdatePanel();
            }
        }
        public string CrewDict
        {
            get => crewDict;
            set
            {
                crewDict = value;
                if (_parent.visible)
                    _parent.UpdatePanel();
            }
        }
        public string CrewTxtr
        {
            get => crewTxtr;
            set
            {
                crewTxtr = value;
                if (_parent.visible)
                    _parent.UpdatePanel();
            }
        }
        public SColor CrewColor
        {
            get => crewColor;
            set
            {
                crewColor = value;
                if (_parent.visible)
                    _parent.UpdatePanel();
            }
        }
        public string CrewTag
        {
            get => crewtag;
            set
            {
                crewtag = value;
                if (_parent.visible)
                    _parent.UpdatePanel();
            }
        }

        public BottomInformation(PlayerStatsPanel parent)
        {
            _parent = parent;
        }
    }

    public sealed class PlayerStatsPanelStatItem : PauseMenuItem
    {

        internal int idx { get; set; }
        private int _value;
        private string description;
        private string label;
        public new PlayerStatsPanel Parent { get; internal set; }
        public new string Label
        {
            get => label;
            set
            {
                base.Label = value;
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

        public PlayerStatsPanelStatItem(string label, string description, int value) : base(label)
        {
            this.label = label;
            this.description = description;
            this._value = value;
        }
    }
}

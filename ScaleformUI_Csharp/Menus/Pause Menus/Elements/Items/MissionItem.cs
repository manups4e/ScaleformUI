using ScaleformUI.Elements;
using ScaleformUI.LobbyMenu;
using ScaleformUI.Menu;
using ScaleformUI.PauseMenu;
using ScaleformUI.PauseMenus.Elements.Columns;
using ScaleformUI.Scaleforms;
using System.Drawing;

namespace ScaleformUI.PauseMenus.Elements.Items
{
    public delegate void MissionActivated(PlayerListTab tab, MissionsListColumn column, MissionItem item);
    public class MissionItem : PauseMenuItem
    {
        private bool enabled = true;
        internal int type = 0;
        internal KeyValuePair<string, string> customLeftBadge;
        internal KeyValuePair<string, string> customRightBadge;
        internal bool rIcChecked;
        public bool Jumpable { get; internal set; }
        public new string Label { get => base.Label.Label; set => base.Label = value; }
        public MissionsListColumn ParentColumn { get; internal set; }
        public SColor MainColor { get; private set; } = SColor.FromHudColor(HudColor.HUD_COLOUR_PAUSE_BG);
        public SColor HighlightColor { get; private set; } = SColor.FromHudColor(HudColor.HUD_COLOUR_WHITE);
        public BadgeIcon LeftIcon { get; private set; } = BadgeIcon.NONE;
        public SColor LeftIconColor { get; private set; } = SColor.FromHudColor(HudColor.HUD_COLOUR_WHITE);
        public BadgeIcon RightIcon { get; private set; } = BadgeIcon.NONE;
        public SColor RightIconColor { get; private set; } = SColor.FromHudColor(HudColor.HUD_COLOUR_WHITE);
        public bool RightIconChecked { get; private set; }
        public bool Hovered { get; internal set; }
        public bool Enabled
        {
            get => enabled; set
            {
                enabled = value;
            }
        }

        public event MissionActivated MissionActivated;
        public void ActivateMission(PlayerListTab tab)
        {
            MissionActivated?.Invoke(tab, ParentColumn, this);
        }

        public MissionItem(string label) : this(label, SColor.FromHudColor(HudColor.HUD_COLOUR_PAUSE_BG), SColor.FromHudColor(HudColor.HUD_COLOUR_WHITE)) { }

        public MissionItem(string label, SColor mainColor, SColor highlightColor) : base(label)
        {
            MainColor = mainColor;
            HighlightColor = highlightColor;
            type = 0;
            customLeftBadge = new KeyValuePair<string, string>("", "");
            customRightBadge = new KeyValuePair<string, string>("", "");
        }

        public virtual void SetLeftIcon(BadgeIcon icon, SColor color)
        {
            LeftIcon = icon;
            LeftIconColor = color;
        }
        public virtual void SetRightIcon(BadgeIcon icon, SColor color, bool @checked = false)
        {
            RightIcon = icon;
            RightIconColor = color;
            RightIconChecked = @checked;
        }

        public virtual void SetCustomLeftIcon(string txd, string txn)
        {
            LeftIcon = BadgeIcon.CUSTOM;
            customLeftBadge = new KeyValuePair<string, string>(txd, txn);
        }

        public virtual void SetCustomRightIcon(string txd, string txn, bool @checked = false)
        {
            RightIcon = BadgeIcon.CUSTOM;
            customRightBadge = new KeyValuePair<string, string>(txd, txn);
            rIcChecked = @checked;
        }
    }
    public class MissionSeparatorItem : MissionItem
    {
        /// <summary>
        /// Use it to create an Empty item to separate Mission Items
        /// </summary>
        public MissionSeparatorItem(string title, bool jumpable) : base(title)
        {
            type = 1;
            Jumpable = jumpable;
            customLeftBadge = new KeyValuePair<string, string>("","");
            customRightBadge = new KeyValuePair<string, string>("", ""); 
        }

        public override void SetLeftIcon(BadgeIcon badge, SColor color)
        {
            throw new Exception("MissionSeparatorItem cannot have a left badge.");
        }
        public override void SetRightIcon(BadgeIcon badge, SColor color, bool @checked = false)
        {
            throw new Exception("MissionSeparatorItem cannot have a right badge.");
        }
    }
}

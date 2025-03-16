using CitizenFX.Core.Native;
using ScaleformUI.Elements;
using ScaleformUI.LobbyMenu;
using ScaleformUI.Menus;
using ScaleformUI.PauseMenu;
using ScaleformUI.PauseMenus.Elements.Columns;

namespace ScaleformUI.Menu
{
    public enum BadgeIcon
    {
        CUSTOM = -1,
        NONE,
        LOCK,
        STAR,
        WARNING,
        CROWN,
        MEDAL_BRONZE,
        MEDAL_GOLD,
        MEDAL_SILVER,
        CASH,
        COKE,
        HEROIN,
        METH,
        WEED,
        AMMO,
        ARMOR,
        BARBER,
        CLOTHING,
        FRANKLIN,
        BIKE,
        CAR,
        GUN,
        HEALTH_HEART,
        MAKEUP_BRUSH,
        MASK,
        MICHAEL,
        TATTOO,
        TICK,
        TREVOR,
        FEMALE,
        MALE,
        LOCK_ARENA,
        ADVERSARY,
        BASE_JUMPING,
        BRIEFCASE,
        MISSION_STAR,
        DEATHMATCH,
        CASTLE,
        TROPHY,
        RACE_FLAG,
        RACE_FLAG_PLANE,
        RACE_FLAG_BICYCLE,
        RACE_FLAG_PERSON,
        RACE_FLAG_CAR,
        RACE_FLAG_BOAT_ANCHOR,
        ROCKSTAR,
        STUNT,
        STUNT_PREMIUM,
        RACE_FLAG_STUNT_JUMP,
        SHIELD,
        TEAM_DEATHMATCH,
        VEHICLE_DEATHMATCH,
        MP_AMMO_PICKUP,
        MP_AMMO,
        MP_CASH,
        MP_RP,
        MP_SPECTATING,
        SALE,
        GLOBE_WHITE,
        GLOBE_RED,
        GLOBE_BLUE,
        GLOBE_YELLOW,
        GLOBE_GREEN,
        GLOBE_ORANGE,
        INV_ARM_WRESTLING,
        INV_BASEJUMP,
        INV_MISSION,
        INV_DARTS,
        INV_DEATHMATCH,
        INV_DRUG,
        INV_CASTLE,
        INV_GOLF,
        INV_BIKE,
        INV_BOAT,
        INV_ANCHOR,
        INV_CAR,
        INV_DOLLAR,
        INV_COKE,
        INV_KEY,
        INV_DATA,
        INV_HELI,
        INV_HEORIN,
        INV_KEYCARD,
        INV_METH,
        INV_BRIEFCASE,
        INV_LINK,
        INV_PERSON,
        INV_PLANE,
        INV_PLANE2,
        INV_QUESTIONMARK,
        INV_REMOTE,
        INV_SAFE,
        INV_STEER_WHEEL,
        INV_WEAPON,
        INV_WEED,
        INV_RACE_FLAG_PLANE,
        INV_RACE_FLAG_BICYCLE,
        INV_RACE_FLAG_BOAT_ANCHOR,
        INV_RACE_FLAG_PERSON,
        INV_RACE_FLAG_CAR,
        INV_RACE_FLAG_HELMET,
        INV_SHOOTING_RANGE,
        INV_SURVIVAL,
        INV_TEAM_DEATHMATCH,
        INV_TENNIS,
        INV_VEHICLE_DEATHMATCH,
        AUDIO_MUTE,
        AUDIO_INACTIVE,
        AUDIO_VOL1,
        AUDIO_VOL2,
        AUDIO_VOL3,
        COUNTRY_USA,
        COUNTRY_UK,
        COUNTRY_SWEDEN,
        COUNTRY_KOREA,
        COUNTRY_JAPAN,
        COUNTRY_ITALY,
        COUNTRY_GERMANY,
        COUNTRY_FRANCE,
        BRAND_ALBANY,
        BRAND_ANNIS,
        BRAND_BANSHEE,
        BRAND_BENEFACTOR,
        BRAND_BF,
        BRAND_BOLLOKAN,
        BRAND_BRAVADO,
        BRAND_BRUTE,
        BRAND_BUCKINGHAM,
        BRAND_CANIS,
        BRAND_CHARIOT,
        BRAND_CHEVAL,
        BRAND_CLASSIQUE,
        BRAND_COIL,
        BRAND_DECLASSE,
        BRAND_DEWBAUCHEE,
        BRAND_DILETTANTE,
        BRAND_DINKA,
        BRAND_DUNDREARY,
        BRAND_EMPORER,
        BRAND_ENUS,
        BRAND_FATHOM,
        BRAND_GALIVANTER,
        BRAND_GROTTI,
        BRAND_GROTTI2,
        BRAND_HIJAK,
        BRAND_HVY,
        BRAND_IMPONTE,
        BRAND_INVETERO,
        BRAND_JACKSHEEPE,
        BRAND_LCC,
        BRAND_JOBUILT,
        BRAND_KARIN,
        BRAND_LAMPADATI,
        BRAND_MAIBATSU,
        BRAND_MAMMOTH,
        BRAND_MTL,
        BRAND_NAGASAKI,
        BRAND_OBEY,
        BRAND_OCELOT,
        BRAND_OVERFLOD,
        BRAND_PED,
        BRAND_PEGASSI,
        BRAND_PFISTER,
        BRAND_PRINCIPE,
        BRAND_PROGEN,
        BRAND_PROGEN2,
        BRAND_RUNE,
        BRAND_SCHYSTER,
        BRAND_SHITZU,
        BRAND_SPEEDOPHILE,
        BRAND_STANLEY,
        BRAND_TRUFFADE,
        BRAND_UBERMACHT,
        BRAND_VAPID,
        BRAND_VULCAR,
        BRAND_WEENY,
        BRAND_WESTERN,
        BRAND_WESTERNMOTORCYCLE,
        BRAND_WILLARD,
        BRAND_ZIRCONIUM,
        INFO,
        MISSION_YELLOW,
        MISSION_BLUE,
        MISSION_GREEN,
        MISSION_PURPLE,
        MISSION_ORANGE,
        MISSION_RED,
        MISSION_AQUA,
        MISSION_LIGHTRED,
        PLUS,
        ARROW_LEFT,
        ARROW_RIGHT,
    }
    /// <summary>
    /// Simple item with a label.
    /// </summary>
    public class UIMenuItem : PauseMenuItem
    {
        internal int _itemId = 0;
        internal string _formatLeftLabel = "";
        internal string _formatRightLabel = "";
        private bool _selected = false;
        private string _label = "";
        private string _rightLabel = "";
        private bool _enabled;
        private bool blinkDescription;
        private SColor mainColor;
        private SColor highlightColor;
        private string description;
        internal ItemFont labelFont = ScaleformFonts.CHALET_LONDON_NINETEENSIXTY;
        internal ItemFont rightLabelFont = ScaleformFonts.CHALET_LONDON_NINETEENSIXTY;
        internal KeyValuePair<string, string> customLeftBadge = new KeyValuePair<string, string>("", "");
        internal KeyValuePair<string, string> customRightBadge = new KeyValuePair<string, string>("", "");

        /// <summary>
        /// The item color when not highlighted
        /// </summary>
        public SColor MainColor
        {
            get => mainColor;
            set
            {
                mainColor = value;
                if (Parent != null && Parent.Visible)
                    Parent.SendItemToScaleform(Parent.MenuItems.IndexOf(this), true);
            }
        }
        /// <summary>
        /// The item color when highlighted
        /// </summary>
        public SColor HighlightColor
        {
            get => highlightColor;
            set
            {
                highlightColor = value;
                if (Parent != null && Parent.Visible)
                    Parent.SendItemToScaleform(Parent.MenuItems.IndexOf(this), true);
            }
        }
        /// <summary>
        /// The item text color when not highlighted
        /// </summary>

        public ItemFont LabelFont
        {
            get => labelFont;
            set
            {
                labelFont = value;
                if (Parent != null && Parent.Visible)
                    Parent.SendItemToScaleform(Parent.MenuItems.IndexOf(this), true);
                if (ParentColumn != null && ParentColumn.Parent.Visible)
                {
                    if (ParentColumn.Parent is MainView lobby)
                        lobby._pause._lobby.CallFunction("SET_SETTINGS_ITEM_LABEL_FONT", ParentColumn.Pagination.GetScaleformIndex(ParentColumn.Items.IndexOf(this)), labelFont.FontName, labelFont.FontID);
                    else if (ParentColumn.Parent is TabView pause && ParentColumn.ParentTab.Visible)
                        pause._pause._pause.CallFunction("SET_PLAYERS_TAB_SETTINGS_ITEM_LABEL_FONT", ParentColumn.Pagination.GetScaleformIndex(ParentColumn.Items.IndexOf(this)), labelFont.FontName, labelFont.FontID);
                }
            }
        }

        public ItemFont RightLabelFont
        {
            get => rightLabelFont;
            set
            {
                rightLabelFont = value;
                if (Parent != null && Parent.Visible)
                    Parent.SendItemToScaleform(Parent.MenuItems.IndexOf(this), true);
                if (ParentColumn != null && ParentColumn.Parent.Visible)
                {
                    if (ParentColumn.Parent is MainView lobby)
                        lobby._pause._lobby.CallFunction("SET_SETTINGS_ITEM_RIGHT_LABEL_FONT", ParentColumn.Pagination.GetScaleformIndex(ParentColumn.Items.IndexOf(this)), labelFont.FontName, labelFont.FontID);
                    else if (ParentColumn.Parent is TabView pause && ParentColumn.ParentTab.Visible)
                        pause._pause._pause.CallFunction("SET_PLAYERS_TAB_SETTINGS_ITEM_RIGHT_LABEL_FONT", ParentColumn.Pagination.GetScaleformIndex(ParentColumn.Items.IndexOf(this)), labelFont.FontName, labelFont.FontID);
                }
            }
        }

        public List<UIMenuPanel> Panels = new();

        public UIMenuSidePanel SidePanel { get; set; }


        // Allows you to attach data to a menu item if you want to identify the menu item without having to put identification info in the visible text or description.
        // Taken from MenuAPI (Thanks Tom).
        public dynamic ItemData { get; set; }

        /// <summary>
        /// Called when user selects the current item.
        /// </summary>
        public event ItemActivatedEvent Activated;
        public event ItemActivatedEvent OnTabPressed;

        /// <summary>
        /// Called when user "highlights" the current item.
        /// </summary>
        public event ItemHighlightedEvent Highlighted;

        /// <summary>
        /// Basic menu button.
        /// </summary>
        /// <param name="text">Button label.</param>
        public UIMenuItem(string text) : this(text, "") { }

        /// <summary>
        /// Basic menu button with description.
        /// </summary>
        /// <param name="text">Button label.</param>
        /// <param name="description">Description.</param>
        public UIMenuItem(string text, string description) : this(text, description, SColor.HUD_Panel_light, SColor.HUD_White) { }

        /// <summary>
        /// Basic menu item with description and colors.
        /// </summary>
        /// <param name="text">Item's label.</param>
        /// <param name="description">Item's description</param>
        /// <param name="color">Main Color</param>
        /// <param name="highlightColor">Highlighted Color</param>
        public UIMenuItem(string text, string description, SColor color, SColor highlightColor) : base(text)
        {
            _enabled = true;
            MainColor = color;
            HighlightColor = highlightColor;
            Label = text;
            Description = description;
        }


        /// <summary>
        /// Should the Info symbol blink?
        /// </summary>
        public bool BlinkDescription
        {
            get => blinkDescription;
            set
            {
                blinkDescription = value;
                if (Parent != null && Parent.Visible)
                    Parent.SendItemToScaleform(Parent.MenuItems.IndexOf(this), true);
                if (ParentColumn != null && ParentColumn.Parent.Visible)
                {
                    if (ParentColumn.Parent is MainView lobby)
                        lobby._pause._lobby.CallFunction("UPDATE_SETTINGS_ITEM_BLINK_DESC", ParentColumn.Pagination.GetScaleformIndex(ParentColumn.Items.IndexOf(this)), blinkDescription);
                    else if (ParentColumn.Parent is TabView pause && ParentColumn.ParentTab.Visible)
                        pause._pause._pause.CallFunction("UPDATE_PLAYERS_TAB_SETTINGS_ITEM_BLINK_DESC", ParentColumn.Pagination.GetScaleformIndex(ParentColumn.Items.IndexOf(this)), blinkDescription);
                }
            }
        }

        /// <summary>
        /// Whether this item is currently selected.
        /// </summary>
        public virtual bool Selected
        {
            get => _selected;
            internal set
            {
                _selected = value;
                if (value)
                {
                    _formatLeftLabel = _formatLeftLabel.Replace("~w~", "~l~").Replace("~s~", "~l~");
                    if (!string.IsNullOrWhiteSpace(_formatRightLabel))
                        _formatRightLabel = _formatRightLabel.Replace("~w~", "~l~").Replace("~s~", "~l~");
                    Highlighted?.Invoke(Parent, this);
                }
                else
                {
                    _formatLeftLabel = _formatLeftLabel.Replace("~l~", "~s~");
                    if (!string.IsNullOrWhiteSpace(_formatRightLabel))
                        _formatRightLabel = _formatRightLabel.Replace("~l~", "~s~");
                }
                if (Parent != null && Parent.Visible)
                    Parent.SendItemToScaleform(Parent.MenuItems.IndexOf(this), true);
                if (ParentColumn != null && ParentColumn.Parent != null && ParentColumn.Parent.Visible)
                {
                    if (ParentColumn.Parent is MainView lobby)
                        lobby._pause._lobby.CallFunction("UPDATE_SETTINGS_ITEM_LABELS", ParentColumn.Pagination.GetScaleformIndex(ParentColumn.Items.IndexOf(this)), _formatLeftLabel, _formatRightLabel);
                    else if (ParentColumn.Parent is TabView pause && ParentColumn.ParentTab.Visible)
                        pause._pause._pause.CallFunction("UPDATE_PLAYERS_TAB_SETTINGS_ITEM_LABELS", ParentColumn.Pagination.GetScaleformIndex(ParentColumn.Items.IndexOf(this)), _formatLeftLabel, _formatRightLabel);
                }
            }
        }


        /// <summary>
        /// Whether this item is currently being hovered on with a mouse.
        /// </summary>
        public virtual bool Hovered { get; internal set; }

        /// <summary>
        /// This item's description.
        /// </summary>
        public virtual string Description
        {
            get => description;
            set
            {
                description = value;
                if (Parent != null && Parent.Visible)
                {
                    API.AddTextEntry("UIMenu_Current_Description", value);
                    Parent.SendItemToScaleform(Parent.MenuItems.IndexOf(this), true);
                }
                if (ParentColumn != null && ParentColumn.Parent.Visible)
                {
                    API.AddTextEntry("PAUSEMENU_Current_Description", value);
                    ParentColumn.UpdateDescription();
                }
            }
        }


        /// <summary>
        /// Whether this item is enabled or disabled (text is greyed out and you cannot select it).
        /// </summary>
        public virtual bool Enabled
        {
            get => _enabled;
            set
            {
                _enabled = value;
                if (!value)
                    _formatLeftLabel = _formatLeftLabel.ReplaceRstarColorsWith("~c~");
                else
                    Label = _label;
                if (Parent != null && Parent.Visible)
                    Parent.SendItemToScaleform(Parent.MenuItems.IndexOf(this), true);
                if (ParentColumn != null && ParentColumn.Parent.Visible && ParentColumn.Pagination.IsItemVisible(ParentColumn.Items.IndexOf(this)))
                {
                    if (ParentColumn.Parent is MainView lobby)
                    {
                        lobby._pause._lobby.CallFunction("UPDATE_SETTINGS_ITEM_LABELS", ParentColumn.Pagination.GetScaleformIndex(ParentColumn.Items.IndexOf(this)), _formatLeftLabel, _formatRightLabel);
                        lobby._pause._lobby.CallFunction("ENABLE_SETTINGS_ITEM", ParentColumn.Pagination.GetScaleformIndex(ParentColumn.Items.IndexOf(this)), _enabled);
                    }
                    else if (ParentColumn.Parent is TabView pause && ParentColumn.ParentTab.Visible)
                    {
                        pause._pause._pause.CallFunction("UPDATE_PLAYERS_TAB_SETTINGS_ITEM_LABELS", ParentColumn.Pagination.GetScaleformIndex(ParentColumn.Items.IndexOf(this)), _formatLeftLabel, _formatRightLabel);
                        pause._pause._pause.CallFunction("ENABLE_PLAYERS_TAB_SETTINGS_ITEM", ParentColumn.Pagination.GetScaleformIndex(ParentColumn.Items.IndexOf(this)), _enabled);
                    }
                }
            }
        }

        internal virtual void ItemActivate(UIMenu sender)
        {
            Activated?.Invoke(sender, this);
        }



        /// <summary>
        /// Returns this item's label.
        /// </summary>
        public virtual string Label
        {
            get => _label;
            set
            {
                _label = value;
                _formatLeftLabel = value.StartsWith("~") ? value : "~s~" + value;
                _formatLeftLabel = !_enabled ? _formatLeftLabel.ReplaceRstarColorsWith("~c~") : _selected ? _formatLeftLabel.Replace("~w~", "~l~").Replace("~s~", "~l~") : _formatLeftLabel.Replace("~l~", "~s~");
                if (Parent != null && Parent.Visible)
                    Parent.SendItemToScaleform(Parent.MenuItems.IndexOf(this), true);
                if (ParentColumn != null && ParentColumn.Parent.Visible)
                {
                    if (ParentColumn.Parent is MainView lobby)
                        lobby._pause._lobby.CallFunction("UPDATE_SETTINGS_ITEM_LABEL", ParentColumn.Pagination.GetScaleformIndex(ParentColumn.Items.IndexOf(this)), _formatLeftLabel);
                    else if (ParentColumn.Parent is TabView pause && ParentColumn.ParentTab.Visible)
                        pause._pause._pause.CallFunction("UPDATE_PLAYERS_TAB_SETTINGS_ITEM_LABEL", ParentColumn.Pagination.GetScaleformIndex(ParentColumn.Items.IndexOf(this)), _formatLeftLabel);
                }
            }
        }


        /// <summary>
        /// Set the left badge. Set it to None to remove the badge.
        /// </summary>
        /// <param name="badge"></param>
        public virtual void SetLeftBadge(BadgeIcon badge)
        {
            LeftBadge = badge;
            if (Parent != null && Parent.Visible)
                Parent.SendItemToScaleform(Parent.MenuItems.IndexOf(this), true);
            if (ParentColumn != null && ParentColumn.Parent.Visible)
            {
                if (ParentColumn.Parent is MainView lobby)
                    lobby._pause._lobby.CallFunction("SET_SETTINGS_ITEM_LEFT_BADGE", ParentColumn.Pagination.GetScaleformIndex(ParentColumn.Items.IndexOf(this)), (int)badge);
                else if (ParentColumn.Parent is TabView pause && ParentColumn.ParentTab.Visible)
                    pause._pause._pause.CallFunction("SET_PLAYERS_TAB_SETTINGS_ITEM_LEFT_BADGE", ParentColumn.Pagination.GetScaleformIndex(ParentColumn.Items.IndexOf(this)), (int)badge);
            }
        }

        /// <summary>
        /// Set the right badge. Set it to None to remove the badge.
        /// </summary>
        /// <param name="badge"></param>
        public virtual void SetRightBadge(BadgeIcon badge)
        {
            RightBadge = badge;
            if (Parent != null && Parent.Visible)
                Parent.SendItemToScaleform(Parent.MenuItems.IndexOf(this), true);
            if (ParentColumn != null && ParentColumn.Parent.Visible)
            {
                if (ParentColumn.Parent is MainView lobby)
                    lobby._pause._lobby.CallFunction("SET_SETTINGS_ITEM_RIGHT_BADGE", ParentColumn.Pagination.GetScaleformIndex(ParentColumn.Items.IndexOf(this)), (int)badge);
                else if (ParentColumn.Parent is TabView pause && ParentColumn.ParentTab.Visible)
                    pause._pause._pause.CallFunction("SET_PLAYERS_TAB_SETTINGS_ITEM_RIGHT_BADGE", ParentColumn.Pagination.GetScaleformIndex(ParentColumn.Items.IndexOf(this)), (int)badge);
            }
        }

        /// <summary>
        /// Set the right badge with a custom texture. 
        /// Use SetRightBadge(BadgeIcon.NONE) to remove the badge.
        /// </summary>
        /// <param name="txd">The texture dictionary.</param>
        /// <param name="txn">The texture name.</param>
        public virtual void SetCustomRightBadge(string txd, string txn)
        {
            RightBadge = BadgeIcon.CUSTOM;
            customRightBadge = new KeyValuePair<string, string>(txd, txn);
            if (Parent != null && Parent.Visible)
                Parent.SendItemToScaleform(Parent.MenuItems.IndexOf(this), true);
            if (ParentColumn != null && ParentColumn.Parent.Visible)
            {
                if (ParentColumn.Parent is MainView lobby)
                    lobby._pause._lobby.CallFunction("SET_SETTINGS_ITEM_CUSTOM_RIGHT_BADGE", ParentColumn.Pagination.GetScaleformIndex(ParentColumn.Items.IndexOf(this)), txd, txn);
                else if (ParentColumn.Parent is TabView pause && ParentColumn.ParentTab.Visible)
                    pause._pause._pause.CallFunction("SET_PLAYERS_TAB_SETTINGS_ITEM_CUSTOM_RIGHT_BADGE", ParentColumn.Pagination.GetScaleformIndex(ParentColumn.Items.IndexOf(this)), txd, txn);
            }
        }

        /// <summary>
        /// Set the left badge with a custom texture. 
        /// Use SetLeftBadge(BadgeIcon.NONE) to remove the badge.
        /// </summary>
        /// <param name="txd">The texture dictionary.</param>
        /// <param name="txn">The texture name.</param>
        public virtual void SetCustomLeftBadge(string txd, string txn)
        {
            LeftBadge = BadgeIcon.CUSTOM;
            customLeftBadge = new KeyValuePair<string, string>(txd, txn);
            if (Parent != null && Parent.Visible)
                Parent.SendItemToScaleform(Parent.MenuItems.IndexOf(this), true);
            if (ParentColumn != null && ParentColumn.Parent.Visible)
            {
                if (ParentColumn.Parent is MainView lobby)
                    lobby._pause._lobby.CallFunction("SET_SETTINGS_ITEM_CUSTOM_LEFT_BADGE", ParentColumn.Pagination.GetScaleformIndex(ParentColumn.Items.IndexOf(this)), txd, txn);
                else if (ParentColumn.Parent is TabView pause && ParentColumn.ParentTab.Visible)
                    pause._pause._pause.CallFunction("SET_PLAYERS_TAB_SETTINGS_ITEM_CUSTOM_LEFT_BADGE", ParentColumn.Pagination.GetScaleformIndex(ParentColumn.Items.IndexOf(this)), txd, txn);
            }
        }


        /// <summary>
        /// Set the right label.
        /// </summary>
        /// <param name="text">Text as label. Set it to "" to remove the label.</param>
        public virtual void SetRightLabel(string text)
        {
            RightLabel = text;
        }

        /// <summary>
        /// Returns the current right label.
        /// </summary>
        public virtual string RightLabel
        {
            get => _rightLabel;
            private set
            {
                _rightLabel = value;
                _formatRightLabel = value.StartsWith("~") ? value : "~s~" + value;
                _formatRightLabel = !_enabled ? _formatRightLabel.ReplaceRstarColorsWith("~c~") : _selected ? _formatRightLabel .Replace("~w~", "~l~").Replace("~s~", "~l~") : _formatRightLabel .Replace("~l~", "~s~");
                if (Parent != null && Parent.Visible)
                    Parent.SendItemToScaleform(Parent.MenuItems.IndexOf(this), true);
                if (ParentColumn != null && ParentColumn.Parent.Visible)
                {
                    if (ParentColumn.Parent is MainView lobby)
                        lobby._pause._lobby.CallFunction("UPDATE_SETTINGS_ITEM_LABEL_RIGHT", ParentColumn.Pagination.GetScaleformIndex(ParentColumn.Items.IndexOf(this)), _formatRightLabel);
                    else if (ParentColumn.Parent is TabView pause && ParentColumn.ParentTab.Visible)
                        pause._pause._pause.CallFunction("UPDATE_PLAYERS_TAB_SETTINGS_ITEM_LABEL_RIGHT", ParentColumn.Pagination.GetScaleformIndex(ParentColumn.Items.IndexOf(this)), _formatRightLabel);
                }
            }
        }

        /// <summary>
        /// Returns the current left badge.
        /// </summary>
        public virtual BadgeIcon LeftBadge { get; private set; } = BadgeIcon.NONE;

        /// <summary>
        /// Add a Panel to the UIMenuItem
        /// </summary>
        /// <param name="panel"></param>
        public virtual void AddPanel(UIMenuPanel panel)
        {
            Panels.Add(panel);
            panel.SetParentItem(this);
        }

        /// <summary>
        /// Removes a panel at a defined Index
        /// </summary>
        /// <param name="Index"></param>
        public virtual void RemovePanelAt(int Index)
        {
            Panels.RemoveAt(Index);
            if (Parent != null && Parent.Visible)
                Parent.SendItemToScaleform(Parent.MenuItems.IndexOf(this), true);
        }

        /// <summary>
        /// Adds a side panel to the menu binded to this item
        /// </summary>
        /// <param name="panel">the panel to add</param>
        public virtual void AddSidePanel(UIMenuSidePanel panel)
        {
            panel.SetParentItem(this);
            SidePanel = panel;
            if (Parent != null && Parent.Visible)
                Parent.SendItemToScaleform(Parent.MenuItems.IndexOf(this), true);
        }

        /// <summary>
        /// Removes the side panel from this item
        /// </summary>
        public virtual void RemoveSidePanel()
        {
            SidePanel = null;
            if (Parent != null && Parent.Visible)
                Parent.SendItemToScaleform(Parent.MenuItems.IndexOf(this), true);
        }

        /// <summary>
        /// Returns the current right badge.
        /// </summary>
        public virtual BadgeIcon RightBadge { get; private set; }

        /// <summary>
        /// Returns the menu this item is in.
        /// </summary>
        public UIMenu Parent { get; internal set; }

        /// <summary>
        /// Returns the lobby this item is in.
        /// </summary>
        public SettingsListColumn ParentColumn { get; internal set; }

        internal virtual void TabItemActivate(UIMenu sender)
        {
            OnTabPressed?.Invoke(sender, this);
        }

    }
}

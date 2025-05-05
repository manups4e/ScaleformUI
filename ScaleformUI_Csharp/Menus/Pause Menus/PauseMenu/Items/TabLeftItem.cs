using ScaleformUI.Elements;
using ScaleformUI.Menu;
using ScaleformUI.Menus;

namespace ScaleformUI.PauseMenu
{
    public enum LeftItemType
    {
        Empty,
        Info,
        Statistics,
        Settings,
        Keymap
    }

    public enum LeftItemBGType
    {
        Full,
        Masked,
        Resized
    }

    public delegate void IndexChangeEvent(SettingsItem item, int index);
    public delegate void ActivatedEvent(TabLeftItem item, int index);

    public class TabLeftItem : PauseMenuItem
    {
        internal UIMenuItem _internalItem { get; set; }
        private bool enabled = true;
        private SColor mainColor = SColor.HUD_Pause_bg;
        private SColor highlightColor = SColor.HUD_White;
        private string textTitle;
        private string _label = "";
        internal string _formatLeftLabel = "";
        private string keymapRightLabel_1;
        private string keymapRightLabel_2;
        public string TextureDict { get; private set; }
        public string TextureName { get; private set; }
        public LeftItemBGType LeftItemBGType { get; private set; }

        internal ItemFont _labelFont = ScaleformFonts.CHALET_LONDON_NINETEENSIXTY;
        internal ItemFont _rightLabelFont = ScaleformFonts.CHALET_LONDON_NINETEENSIXTY;
        public LeftItemType ItemType { get; internal set; }
        public new string Label
        {
            get => _label;
            set
            {
                _label = value;
                _formatLeftLabel = value.StartsWith("~") ? value : "~s~" + value;
                _formatLeftLabel = !Enabled ? _formatLeftLabel.ReplaceRstarColorsWith("~c~") : Selected ? _formatLeftLabel.Replace("~w~", "~l~").Replace("~s~", "~l~") : _formatLeftLabel.Replace("~l~", "~s~");
            }
        }
        public SColor MainColor { get => mainColor; set => mainColor = value; }
        public SColor HighlightColor { get => highlightColor; set => highlightColor = value; }
        public bool Enabled
        {
            get => enabled;
            set
            {
                enabled = value;
                if (!value)
                    _formatLeftLabel = _formatLeftLabel.ReplaceRstarColorsWith("~c~");
                else
                    Label = _label;

                if (ParentTab != null && ParentTab.Visible)
                {
                    int it = ParentTab.LeftColumn.Items.IndexOf(this);
                    ParentTab.UpdateSlot(PM_COLUMNS.LEFT, it);
                }
            }
        }

        public bool Hovered { get; internal set; }

        public override bool Selected
        {
            get => selected;
            set
            {
                selected = value;
                if (value)
                    _formatLeftLabel = _formatLeftLabel.Replace("~w~", "~l~").Replace("~s~", "~l~");
                else
                    _formatLeftLabel = _formatLeftLabel.Replace("~l~", "~s~");
                int it = ParentTab.LeftColumn.Items.IndexOf(this);
                ParentTab.UpdateSlot(PM_COLUMNS.LEFT, it);
            }
        }

        public int ItemIndex { get; internal set; }
        public List<PauseMenuItem> ItemList { get; set; } = new List<PauseMenuItem>();
        private bool selected;

        public string RightTitle
        {
            get => textTitle;
            set
            {
                textTitle = value;
                if (ParentTab != null && ParentTab.Visible)
                {
                    int it = ParentTab.LeftColumn.Items.IndexOf(this);
                    ParentTab.UpdateSlot(PM_COLUMNS.LEFT, it);
                }
            }
        }

        public string KeymapRightLabel_1
        {
            get => keymapRightLabel_1;
            set
            {
                keymapRightLabel_1 = value;
                if (ParentTab != null && ParentTab.Visible)
                {
                    int it = ParentTab.LeftColumn.Items.IndexOf(this);
                    ParentTab.UpdateSlot(PM_COLUMNS.LEFT, it);
                }
            }
        }
        public string KeymapRightLabel_2
        {
            get => keymapRightLabel_2;
            set
            {
                keymapRightLabel_2 = value;
                if (ParentTab != null && ParentTab.Visible)
                {
                    int it = ParentTab.LeftColumn.Items.IndexOf(this);
                    ParentTab.UpdateSlot(PM_COLUMNS.LEFT, it);
                }
            }
        }

        public event ActivatedEvent OnActivated;
        public new SubmenuTab ParentTab { get; set; }

        public TabLeftItem(string label, LeftItemType type) : this(label, type, SColor.HUD_Pause_bg, SColor.HUD_White) { }
        public TabLeftItem(string label, LeftItemType type, SColor mainColor, SColor highlightColor) : base(label)
        {
            Label = label;
            ItemType = type;
            MainColor = mainColor;
            HighlightColor = highlightColor;
            _internalItem = new UIMenuItem(label, "", SColor.HUD_Pause_bg, SColor.HUD_White);
        }
        public TabLeftItem(string label, LeftItemType type, ItemFont labelFont, SColor mainColor, SColor highlightColor) : base(label)
        {
            Label = label;
            ItemType = type;
            MainColor = mainColor;
            HighlightColor = highlightColor;
            _labelFont = labelFont;
            _internalItem = new UIMenuItem(label, "", SColor.HUD_Pause_bg, SColor.HUD_White);
        }

        /// <summary>
        /// Image suggested not bigger than 720 x 576
        /// </summary>
        /// <param name="txd"></param>
        /// <param name="txn"></param>
        public void UpdateBackground(string txd, string txn, LeftItemBGType resizeType)
        {
            TextureDict = txd;
            TextureName = txn;
            LeftItemBGType = resizeType;
            if (ParentTab != null && ParentTab.Visible && ParentTab.Parent != null && ParentTab.Parent.Visible && this.ItemType != LeftItemType.Empty)
            {
                int it = ParentTab.LeftColumn.Items.IndexOf(this);
                ParentTab.UpdateSlot(PM_COLUMNS.LEFT, it);
            }
        }

        public void AddItem(PauseMenuItem item)
        {
            item.ParentLeftItem = this;
            item.ParentTab = ParentTab;
            ItemList.Add(item);
        }

        internal void Activated()
        {
            OnActivated?.Invoke(this, ParentTab.LeftColumn.Items.IndexOf(this));
        }
    }
}
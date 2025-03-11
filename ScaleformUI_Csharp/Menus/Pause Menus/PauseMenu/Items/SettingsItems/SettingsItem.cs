namespace ScaleformUI.PauseMenu
{
    public enum SettingsItemType
    {
        Basic,
        ListItem,
        ProgressBar,
        CheckBox,
        MaskedProgressBar = 4,
        BlipType,
        Separator,
        SliderBar,
        Empty,
        Basic_tabbed = 10,
        Progress_tabbed = 20
    }

    public delegate void SettingsItemSelected(SettingsItem item);

    public class SettingsItem : BasicTabItem
    {
        private string rightLabel;
        private bool enabled = true;

        public event SettingsItemSelected OnActivate;
        public bool Enabled
        {
            get => enabled;
            set
            {
                enabled = value;
                if (Parent != null && Parent.Parent != null && Parent.Parent.Visible && Parent.Parent.Parent != null && Parent.Parent.Parent.Visible && Parent.Parent.CenterColumn.Items.Contains(this))
                    Parent?.Parent?.UpdateSlot(Menus.PM_COLUMNS.MIDDLE, Parent.Parent.CenterColumn.Items.IndexOf(this));
            }
        }
        public bool Hovered { get; internal set; }
        public bool Selected { get; internal set; }
        public SettingsItemType ItemType { get; set; }

        public string RightLabel
        {
            get => rightLabel;
            set
            {
                rightLabel = value;
                if (Parent != null && Parent.Parent != null && Parent.Parent.Visible && Parent.Parent.Parent != null && Parent.Parent.Parent.Visible && Parent.Parent.CenterColumn.Items.Contains(this))
                    Parent?.Parent?.UpdateSlot(Menus.PM_COLUMNS.MIDDLE, Parent.Parent.CenterColumn.Items.IndexOf(this));
            }
        }

        public SettingsItem(string label, string rightLabel) : base(label)
        {
            ItemType = SettingsItemType.Basic;
            Label = label;
            RightLabel = rightLabel;
        }

        internal void Activated()
        {
            if (ItemType == SettingsItemType.Basic)
            {
                OnActivate?.Invoke(this);
            }
        }
    }
}

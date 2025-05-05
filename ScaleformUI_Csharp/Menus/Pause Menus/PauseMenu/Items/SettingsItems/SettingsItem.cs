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

    public class SettingsItem : PauseMenuItem
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
                if (ParentColumn != null && ParentColumn.visible)
                    ParentColumn.UpdateSlot(ParentColumn.Items.IndexOf(this));
            }
        }
        public bool Hovered { get; internal set; }
        public SettingsItemType ItemType { get; set; }

        public string RightLabel
        {
            get => rightLabel;
            set
            {
                rightLabel = value;
                if (ParentColumn != null && ParentColumn.visible)
                    ParentColumn.UpdateSlot(ParentColumn.Items.IndexOf(this));
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

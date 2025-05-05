using ScaleformUI.Elements;

namespace ScaleformUI.PauseMenu
{
    public delegate void SettingsProgressEvent(SettingsProgressItem item, int value);
    public class SettingsProgressItem : SettingsItem
    {
        internal int _value;
        private SColor coloredBarColor = SColor.HUD_Freemode;
        public event SettingsProgressEvent OnBarChanged;
        public event SettingsProgressEvent OnProgressSelected;
        public int MaxValue { get; set; } = 100;
        public int Value
        {
            get => _value;
            set
            {
                _value = value;
                if (ParentColumn != null && ParentColumn.visible)
                    ParentColumn.UpdateSlot(ParentColumn.Items.IndexOf(this));
                ProgressChanged();
            }
        }
        public SColor ColoredBarColor
        {
            get => coloredBarColor;
            set
            {
                coloredBarColor = value;
                if (ParentColumn != null && ParentColumn.visible)
                    ParentColumn.UpdateSlot(ParentColumn.Items.IndexOf(this));
            }
        }
        public SettingsProgressItem(string label, int max, int startIndex, bool masked, SColor barColor) : base(label, "")
        {
            if (masked)
                ItemType = SettingsItemType.MaskedProgressBar;
            else
                ItemType = SettingsItemType.ProgressBar;
            Label = label;
            MaxValue = max;
            Value = startIndex;
            ColoredBarColor = barColor;
        }

        public void ProgressSelected()
        {
            OnProgressSelected?.Invoke(this, Value);
        }
        public void ProgressChanged()
        {
            OnBarChanged?.Invoke(this, Value);
        }
    }
}

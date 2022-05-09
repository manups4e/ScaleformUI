using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ScaleformUI.PauseMenu
{
    public delegate void SettingsProgressEvent(SettingsProgressItem item, int value);
    public class SettingsProgressItem : SettingsItem
    {
        private int _value;
        private HudColor coloredBarColor;
        public event SettingsProgressEvent OnBarChanged;
        public event SettingsProgressEvent OnProgressSelected;
        public int MaxValue { get; set; } = 100;
        public int Value
        {
            get => _value;
            set
            {
                _value = value;
                if (Parent != null)
                {
                    int tab = Parent.Parent.Parent.Tabs.IndexOf(Parent.Parent);
                    int leftItem = Parent.Parent.LeftItemList.IndexOf(Parent);
                    int rightIndex = Parent.ItemList.IndexOf(this);
                    Parent.Parent.Parent._pause.SetRightSettingsItemValue(tab, leftItem, rightIndex, _value);
                }
                ProgressChanged();
            }
        }
        public HudColor ColoredBarColor
        {
            get => coloredBarColor;
            set
            {
                coloredBarColor = value;
                if (Parent != null)
                {
                    int tab = Parent.Parent.Parent.Tabs.IndexOf(Parent.Parent);
                    int leftItem = Parent.Parent.LeftItemList.IndexOf(Parent);
                    int rightIndex = Parent.ItemList.IndexOf(this);
                    Parent.Parent.Parent._pause.UpdateItemColoredBar(tab, leftItem, rightIndex, coloredBarColor);
                }
            }
        }
        public SettingsProgressItem(string label, int max, int startIndex, bool masked, HudColor barColor = HudColor.HUD_COLOUR_FREEMODE) : base(label, "")
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

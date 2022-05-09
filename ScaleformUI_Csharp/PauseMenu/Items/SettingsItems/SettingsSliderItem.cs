using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ScaleformUI.PauseMenu
{
    public delegate void SettingsSliderEvent(SettingsSliderItem item, int value);
    public class SettingsSliderItem : SettingsItem
    {
        private int _value;
        private HudColor coloredBarColor;
        public event SettingsSliderEvent OnBarChanged;
        public event SettingsSliderEvent OnSliderSelected;
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
                OnBarChanged?.Invoke(this, _value);
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

        public SettingsSliderItem(string label, int max, int startIndex, HudColor barColor = HudColor.HUD_COLOUR_FREEMODE) : base(label, "")
        {
            ItemType = SettingsItemType.SliderBar;
            Label = label;
            MaxValue = max;
            Value = startIndex;
            ColoredBarColor = barColor;
        }

        public void SliderChanged()
        {
            OnBarChanged?.Invoke(this, Value);
        }

        public void SliderSelected()
        {
            OnSliderSelected?.Invoke(this, Value);
        }
    }
}

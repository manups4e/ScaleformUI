using ScaleformUI.Elements;

namespace ScaleformUI.PauseMenu
{
    public delegate void SettingsSliderEvent(SettingsSliderItem item, int value);
    public class SettingsSliderItem : SettingsItem
    {
        private int _value;
        private SColor coloredBarColor = SColor.HUD_Freemode;
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
                    int leftItem = Parent.Parent.LeftItemList.IndexOf(Parent);
                    int rightIndex = Parent.ItemList.IndexOf(this);
                    Parent.Parent.Parent._pause.SetRightSettingsItemValue(leftItem, rightIndex, _value);
                }
                OnBarChanged?.Invoke(this, _value);
            }
        }
        public SColor ColoredBarColor
        {
            get => coloredBarColor;
            set
            {
                coloredBarColor = value;
                if (Parent != null)
                {
                    int leftItem = Parent.Parent.LeftItemList.IndexOf(Parent);
                    int rightIndex = Parent.ItemList.IndexOf(this);
                    Parent.Parent.Parent._pause.UpdateItemColoredBar(leftItem, rightIndex, coloredBarColor);
                }
            }
        }

        public SettingsSliderItem(string label, int max, int startIndex, SColor barColor) : base(label, "")
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

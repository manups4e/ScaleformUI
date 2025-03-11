using ScaleformUI.Elements;

namespace ScaleformUI.PauseMenu
{
    public enum StatItemType
    {
        Basic,
        ColoredBar
    }
    public class StatsTabItem : BasicTabItem
    {
        private string rightLabel;
        private SColor coloredBarColor = SColor.HUD_Freemode;
        private int _value;
        internal ItemFont labelFont = ScaleformFonts.CHALET_LONDON_NINETEENSIXTY;
        internal ItemFont rightLabelFont = ScaleformFonts.CHALET_LONDON_NINETEENSIXTY;


        public StatItemType Type { get; set; }
        public string RightLabel
        {
            get => rightLabel;
            set
            {
                rightLabel = value;
                if (Parent != null)
                {
                    int leftItem = Parent.Parent.LeftItemList.IndexOf(Parent);
                    int rightIndex = Parent.ItemList.IndexOf(this);
                    //Parent.Parent.Parent._pause.UpdateStatsItem(leftItem, rightIndex, Label, rightLabel);
                }
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
                    //Parent.Parent.Parent._pause.UpdateStatsItem(leftItem, rightIndex, Label, _value, coloredBarColor);
                }
            }
        }
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
                    //Parent.Parent.Parent._pause.UpdateStatsItem(leftItem, rightIndex, Label, _value, coloredBarColor);
                }
            }
        }

        public StatsTabItem(string label, string rightLabel) : base(label)
        {
            Type = StatItemType.Basic;
            Label = label;
            RightLabel = rightLabel;
        }

        public StatsTabItem(string label, int value, SColor color) : base(label)
        {
            Type = StatItemType.ColoredBar;
            Label = label;
            Value = value;
            ColoredBarColor = color;
        }
    }
}

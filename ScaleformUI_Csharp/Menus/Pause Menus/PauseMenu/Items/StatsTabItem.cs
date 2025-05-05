using ScaleformUI.Elements;

namespace ScaleformUI.PauseMenu
{
    public enum StatItemType
    {
        Basic,
        ColoredBar
    }
    public class StatsTabItem : PauseMenuItem
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
                if (ParentColumn != null && ParentColumn.visible)
                    ParentColumn.UpdateSlot(ParentColumn.Items.IndexOf(this));
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
        public int Value
        {
            get => _value;
            set
            {
                _value = value;
                if (ParentColumn != null && ParentColumn.visible)
                    ParentColumn.UpdateSlot(ParentColumn.Items.IndexOf(this));
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

using ScaleformUI.Elements;

namespace ScaleformUI.PauseMenu
{
    public class BasicTabItem
    {
        public ItemFont LabelFont = ScaleformFonts.CHALET_LONDON_NINETEENSIXTY;
        public string Label { get; set; }
        public TabLeftItem Parent { get; set; }
        public BasicTabItem(string label)
        {
            Label = label;
        }
        public BasicTabItem(string label, ItemFont labelFont)
        {
            Label = label;
            LabelFont = labelFont;
        }
    }
}

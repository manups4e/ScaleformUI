using ScaleformUI.Elements;

namespace ScaleformUI.PauseMenu
{
    public class PauseMenuItem
    {
        public ItemFont LabelFont = ScaleformFonts.CHALET_LONDON_NINETEENSIXTY;
        public ScaleformLabel Label { get; set; }
        public TabLeftItem Parent { get; set; }
        public PauseMenuItem(string label)
        {
            Label = label;
        }
        public PauseMenuItem(string label, ItemFont labelFont)
        {
            Label = label;
            LabelFont = labelFont;
        }
    }
}

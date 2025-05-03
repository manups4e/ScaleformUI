using ScaleformUI.Elements;
using ScaleformUI.Menus;

namespace ScaleformUI.PauseMenu
{
    public class PauseMenuItem
    {
        public ItemFont LabelFont = ScaleformFonts.CHALET_LONDON_NINETEENSIXTY;
        public ScaleformLabel Label { get; set; }
        public TabLeftItem ParentLeftItem { get; set; }
        public BaseTab ParentTab { get; set; }
        public PM_Column ParentColumn { get; set; }
        public PauseMenuItem(string label)
        {
            Label = label;
        }
        public PauseMenuItem(string label, ItemFont labelFont)
        {
            Label = label;
            LabelFont = labelFont;
        }

        public virtual bool Selected { get; set; }
    }
}

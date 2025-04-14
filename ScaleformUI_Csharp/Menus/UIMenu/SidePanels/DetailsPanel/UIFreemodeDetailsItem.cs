using ScaleformUI.Elements;
using ScaleformUI.PauseMenu;
using ScaleformUI.PauseMenus.Elements;

namespace ScaleformUI.Menu
{
    public class UIFreemodeDetailsItem : PauseMenuItem
    {
        public string TextRight = "";
        public BadgeIcon Icon = BadgeIcon.NONE;
        public SColor IconColor = SColor.HUD_None;
        public int Type;
        public bool Tick;
        internal ItemFont _rightLabelFont = ScaleformFonts.CHALET_LONDON_NINETEENSIXTY;
        internal CrewTag CrewTag = new CrewTag();

        public UIFreemodeDetailsItem(string description): this(description, ScaleformFonts.CHALET_LONDON_NINETEENSIXTY)
        {
        }
        public UIFreemodeDetailsItem(string description, ItemFont labelFont) : base(description, labelFont)
        {
            Type = 5;
            LabelFont = labelFont;
        }
        public UIFreemodeDetailsItem(string textLeft, string textRight, bool separator) : this(textLeft, textRight, separator, ScaleformFonts.CHALET_LONDON_NINETEENSIXTY)
        {
        }

        public UIFreemodeDetailsItem(string textLeft, string textRight, bool separator, ItemFont labelFont) : this(textLeft, textRight, separator, labelFont, ScaleformFonts.CHALET_LONDON_NINETEENSIXTY)
        {
        }

        public UIFreemodeDetailsItem(string textLeft, string textRight, bool separator, ItemFont labelFont, ItemFont rightLabelFont) : base(textLeft, labelFont)
        {
            Type = separator ? 4 : 0;
            TextRight = textRight;
            _rightLabelFont = rightLabelFont;
        }

        public UIFreemodeDetailsItem(string textLeft, CrewTag crewTag) : this(textLeft, ScaleformFonts.CHALET_LONDON_NINETEENSIXTY, crewTag)
        {
        }

        public UIFreemodeDetailsItem(string textLeft, ItemFont labelFont, CrewTag crewTag) : base(textLeft, labelFont)
        {
            Type = 3;
            CrewTag = crewTag;
        }

        public UIFreemodeDetailsItem(string textLeft, string textRight, BadgeIcon icon, SColor iconColor, bool tick = false) : this(textLeft, textRight, ScaleformFonts.CHALET_LONDON_NINETEENSIXTY, icon, iconColor, tick)
        {
        }
 
        public UIFreemodeDetailsItem(string textLeft, string textRight, ItemFont labelFont, BadgeIcon icon, SColor iconColor, bool tick = false) : this(textLeft, textRight, labelFont, ScaleformFonts.CHALET_LONDON_NINETEENSIXTY, icon, iconColor, tick)
        {
        }

        public UIFreemodeDetailsItem(string textLeft, string textRight, ItemFont labelFont, ItemFont rightLabelFont, BadgeIcon icon, SColor iconColor, bool tick = false) : base(textLeft, labelFont)
        {
            Type = 2;
            TextRight = textRight;
            Icon = icon;
            IconColor = iconColor;
            Tick = tick;
            _rightLabelFont = rightLabelFont;
        }
    }
}

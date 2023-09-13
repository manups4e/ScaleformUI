using ScaleformUI.Elements;
using ScaleformUI.Scaleforms;

namespace ScaleformUI.Menu
{
    public class UIFreemodeDetailsItem
    {
        public string TextLeft;
        public string TextRight = "";
        public BadgeIcon Icon = BadgeIcon.NONE;
        public HudColor IconColor = HudColor.NONE;
        public int Type;
        public bool Tick;
        internal ItemFont _labelFont = ScaleformFonts.CHALET_LONDON_NINETEENSIXTY;
        internal ItemFont _rightLabelFont = ScaleformFonts.CHALET_LONDON_NINETEENSIXTY;

        public UIFreemodeDetailsItem(string description)
        {
            Type = 4;
            TextLeft = description;
        }
        public UIFreemodeDetailsItem(string description, ItemFont labelFont)
        {
            Type = 4;
            TextLeft = description;
            _labelFont = labelFont;
        }
        public UIFreemodeDetailsItem(string textLeft, string textRight, bool separator)
        {
            Type = separator ? 3 : 0;
            TextLeft = textLeft;
            TextRight = textRight;
        }

        public UIFreemodeDetailsItem(string textLeft, string textRight, bool separator, ItemFont labelFont)
        {
            Type = separator ? 3 : 0;
            TextLeft = textLeft;
            TextRight = textRight;
            _labelFont = labelFont;
        }

        public UIFreemodeDetailsItem(string textLeft, string textRight, bool separator, ItemFont labelFont, ItemFont rightLabelFont)
        {
            Type = separator ? 3 : 0;
            TextLeft = textLeft;
            TextRight = textRight;
            _labelFont = labelFont;
            _rightLabelFont = rightLabelFont;
        }

        public UIFreemodeDetailsItem(string textLeft, string textRight, BadgeIcon icon, HudColor iconColor = HudColor.NONE, bool tick = false)
        {
            Type = 2;
            TextLeft = textLeft;
            TextRight = textRight;
            Icon = icon;
            IconColor = iconColor;
            Tick = tick;
        }
        public UIFreemodeDetailsItem(string textLeft, string textRight, ItemFont labelFont, BadgeIcon icon, HudColor iconColor = HudColor.NONE, bool tick = false)
        {
            Type = 2;
            TextLeft = textLeft;
            TextRight = textRight;
            Icon = icon;
            IconColor = iconColor;
            Tick = tick;
            _labelFont = labelFont;
        }
        public UIFreemodeDetailsItem(string textLeft, string textRight, ItemFont labelFont, ItemFont rightLabelFont, BadgeIcon icon, HudColor iconColor = HudColor.NONE, bool tick = false)
        {
            Type = 2;
            TextLeft = textLeft;
            TextRight = textRight;
            Icon = icon;
            IconColor = iconColor;
            Tick = tick;
            _labelFont = labelFont;
            _rightLabelFont = rightLabelFont;
        }
    }
}

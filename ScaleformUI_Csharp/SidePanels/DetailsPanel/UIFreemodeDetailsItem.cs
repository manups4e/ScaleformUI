using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ScaleformUI
{
    public class UIFreemodeDetailsItem
    {
        public string TextLeft;
        public string TextRight;
        public BadgeIcon Icon;
        public HudColor IconColor;
        public int Type;
        public bool Tick;
        public UIFreemodeDetailsItem(string textLeft, string textRight, bool separator)
        {
            Type = separator ? 3 : 0;
            TextLeft = textLeft;
            TextRight = textRight;
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
    }
}

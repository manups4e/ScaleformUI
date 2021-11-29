using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace NativeUI
{
    public class UIMenuStatsItem : UIMenuItem
    {
        public int Value;
        public int Type;
        public HudColor Color;

        public UIMenuStatsItem(string text) : this(text, "", 0, 0, HudColor.HUD_COLOUR_FREEMODE)
        {
        }

        public UIMenuStatsItem(string text, string subtitle, int value, int type, HudColor color) : base(text, subtitle)
        {
            Type = type;
            Value = value;
            Color = color;
        }
    }
}

using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ScaleformUI
{
    public class UIMenuStatsItem : UIMenuItem
    {
        public int Value { get; set; }
        public int Type { get; set; }
        public HudColor Color { get; set; }

        public UIMenuStatsItem(string text) : this(text, "", 0, HudColor.HUD_COLOUR_FREEMODE)
        {
        }

        public UIMenuStatsItem(string text, string subtitle, int value, HudColor color) : base(text, subtitle)
        {
            Type = 0;
            Value = value;
            Color = color;
        }

        public void SetValue(int value)
        {
            Value = value;
            ScaleformUI._ui.CallFunction("SET_ITEM_VALUE", value);
        }

    }
}

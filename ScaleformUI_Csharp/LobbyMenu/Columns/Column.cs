using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ScaleformUI.LobbyMenu
{
    public delegate void IndexChanged(int index);
    public class Column
    {
        public string Label;
        public HudColor Color;
        public int Order;
        public Column(string label, HudColor color)
        {
            Label = label;
            Color = color;
        }
    }
}

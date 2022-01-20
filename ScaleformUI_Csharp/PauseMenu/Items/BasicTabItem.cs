using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ScaleformUI.PauseMenu
{
    public class BasicTabItem
    {
        public string Label { get; set; }
        public TabLeftItem Parent { get; set; }
        public BasicTabItem( string label )
        {
            Label = label;
        }
    }
}

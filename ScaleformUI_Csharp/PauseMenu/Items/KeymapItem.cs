using CitizenFX.Core;
using CitizenFX.Core.Native;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ScaleformUI.PauseMenu
{
    public class KeymapItem : BasicTabItem
    {
        public string PrimaryKeyboard;
        public string PrimaryGamepad;
        public string SecondaryKeyboard;
        public string SecondaryGamepad;
        public KeymapItem(string title, string primaryKeyboard) : this(title, primaryKeyboard, "") { }
        public KeymapItem(string title, string primaryKeyboard, string secondaryKeyboard) : base(title)
        {
            PrimaryKeyboard = primaryKeyboard;
            PrimaryGamepad = primaryKeyboard;
            SecondaryKeyboard = secondaryKeyboard;
            SecondaryGamepad = secondaryKeyboard;
        }
        public KeymapItem(string title, string primaryKeyboard, string primaryGamepad, string secondaryKeyboard, string secondaryGamepad) : base(title)
        {
            PrimaryKeyboard = primaryKeyboard;
            PrimaryGamepad = primaryGamepad;
            SecondaryKeyboard = secondaryKeyboard;
            SecondaryGamepad = secondaryGamepad;
        }
    }
}

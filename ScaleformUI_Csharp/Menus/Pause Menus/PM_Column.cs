using CitizenFX.Core.Native;
using ScaleformUI.Elements;
using ScaleformUI.PauseMenu;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ScaleformUI.Menus
{
    public enum PM_COLUMNS
    {
        LEFT,
        MIDDLE,
        RIGHT,
        EXTRA3,
        EXTRA4,
        LEFT_MIDDLE,
        MIDDLE_RIGHT,
    };
    public class PM_Column
    {
        internal PM_COLUMNS position;
        private int index = 0;

        internal List<BasicTabItem> Items { get; set; }
        internal int Index { 
            get => index;
            set
            {
                index = value;
                if(index < 0)
                    index = Items.Count - 1;
                if(index >= Items.Count)
                    index = 0;
                //TODO: ADD INDEX CHANGE EVENT HERE
            } 
        }

        public PM_Column(PM_COLUMNS position)
        {
            Items = new List<BasicTabItem>();
            this.position = position;
        }
        public PM_Column(int position) : this((PM_COLUMNS)position)
        {
        }

        public void AddItem(BasicTabItem item)
        {
            Items.Add(item);
        }
    }
}

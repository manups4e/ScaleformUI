using System.Collections.Generic;
using System.Drawing;
using CitizenFX.Core.Native;
using CitizenFX.Core;

namespace ScaleformUI.PauseMenu
{
    public class TabSubmenuItem : BaseTab
    {
        private bool _focused;
        public TabSubmenuItem(string name) : base(name)
        {
        }

        public List<BasicTabItem> Items = new List<BasicTabItem>();
        public int Index { get; set; } = 0;
        public bool IsInList { get; set; }

        public override bool Focused
        {
            get { return _focused; }
            set
            {
                _focused = value;
                //if (!value) Items[Index].Focused = false;
            }
        }

        public void AddLeftItem(TabLeftItem item)
        {
            item.Parent = this;
            LeftItemList.Add(item);
        }
    }
}
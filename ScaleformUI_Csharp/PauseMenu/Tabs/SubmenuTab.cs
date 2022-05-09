using System.Collections.Generic;
using System.Drawing;
using CitizenFX.Core.Native;
using CitizenFX.Core;

namespace ScaleformUI.PauseMenu
{
    public class SubmenuTab : BaseTab
    {
        private bool _focused;
        public SubmenuTab(string name) : base(name)
        {
            _type = 1;
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
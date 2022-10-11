using System;
using System.Collections.Generic;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ScaleformUI
{
    public class UIMenuPanel
    {
        public UIMenuPanel()
        {
        }
        public virtual bool Selected { get; set; }
        public virtual bool Enabled { get; set; }
        public virtual void UpdateParent()
        {
        }
        public void SetParentItem(UIMenuItem item)
        {
            ParentItem = item;
        }

        public UIMenuItem ParentItem { get; set; }

    }
}

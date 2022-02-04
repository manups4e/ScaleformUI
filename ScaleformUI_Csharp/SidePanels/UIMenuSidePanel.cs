using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ScaleformUI
{
	public enum PanelSide
    {
		Left,
		Right
    }
    public class UIMenuSidePanel
    {
		public virtual bool Selected { get; set; }
		public virtual bool Enabled { get; set; }
		public virtual PanelSide PanelSide { get; set; }
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

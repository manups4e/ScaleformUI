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
		internal dynamic Background;
		protected SizeF Resolution = ScreenTools.ResolutionMaintainRatio;
		public UIMenuPanel()
		{
		}
		public virtual bool Selected { get; set; }
		public virtual bool Enabled { get; set; }
		internal virtual void Position(float y)
		{
		}
		public virtual void UpdateParent()
		{
		}
		internal async virtual Task Draw()
		{
		}

		public void SetParentItem(UIMenuItem item)
		{
			ParentItem = item;
		}

		public UIMenuItem ParentItem { get; set; }

	}
}

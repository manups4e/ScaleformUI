using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ScaleformUI
{
	public class UIMenuSeparatorItem : UIMenuItem
	{
		public bool Jumpable = false;
		/// <summary>
		/// Use it to create an Empty item to separate menu Items
		/// </summary>
		public UIMenuSeparatorItem(string title, bool jumpable) : base(title, "")
		{
			_itemId = 6;
			Jumpable = jumpable;
		}

		public override void SetLeftBadge(BadgeIcon badge)
		{
			throw new Exception("UIMenuSeparatorItem cannot have a left badge.");
		}
		public override void SetRightBadge(BadgeIcon badge)
		{
			throw new Exception("UIMenuSeparatorItem cannot have a right badge.");
		}
		public override void SetRightLabel(string text)
		{
			throw new Exception("UIMenuSeparatorItem cannot have a right label.");
		}
	}
}

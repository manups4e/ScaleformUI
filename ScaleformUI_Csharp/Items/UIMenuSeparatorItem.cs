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
	}
}

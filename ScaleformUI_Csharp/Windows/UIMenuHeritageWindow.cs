using System;
using System.Collections.Generic;
using System.Drawing;
using CitizenFX.Core;
using CitizenFX.Core.Native;
using CitizenFX.Core.UI;

namespace ScaleformUI
{
	public class UIMenuHeritageWindow : UIMenuWindow
	{
		public int Mom { get; set; }
		public int Dad { get; set; }

		public UIMenuHeritageWindow(int mom, int dad)
		{
			Mom = mom;
			Dad = dad;
		}

		public async void Index(int mom, int dad)
		{
			Mom = mom;
			Dad = dad;
			if (mom > 21) Mom = 21;
			if (mom < 0) Mom = 0;
			if (dad > 23) Dad = 23;
			if (dad < 0) Dad = 0;
			var wid = ParentMenu.Windows.IndexOf(this);
			while (!API.HasStreamedTextureDictLoaded("char_creator_portraits"))
			{
				await BaseScript.Delay(0);
				API.RequestStreamedTextureDict("char_creator_portraits", true);
			}
			ScaleformUI._ui.CallFunction("UPDATE_HERITAGE_WINDOW", wid, Mom, Dad);
			API.SetStreamedTextureDictAsNoLongerNeeded("char_creator_portraits");
		}
	}
}

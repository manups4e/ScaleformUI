using CitizenFX.Core;
using CitizenFX.Core.Native;
using System;
using System.Collections.Generic;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ScaleformUI
{
	public class UIMenuProgressItem : UIMenuItem
	{
		protected internal bool Pressed;
		protected internal UIMenuGridAudio Audio;

		protected internal int _value = 0;
		protected internal int _max;
		protected internal int _multiplier = 5;
		protected internal bool Divider;
		protected internal HudColor SliderColor;
		protected internal HudColor BackgroundSliderColor;

		public UIMenuProgressItem(string text, int maxCount, int startIndex) : this(text, maxCount, startIndex, "")
		{
			_max = maxCount;
			_value = startIndex;
		}

		public UIMenuProgressItem(string text, int maxCount, int startIndex, string description, bool heritage = false) : this(text, maxCount, startIndex, description, HudColor.HUD_COLOUR_FREEMODE, HudColor.HUD_COLOUR_PAUSE_BG)
		{
		}

		public UIMenuProgressItem(string text, int maxCount, int startIndex, string description, HudColor sliderColor, HudColor backgroundSliderColor) : base(text, description)
		{
			_max = maxCount;
			_value = startIndex;
			SliderColor = sliderColor;
			BackgroundSliderColor = backgroundSliderColor;
			Audio = new UIMenuGridAudio("CONTINUOUS_SLIDER", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0);
			_itemId = 4;
		}

		public int Value
		{
			get
			{
				return _value;
			}
			set
			{
				if (value > _max)
					_value = _max;
				else if (value < 0)
					_value = 0;
				else
					_value = value;
				ProgressChanged(Value);
			}
		}

		public int Multiplier
		{
			get => _multiplier;
			set =>_multiplier = value;
		}

		/// <summary>
		/// Triggered when the slider is changed.
		/// </summary>
		public event ItemSliderProgressEvent OnSliderChanged;

		internal virtual void ProgressChanged(int value)
		{
			OnSliderChanged?.Invoke(this, value);
		}
	}
}

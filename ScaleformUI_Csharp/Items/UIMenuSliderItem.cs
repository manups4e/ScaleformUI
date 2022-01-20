using System.Collections.Generic;
using System.Drawing;
using System.Threading.Tasks;

namespace ScaleformUI
{
	public class UIMenuSliderItem : UIMenuItem
	{
		protected internal int _value = 0;
		protected internal int _max = 100;
		protected internal int _multiplier = 5;
		protected internal HudColor SliderColor;
		protected internal HudColor BackgroundSliderColor;
		internal bool _heritage;

		/// <summary>
		/// Triggered when the slider is changed.
		/// </summary>
		public event ItemSliderEvent OnSliderChanged;
		public bool Divider;

		/// <summary>
		/// The maximum value of the slider.
		/// </summary>
		public int Maximum
		{
			get
			{
				return _max;
			}
			set
			{
				_max = value;
				if (_value > value)
				{
					_value = value;
				}
			}
		}
		/// <summary>
		/// Curent value of the slider.
		/// </summary>
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
				SliderChanged(_value);
			}
		}
		/// <summary>
		/// The multiplier of the left and right navigation movements.
		/// </summary>
		public int Multiplier
		{
			get
			{
				return _multiplier;
			}
			set
			{
				_multiplier = value;
			}
		}


		/// <summary>
		/// List item, with slider.
		/// </summary>
		/// <param name="text">Item label.</param>
		/// <param name="items">List that contains your items.</param>
		/// <param name="index">Index in the list. If unsure user 0.</param>
		public UIMenuSliderItem(string text) : this(text, "", HudColor.HUD_COLOUR_FREEMODE, HudColor.HUD_COLOUR_PAUSE_BG, false)
		{
		}

		/// <summary>
		/// List item, with slider.
		/// </summary>
		/// <param name="text">Item label.</param>
		/// <param name="items">List that contains your items.</param>
		/// <param name="index">Index in the list. If unsure user 0.</param>
		/// <param name="description">Description for this item.</param>
		public UIMenuSliderItem(string text, string description) : this(text, description, HudColor.HUD_COLOUR_FREEMODE, HudColor.HUD_COLOUR_PAUSE_BG, false)
		{
		}
		public UIMenuSliderItem(string text, string description, bool heritage) : this(text, description, HudColor.HUD_COLOUR_FREEMODE, HudColor.HUD_COLOUR_PAUSE_BG, heritage)
		{
		}

		public UIMenuSliderItem(string text, string description, int max, int mult, int startVal, bool heritage) : this(text, description, HudColor.HUD_COLOUR_FREEMODE, HudColor.HUD_COLOUR_PAUSE_BG, heritage)
		{
			Maximum = max;
			Multiplier = mult;
			Value = startVal;
		}
		/// <summary>
		/// List item, with slider.
		/// </summary>
		/// <param name="text">Item label.</param>
		/// <param name="items">List that contains your items.</param>
		/// <param name="index">Index in the list. If unsure user 0.</param>
		/// <param name="description">Description for this item.</param>
		/// /// <param name="divider">Put a divider in the center of the slider</param>
		public UIMenuSliderItem(string text, string description, HudColor sliderColor, HudColor backgroundSliderColor, bool heritage = false) : base(text, description)
		{
			SliderColor = sliderColor;
			BackgroundSliderColor = backgroundSliderColor;
			_itemId = 3;
			_heritage = heritage;
		}

		internal virtual void SliderChanged(int value)
		{
			OnSliderChanged?.Invoke(this, value);
		}
	}
}

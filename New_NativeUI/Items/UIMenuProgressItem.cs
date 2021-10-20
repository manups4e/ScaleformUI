using CitizenFX.Core;
using CitizenFX.Core.Native;
using System;
using System.Collections.Generic;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace NativeUI
{
	public class UIMenuProgressItem : UIMenuItem
	{
		protected internal bool Pressed;
		protected internal UIMenuGridAudio Audio;
		protected internal bool _heritage;

		protected internal int _value = 0;
		protected internal int _max;
		protected internal int _multiplier = 5;
		protected internal bool Divider;
		protected internal HudColor SliderColor;
		protected internal HudColor BackgroundSliderColor;

		public UIMenuProgressItem(string text, int maxCount, int startIndex, bool heritage = false) : this(text, maxCount, startIndex, "", heritage)
		{
			_max = maxCount;
			_value = startIndex;
		}

		public UIMenuProgressItem(string text, int maxCount, int startIndex, string description, bool heritage = false) : this(text, maxCount, startIndex, description, HudColor.HUD_COLOUR_FREEMODE, HudColor.HUD_COLOUR_PAUSE_BG, heritage)
		{
			_max = maxCount;
			_value = startIndex;
		}

		public UIMenuProgressItem(string text, int maxCount, int startIndex, string description, HudColor sliderColor, HudColor backgroundSliderColor, bool heritage = false) : base(text, description)
		{
			_max = maxCount;
			_value = startIndex;
			SliderColor = sliderColor;
			BackgroundSliderColor = backgroundSliderColor;
			Audio = new UIMenuGridAudio("CONTINUOUS_SLIDER", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0);
			_itemId = 4;
			_heritage = heritage;
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

		/* NON HO MODO DI GESTIRE BENE IL MOUSE PER ORA
		public async void Functions()
		{
				if (API.IsDisabledControlPressed(0, 24))
				{
					if (!Pressed)
					{
						Pressed = true;
						Audio.Id = API.GetSoundId();
						API.PlaySoundFrontend(Audio.Id, Audio.Slider, Audio.Library, true);
					}
							await BaseScript.Delay(0);
							API.BeginScaleformMovieMethod(this.Parent._nativeui.Handle, "GO_DOWN");
							var ret = API.EndScaleformMovieMethodReturnValue();
							while (!API.IsScaleformMovieMethodReturnValueReady(ret)) await BaseScript.Delay(0);
							Value = API.GetScaleformMovieFunctionReturnInt(ret);
			}
			else
				{
					API.StopSound(Audio.Id);
					API.ReleaseSoundId(Audio.Id);
					Pressed = false;
				}
			// DA STUDIARE
			//	else if (ScreenTools.IsMouseInBounds(_arrowLeft.Position, _arrowLeft.Size))
			//	{
			//		if (API.IsDisabledControlPressed(0, 24))
			//		{
			//			Value -= Multiplier;
			//			SliderProgressChanged(Value);
			//		}
			//	}
			//	else if (ScreenTools.IsMouseInBounds(_arrowRight.Position, _arrowRight.Size))
			//	{
			//		if (API.IsDisabledControlPressed(0, 24))
			//		{
			//			Value += Multiplier;
			//			SliderProgressChanged(Value);
			//		}
			//	}
		}
		*/
	}
}

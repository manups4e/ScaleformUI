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
        protected internal HudColor SliderColor
        {
            get => sliderColor;
            set { 
                sliderColor = value;
                if (Parent is not null)
                {
                    ScaleformUI._ui.CallFunction("UPDATE_COLORS", Parent.MenuItems.IndexOf(this), (int)MainColor, (int)HighlightColor, (int)TextColor, (int)HighlightedTextColor, (int)value);
                }
            }
        }
        internal bool _heritage;

        /// <summary>
        /// Triggered when the slider is changed.
        /// </summary>
        public event ItemSliderEvent OnSliderChanged;
        public bool Divider;
        private HudColor sliderColor;

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
        public UIMenuSliderItem(string text) : this(text, "", 100, 5, 0, HudColor.HUD_COLOUR_FREEMODE, false)
        {
        }

        /// <summary>
        /// List item, with slider.
        /// </summary>
        /// <param name="text">Item label.</param>
        /// <param name="items">List that contains your items.</param>
        /// <param name="index">Index in the list. If unsure user 0.</param>
        /// <param name="description">Description for this item.</param>
        public UIMenuSliderItem(string text, string description) : this(text, description, 100, 5, 0, HudColor.HUD_COLOUR_FREEMODE, false)
        {
        }
        public UIMenuSliderItem(string text, string description, bool heritage) : this(text, description, 100, 5, 0, HudColor.HUD_COLOUR_FREEMODE, heritage)
        {
        }

        public UIMenuSliderItem(string text, string description, int max, int mult, int startVal, bool heritage) : this(text, description, max, mult, startVal, HudColor.HUD_COLOUR_FREEMODE, heritage)
        {
        }
        /// <summary>
        /// List item, with slider.
        /// </summary>
        /// <param name="text">Item label.</param>
        /// <param name="items">List that contains your items.</param>
        /// <param name="index">Index in the list. If unsure user 0.</param>
        /// <param name="description">Description for this item.</param>
        /// /// <param name="divider">Put a divider in the center of the slider</param>
        public UIMenuSliderItem(string text, string description, int max, int mult, int startVal, HudColor sliderColor, bool heritage = false) : base(text, description)
        {
            SliderColor = sliderColor;
            _itemId = 3;
            _heritage = heritage;
            Maximum = max;
            Multiplier = mult;
            Value = startVal;
        }

        internal virtual void SliderChanged(int value)
        {
            OnSliderChanged?.Invoke(this, value);
        }
    }
}

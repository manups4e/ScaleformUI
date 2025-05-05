using ScaleformUI.Elements;

namespace ScaleformUI.Menu
{
    public class UIMenuSliderItem : UIMenuItem
    {
        protected internal int _value = 0;
        protected internal int _max = 100;
        protected internal int _multiplier = 5;
        public SColor SliderColor
        {
            get => sliderColor;
            set
            {
                sliderColor = value;
                if (Parent != null && Parent.Visible)
                    Parent.SendItemToScaleform(Parent.MenuItems.IndexOf(this), true);
                if (ParentColumn != null && ParentColumn.visible)
                    ParentColumn.SendItemToScaleform(ParentColumn.Items.IndexOf(this), true);
            }
        }
        internal bool _heritage;

        /// <summary>
        /// Triggered when the slider is changed.
        /// </summary>
        public event ItemSliderEvent OnSliderChanged;
        public bool Divider;
        private SColor sliderColor;

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
                if (Parent != null && Parent.Visible)
                    Parent.SendItemToScaleform(Parent.MenuItems.IndexOf(this), true);
                if (ParentColumn != null && ParentColumn.visible)
                    ParentColumn.SendItemToScaleform(ParentColumn.Items.IndexOf(this), true);
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
                if (Parent != null && Parent.Visible)
                    Parent.SendItemToScaleform(Parent.MenuItems.IndexOf(this), true);
                if (ParentColumn != null && ParentColumn.visible)
                    ParentColumn.SendItemToScaleform(ParentColumn.Items.IndexOf(this), true);
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
                if (Parent != null && Parent.Visible)
                    Parent.SendItemToScaleform(Parent.MenuItems.IndexOf(this), true);
                if (ParentColumn != null && ParentColumn.visible)
                    ParentColumn.SendItemToScaleform(ParentColumn.Items.IndexOf(this), true);
            }
        }


        /// <summary>
        /// List item, with slider.
        /// </summary>
        /// <param name="text">Item label.</param>
        /// <param name="items">List that contains your items.</param>
        /// <param name="index">Index in the list. If unsure user 0.</param>
        public UIMenuSliderItem(string text) : this(text, "", 100, 5, 0, SColor.HUD_Freemode, false)
        {
        }

        /// <summary>
        /// List item, with slider.
        /// </summary>
        /// <param name="text">Item label.</param>
        /// <param name="items">List that contains your items.</param>
        /// <param name="index">Index in the list. If unsure user 0.</param>
        /// <param name="description">Description for this item.</param>
        public UIMenuSliderItem(string text, string description) : this(text, description, 100, 5, 0, SColor.HUD_Freemode, false)
        {
        }
        public UIMenuSliderItem(string text, string description, bool heritage) : this(text, description, 100, 5, 0, SColor.HUD_Freemode, heritage)
        {
        }

        public UIMenuSliderItem(string text, string description, int max, int mult, int startVal, bool heritage) : this(text, description, max, mult, startVal, SColor.HUD_Freemode, heritage)
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
        public UIMenuSliderItem(string text, string description, int max, int mult, int startVal, SColor sliderColor, bool heritage = false) : base(text, description)
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

        public override void SetRightBadge(BadgeIcon badge)
        {
            throw new Exception("UIMenuSliderItem cannot have a right badge.");
        }

        public override void SetRightLabel(string text)
        {
            throw new Exception("UIMenuSliderItem cannot have a right label.");
        }

    }
}

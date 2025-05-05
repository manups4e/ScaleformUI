using ScaleformUI.Elements;

namespace ScaleformUI.Menu
{
    public class UIMenuProgressItem : UIMenuItem
    {
        protected internal bool Pressed;
        protected internal UIMenuGridAudio Audio;

        protected internal int _value = 0;
        protected internal int _max = 100;
        protected internal int _multiplier = 5;
        private SColor sliderColor;
        protected internal bool Divider;
        public SColor SliderColor
        {
            get => sliderColor;
            set
            {
                sliderColor = value;
                if (Parent != null && Parent.Visible)
                    Parent.SendItemToScaleform(Parent.MenuItems.IndexOf(this), true);
            }
        }

        public UIMenuProgressItem(string text, int maxCount, int startIndex) : this(text, maxCount, startIndex, "")
        {
            _max = maxCount;
            _value = startIndex;
        }

        public UIMenuProgressItem(string text, int maxCount, int startIndex, string description, bool heritage = false) : this(text, maxCount, startIndex, description, SColor.HUD_Freemode)
        {
        }

        public UIMenuProgressItem(string text, int maxCount, int startIndex, string description, SColor sliderColor) : base(text, description)
        {
            _max = maxCount;
            _value = startIndex;
            SliderColor = sliderColor;
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
                if (Parent != null && Parent.Visible)
                    Parent.SendItemToScaleform(Parent.MenuItems.IndexOf(this), true);
                if (ParentColumn != null && ParentColumn.visible)
                    ParentColumn.SendItemToScaleform(ParentColumn.Items.IndexOf(this), true);
                ProgressChanged(Value);
            }
        }

        public int Multiplier
        {
            get => _multiplier;
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
        /// Triggered when the slider is changed.
        /// </summary>
        public event ItemSliderProgressEvent OnProgressChanged;

        internal virtual void ProgressChanged(int value)
        {
            OnProgressChanged?.Invoke(this, value);
        }

        public override void SetRightBadge(BadgeIcon badge)
        {
            throw new Exception("UIMenuProgressItem cannot have a right badge.");
        }

        public override void SetRightLabel(string text)
        {
            throw new Exception("UIMenuProgressItem cannot have a right label.");
        }
    }
}

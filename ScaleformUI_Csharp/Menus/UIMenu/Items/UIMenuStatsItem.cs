using ScaleformUI.Elements;

namespace ScaleformUI.Menu
{
    public delegate void StatChanged(int value);
    public class UIMenuStatsItem : UIMenuItem
    {
        private int _value;

        public int Value
        {
            get => _value;
            set
            {
                _value = value;
                SetValue(_value);
            }
        }
        public int Type { get; private set; }
        private SColor sliderColor;
        public SColor Color
        {
            get => sliderColor;
            set
            {
                sliderColor = value;
                //if (Parent is not null && Parent.Visible && Parent.Pagination.IsItemVisible(Parent.MenuItems.IndexOf(this)))
                //{
                //    Main.scaleformUI.CallFunction("UPDATE_COLORS", Parent.Pagination.GetScaleformIndex(Parent.MenuItems.IndexOf(this)), MainColor, HighlightColor, TextColor, HighlightedTextColor, value);
                //}
            }
        }

        public event StatChanged OnStatChanged;

        public UIMenuStatsItem(string text) : this(text, "", 0, SColor.HUD_Freemode)
        {
        }

        public UIMenuStatsItem(string text, string subtitle, int value, SColor color) : base(text, subtitle)
        {
            _itemId = 5;
            Type = 0;
            _value = value;
            sliderColor = color;
        }

        public void SetValue(int value)
        {
            //Main.scaleformUI.CallFunction("SET_ITEM_VALUE", Parent.Pagination.GetScaleformIndex(Parent.MenuItems.IndexOf(this)), value);
            OnStatChanged?.Invoke(value);
        }

        public override void SetLeftBadge(BadgeIcon badge)
        {
            throw new Exception("UIMenuStatsItem cannot have a left badge.");
        }
        public override void SetRightBadge(BadgeIcon badge)
        {
            throw new Exception("UIMenuStatsItem cannot have a right badge.");
        }
        public override void SetRightLabel(string text)
        {
            throw new Exception("UIMenuStatsItem cannot have a right label.");
        }
    }
}

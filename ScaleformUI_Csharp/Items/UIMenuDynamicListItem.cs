using CitizenFX.Core.UI;
using System;
using System.Drawing;
using System.Threading.Tasks;
using Font = CitizenFX.Core.UI.Font;

namespace ScaleformUI
{
    public class UIMenuDynamicListItem : UIMenuItem, IListItem
    {
        public enum ChangeDirection
        {
            Left,
            Right
        }

        public delegate string DynamicListItemChangeCallback(UIMenuDynamicListItem sender, ChangeDirection direction);

        protected UIResText _itemText;
        protected Sprite _arrowLeft;
        protected Sprite _arrowRight;

        public string CurrentListItem { get; internal set; }
        public DynamicListItemChangeCallback Callback { get; set; }

        /// <summary>
        /// List item with items generated at runtime
        /// </summary>
        /// <param name="text">Label text</param>
        public UIMenuDynamicListItem(string text, string startingItem, DynamicListItemChangeCallback changeCallback) : this(text, null, startingItem, changeCallback)
        {
        }

        /// <summary>
        /// List item with items generated at runtime
        /// </summary>
        /// <param name="text">Label text</param>
        /// <param name="description">Item description</param>
        public UIMenuDynamicListItem(string text, string description, string startingItem, DynamicListItemChangeCallback changeCallback) : base(text, description)
        {
            const int y = 0;
            _arrowLeft = new Sprite("commonmenu", "arrowleft", new PointF(110, 105 + y), new SizeF(30, 30));
            _arrowRight = new Sprite("commonmenu", "arrowright", new PointF(280, 105 + y), new SizeF(30, 30));
            _itemText = new UIResText("", new PointF(290, y + 104), 0.35f, Colors.White, Font.ChaletLondon,
                Alignment.Right);

            CurrentListItem = startingItem;
            Callback = changeCallback;
        }

        public override void SetRightBadge(BadgeIcon badge)
        {
            throw new Exception("UIMenuListItem cannot have a right badge.");
        }

        public override void SetRightLabel(string text)
        {
            throw new Exception("UIMenuListItem cannot have a right label.");
        }

        public string CurrentItem()
        {
            return CurrentListItem;
        }
    }
}
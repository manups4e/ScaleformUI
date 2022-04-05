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

        public delegate Task<string> DynamicListItemChangeCallback(UIMenuDynamicListItem sender, ChangeDirection direction);
        private string currentListItem;

        public string CurrentListItem
        {
            get => currentListItem; internal set
            {
                currentListItem = value;
                if(Parent is not null && Parent.Visible)
                {
                    ScaleformUI._ui.CallFunction("UPDATE_LISTITEM_LIST", Parent.MenuItems.IndexOf(this), currentListItem, 0);
                }
            }
        }
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
            _itemId = 1;
            currentListItem = startingItem;
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
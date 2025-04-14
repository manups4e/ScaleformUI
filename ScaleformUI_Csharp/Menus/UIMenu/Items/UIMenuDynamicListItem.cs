using ScaleformUI.Elements;
using ScaleformUI.LobbyMenu;
using ScaleformUI.PauseMenu;
using System;
using System.Reflection;
using System.Threading.Tasks;

namespace ScaleformUI.Menu
{
    public enum ChangeDirection
    {
        Left,
        Right
    }
    public delegate Task<string> DynamicListItemChangeCallback(UIMenuDynamicListItem sender, ChangeDirection direction);
    public class UIMenuDynamicListItem : UIMenuItem, IListItem
    {

        private string currentListItem;

        public string CurrentListItem
        {
            get => currentListItem;
            set
            {
                currentListItem = value;
                if (Parent != null && Parent.Visible)
                    Parent.SendItemToScaleform(Parent.MenuItems.IndexOf(this), true);
                if (ParentColumn != null && ParentColumn.visible)
                    ParentColumn.SendItemToScaleform(ParentColumn.Items.IndexOf(this), true);
            }
        }


        public override bool Enabled
        {
            get => base.Enabled;
            set
            {
                base.Enabled = value;
                if (Parent is not null && Parent.Visible)
                    Parent.SendItemToScaleform(Parent.MenuItems.IndexOf(this), true);
                if (ParentColumn != null && ParentColumn.visible)
                    ParentColumn.SendItemToScaleform(ParentColumn.Items.IndexOf(this), true);
            }
        }

        public override bool Selected
        {
            get => base.Selected;
            set
            {
                base.Selected = value;
                if (Parent is not null && Parent.Visible)
                    Parent.SendItemToScaleform(Parent.MenuItems.IndexOf(this), true);
                if (ParentColumn != null && ParentColumn.visible)
                    ParentColumn.SendItemToScaleform(ParentColumn.Items.IndexOf(this), true);
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

        internal UIMenuDynamicListItem(string text, string description, string startingItem) : base(text, description)
        {
            _itemId = 1;
            currentListItem = startingItem;
        }

        public override void SetRightBadge(BadgeIcon badge)
        {
            throw new Exception("UIMenuDynamicListItem cannot have a right badge.");
        }

        public override void SetRightLabel(string text)
        {
            throw new Exception("UIMenuDynamicListItem cannot have a right label.");
        }

        public string CurrentItem()
        {
            return CurrentListItem;
        }
    }
}
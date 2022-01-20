using System;
using System.Collections.Generic;
using System.Drawing;
using System.Threading.Tasks;
using CitizenFX.Core.UI;

namespace ScaleformUI
{
    public class UIMenuListItem : UIMenuItem, IListItem
    {
        protected internal int _index;
        protected internal List<dynamic> _items;


        /// <summary>
        /// Triggered when the list is changed.
        /// </summary>
        public event ItemListEvent OnListChanged;

        /// <summary>		
        /// Triggered when a list item is selected.		
        /// </summary>		
        public event ItemListEvent OnListSelected;

        /// <summary>
        /// Returns the current selected index.
        /// </summary>
        public int Index
        {
			get { return _index % Items.Count; }
			set { _index = 100000000 - (100000000 % Items.Count) + value; }
		}

		/// <summary>
		/// Returns the current selected index.
		/// </summary>
		public List<object> Items
		{
			get => _items;
			set
			{
				Index = 0;
				_items = value;
			}
		}

		/// <summary>
		/// List item, with left/right arrows.
		/// </summary>
		/// <param name="text">Item label.</param>
		/// <param name="items">List that contains your items.</param>
		/// <param name="index">Index in the list. If unsure user 0.</param>
		public UIMenuListItem(string text, List<dynamic> items, int index) : this(text, items, index, "")
        {
        }

        /// <summary>
        /// List item, with left/right arrows.
        /// </summary>
        /// <param name="text">Item label.</param>
        /// <param name="items">List that contains your items.</param>
        /// <param name="index">Index in the list. If unsure user 0.</param>
        /// <param name="description">Description for this item.</param>
        public UIMenuListItem(string text, List<dynamic> items, int index, string description) : this(text, items, index, description, HudColor.HUD_COLOUR_PAUSE_BG, HudColor.HUD_COLOUR_WHITE)
        {
        }

        public UIMenuListItem(string text, List<dynamic> items, int index, string description, HudColor mainColor, HudColor higlightColor) : this(text, items, index, description, mainColor, higlightColor, HudColor.HUD_COLOUR_WHITE, HudColor.HUD_COLOUR_BLACK)
        {
        }
        
        public UIMenuListItem(string text, List<dynamic> items, int index, string description, HudColor mainColor, HudColor higlightColor, HudColor textColor, HudColor highlightTextColor) : base(text, description, mainColor, higlightColor, textColor, highlightTextColor)
		{
			const int y = 0;
			_items = items;
			Index = index;
			_itemId = 1;
		}


		/// <summary>
		/// Find an item in the list and return it's index.
		/// </summary>
		/// <param name="item">Item to search for.</param>
		/// <returns>Item index.</returns>
		[Obsolete("Use UIMenuListItem.Items.FindIndex(p => ReferenceEquals(p, item)) instead.")]
		public virtual int ItemToIndex(dynamic item)
        {
            return _items.FindIndex(p => ReferenceEquals(p, item));
        }

		/// <summary>
		/// Find an item by it's index and return the item.
		/// </summary>
		/// <param name="index">Item's index.</param>
		/// <returns>Item</returns>
		[Obsolete("Use UIMenuListItem.Items[Index] instead.")]
		public virtual dynamic IndexToItem(int index)
        {
            return _items[index];
        }

        /// <summary>
        /// Add a Panel to the UIMenuListItem
        /// </summary>
        /// <param name="panel"></param>
        public override void AddPanel(UIMenuPanel panel)
        {
            Panels.Add(panel);
            panel.SetParentItem(this);
        }

        internal virtual void ListChangedTrigger(int newindex)
        {
            OnListChanged?.Invoke(this, newindex);
        }

        internal virtual void ListSelectedTrigger(int newindex)
        {
            OnListSelected?.Invoke(this, newindex);
        }

        public void ChangeList(List<dynamic> list, int index)
        {
            _items.Clear();
            _items = list;
            ScaleformUI._ui.CallFunction("UPDATE_LISTITEM_LIST", Parent.MenuItems.IndexOf(this), string.Join(",", _items), index);
        }

        public override void SetRightBadge(BadgeIcon badge)
        {
            throw new Exception("UIMenuListItem cannot have a right badge.");
        }

        public override void SetRightLabel(string text)
        {
            throw new Exception("UIMenuListItem cannot have a right label.");
        }

		[Obsolete("Use UIMenuListItem.Items[Index].ToString() instead.")]
		public string CurrentItem()
        {
            return _items[Index].ToString();
        }
    }
}